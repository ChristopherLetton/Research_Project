.libPaths(c("/scratch/R_libs", .libPaths()))

library(readr)
library(dplyr)

# Set the 'run' name
run <- "V2"

# Set base path
base <- paste0("/scratch/gca_skat_", run, "/data")

# File paths
infile <- file.path(base, paste0("SKAT_", run, "_combined.tsv"))
outfile <- file.path(base, paste0("SKAT_", run, "_combined_adj.tsv"))

# Read, adjust P-values, sort
res <- read_tsv(infile, show_col_types = FALSE)
n <- nrow(res)

res <- res %>%
  mutate(
    Bonf = p.adjust(P.value, "bonferroni"),
    FDR  = p.adjust(P.value, "BH")
  ) %>%
  arrange(P.value)

# Write output
write_tsv(res, outfile)
cat("✅  Combined table with Bonf & FDR written to:\n  ", outfile, "\n")
