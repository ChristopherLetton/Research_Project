# Tell R to look in my scratch library for packages
.libPaths(c("/scratch/R_libs", .libPaths()))

library(readr)
library(dplyr)

# input files
rare_file <- "/scratch/gca_skat_V2/data/rare_variants.snplist"
vep_file  <- "/scratch/gca_skat_V2/data/LEEDS_CIpheno.vep.tsv"

# output file
out_file  <- "/scratch/gca_skat_V2/data/SetID.txt"

# Load the list of rare variant IDs (one per line)
rare_ids <- read_lines(rare_file)

# Read just the header + data rows (skip the '##' metadata lines)
vep <- read_tsv(
          vep_file,
          comment = "##",
          show_col_types = FALSE
       ) %>%
       # Keep only the two columns I need: variant ID and Ensembl Gene ID
       select(
         SNP_ID = `#Uploaded_variation`,
         GeneID = Gene
       ) %>%
       # Restrict to rare variants present in the dataset
       filter(
         SNP_ID %in% rare_ids,
         !is.na(GeneID),
         GeneID != ""
       )

# Write the SetID file (no header, tab-separated)
write.table(
  vep[, c("GeneID", "SNP_ID")],
  file      = out_file,
  sep       = "\t",
  quote     = FALSE,
  row.names = FALSE,
  col.names = FALSE
)
