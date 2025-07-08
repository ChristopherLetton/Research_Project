# edit paths if yours differ
base   <- "/scratch/gca_skat_V2"
data   <- file.path(base, "data")
plink  <- file.path(data, "LEEDS_Freeze_One.GL.splitmulti")

# ─── libraries ─────────────────────────────────────────────
.libPaths(c("/scratch/R_libs", .libPaths()))
library(readr)   # CSV reader
library(dplyr)   # join + mutate

# ─── read input tables ─────────────────────────────────────
clin   <- read_csv(file.path(data,
                             "Regeneron UK GCA clinical data Nov 2024 - Copy.csv"),
                   show_col_types = FALSE)      # has SAMPLE_ID, SEX, CIMtotal

linker <- read_csv(file.path(data,
                             "Regeneron UK GCA ID Key.csv"),
                   show_col_types = FALSE)      # maps clinical → Sample_Name

fam    <- read_table2(paste0(plink, ".fam"),
                      col_names = c("FID","IID","PID","MID","SEX","PHENO"))

# ─── make a lookup table with Sample_Name + SEX ────────────
sex_lut <- clin %>%
  select(ClinID = `Adm_RegDatabaseID`, SEX = `N7_Sex`)
# 1 = male, 2 = female.
sex_lut <- sex_lut %>%
  mutate(SEX = case_when(
    SEX %in% c("M","male", "MALE", 1) ~ 1,
    SEX %in% c("F","female","FEMALE", 2) ~ 2,
    TRUE ~ 0  # unknown
  ))

# linker: ClinID → Sample_Name_used_in_fam
sex_lut <- sex_lut %>%
  left_join(linker, by = c("ClinID" = "Adm_RegDatabaseID")) %>% 
  select(Sample_Name = `Sample Name`, SEX)

# ─── join onto fam & update column 5 ───────────────────────
fam_upd <- fam %>%
  left_join(sex_lut, by = c("IID" = "Sample_Name")) %>%
  mutate(SEX = coalesce(SEX.y, SEX.x, 0)) %>%     # prefer clinical
  select(FID, IID, PID, MID, SEX, PHENO)

write.table(fam_upd,
            file = paste0(plink, ".fam"),  # overwrite or new file
            sep  = " ", quote = FALSE,
            row.names = FALSE, col.names = FALSE)

cat("✅  fam updated.  Sex codes:\n")
print(table(fam_upd$SEX, useNA = "ifany"))
