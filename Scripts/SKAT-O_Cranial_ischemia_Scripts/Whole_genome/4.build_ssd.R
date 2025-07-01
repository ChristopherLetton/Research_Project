# make R see my personal library
.libPaths(c("/scratch/R_libs", .libPaths()))
library(SKAT)

# file paths
bed  <- "/scratch/gca_skat_V2/data/LEEDS_Freeze_One.GL.splitmulti.bed"
bim  <- "/scratch/gca_skat_V2/data/LEEDS_Freeze_One.GL.splitmulti.bim"
fam  <- "/scratch/gca_skat_V2/data/LEEDS_Freeze_One.GL.splitmulti.fam"
setid<- "/scratch/gca_skat_V2/data/SetID_nodup.txt"

ssd  <- "/scratch/gca_skat_V2/data/LEEDS_CIpheno.SSD"
info <- "/scratch/gca_skat_V2/data/LEEDS_CIpheno.SSD.info"

# build SSD
cat("Creating SSD …\n")
Generate_SSD_SetID(
  File.Bed   = bed,
  File.Bim   = bim,
  File.Fam   = fam,
  File.SetID = setid,
  File.SSD   = ssd,
  File.Info  = info
)
