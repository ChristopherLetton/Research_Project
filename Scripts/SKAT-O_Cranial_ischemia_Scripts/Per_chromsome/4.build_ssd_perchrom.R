chr  <- commandArgs(trailingOnly=TRUE)[1]
base <- "/scratch/gca_skat_V2"
work <- file.path(base,"chr_work",paste0("chr",chr))

.libPaths(c("/scratch/R_libs", .libPaths()))
library(SKAT)

Generate_SSD_SetID(
  File.Bed   = file.path(work, paste0("chr", chr, ".bed")),
  File.Bim   = file.path(work, paste0("chr", chr, ".bim")),
  File.Fam   = file.path(work, paste0("chr", chr, ".fam")),
  File.SetID = file.path(work, paste0("SetID_chr", chr, ".txt")),
  File.SSD   = file.path(work, paste0("chr", chr, ".SSD")),
  File.Info  = file.path(work, paste0("chr", chr, ".SSD.info"))
)
