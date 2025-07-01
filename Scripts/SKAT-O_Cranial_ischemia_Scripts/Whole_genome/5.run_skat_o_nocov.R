# Make R see my personal library (contains SKAT, readr, dplyr)
.libPaths(c("/scratch/R_libs", .libPaths()))
library(SKAT)
library(readr)
library(dplyr)

# paths
datapath <- "/scratch/gca_skat_V2/data"

ssd_file  <- file.path(datapath, "LEEDS_CIpheno.SSD")
info_file <- file.path(datapath, "LEEDS_CIpheno.SSD.info")
fam_file  <- file.path(datapath, "LEEDS_Freeze_One.GL.splitmulti.fam")

# Build phenotype-only dataframe
fam <- read.table(fam_file, stringsAsFactors = FALSE)
colnames(fam)[1:6] <- c("FID","IID","PID","MID","SEX","PHENO")

dat <- fam %>%
        mutate(PHENO = ifelse(PHENO == 2, 1, 0)) %>%   # 1 = case, 0 = control
        select(PHENO)                                  # SKAT needs a data.frame

# Intercept-only null model
null_obj <- SKAT_Null_Model(PHENO ~ 1, out_type = "D", data = dat)

# Open SSD and run SKAT-O
SSD_INFO <- Open_SSD(ssd_file, info_file)

skat_res <- SKATBinary.SSD.All(
              SSD_INFO,
              obj    = null_obj,
              method = "SKATO"
            )

Close_SSD()

# Write results
out_tsv <- file.path(datapath, "SKAT_O_noCov_results.tsv")
write.table(
  skat_res$results,
  file      = out_tsv,
  sep       = "\t",
  quote     = FALSE,
  row.names = FALSE
)
