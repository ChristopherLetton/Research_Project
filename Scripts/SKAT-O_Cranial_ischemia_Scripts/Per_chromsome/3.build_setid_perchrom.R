args <- commandArgs(trailingOnly = TRUE)
chr  <- args[1]
base <- "/scratch/gca_skat_V2"
work <- file.path(base, "chr_work", paste0("chr", chr))

.libPaths(c("/scratch/R_libs", .libPaths()))
library(readr); library(dplyr)

rare <- read_lines(file.path(work, paste0("rare_chr", chr, ".snplist")))

vep  <- read_tsv(file.path(base, "data", "LEEDS_CIpheno.vep.tsv"),
                 comment="##", show_col_types=FALSE) |>
        select(SNP_ID = `#Uploaded_variation`, GeneID = Gene) |>
        filter(SNP_ID %in% rare, !is.na(GeneID), GeneID != "") |>
        distinct(GeneID, SNP_ID)

out  <- file.path(work, paste0("SetID_chr", chr, ".txt"))
write.table(vep, file = out, sep = "\t",
            quote = FALSE, row.names = FALSE, col.names = FALSE)
