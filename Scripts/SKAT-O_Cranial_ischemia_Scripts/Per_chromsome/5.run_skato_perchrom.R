chr  <- commandArgs(trailingOnly=TRUE)[1]
base <- "/scratch/gca_skat_V2"
work <- file.path(base,"chr_work",paste0("chr",chr))

.libPaths(c("/scratch/R_libs", .libPaths()))
library(SKAT)

fam   <- read_table2(file.path(work, paste0("chr", chr, ".fam")),
                     col_names = FALSE,
                     col_types = cols(.default = "c"))
fam <- fam %>% transmute(IID = X2, PHENO = ifelse(X6 == 2, 1, 0))

covar <- read_csv(file.path(base, "data", "covars.csv"))

dat <- fam %>%
       inner_join(covar, by = "IID") %>%
       mutate(SEX = factor(SEX, levels = c(1, 2), labels = c("M", "F")))

null_formula <- PHENO ~ SEX + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10
null_obj     <- SKAT_Null_Model(null_formula, out_type = "D", data = dat)

info <- Open_SSD(file.path(work, paste0("chr",chr,".SSD")),
                 file.path(work, paste0("chr",chr,".SSD.info")))
res  <- SKATBinary.SSD.All(info, obj=null, method="SKATO")
Close_SSD()

out <- file.path(work, paste0("chr", chr, "_SKAT.tsv"))
write.table(res$results, file=out, sep="\t",
            quote=FALSE, row.names=FALSE)
cat("✅ SKAT-O done for chr", chr, "\n")
