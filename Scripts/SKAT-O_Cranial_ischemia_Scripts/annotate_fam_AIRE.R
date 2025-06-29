
# ---- make R see the personal library ----
.libPaths(c("/scratch/R_libs", .libPaths()))

setwd("/scratch/gca_skat_V2/data")

library(dplyr)
library(readr)

# Load files
pheno <- read_csv("Regeneron UK GCA clinical data Nov 2024 - Copy.csv")
linker <- read_csv("Regeneron UK GCA ID Key.csv")

# Join phenotype and linker by 'Adm_RegDatabaseID'
pheno_joined <- linker %>%
  inner_join(pheno, by = "Adm_RegDatabaseID")

# Annotate cases and controls
pheno_joined <- pheno_joined %>%
  mutate(PHENO = ifelse(CIMtotal == "any cranial ischaemic complications (i.e. permanent)", 2, 1))

# Load original .fam file
fam <- read.table("LEEDS_Freeze_One.GL.splitmulti.fam", header=FALSE)

# Update .fam phenotype column
fam_updated <- fam %>%
  left_join(pheno_joined, by = c("V2" = "Sample Name")) %>%
  mutate(V6 = ifelse(is.na(PHENO), 0, PHENO)) %>%
  select(V1:V6)

# Save updated .fam
write.table(fam_updated, file="LEEDS_CIpheno.fam",
            col.names=FALSE, row.names=FALSE, sep="\t", quote=FALSE)
