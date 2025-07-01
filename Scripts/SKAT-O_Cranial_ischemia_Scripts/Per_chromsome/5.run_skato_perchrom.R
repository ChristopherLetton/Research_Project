chr  <- commandArgs(trailingOnly=TRUE)[1]
base <- "/scratch/gca_skat_V2"
work <- file.path(base,"chr_work",paste0("chr",chr))

.libPaths(c("/scratch/R_libs", .libPaths()))
library(SKAT)

fam  <- read.table(file.path(work, paste0("chr",chr,".fam")))
fam$PHENO <- ifelse(fam$V6==2,1,0)
null <- SKAT_Null_Model(PHENO ~ 1, out_type="D", data=fam)

info <- Open_SSD(file.path(work, paste0("chr",chr,".SSD")),
                 file.path(work, paste0("chr",chr,".SSD.info")))
res  <- SKATBinary.SSD.All(info, obj=null, method="SKATO")
Close_SSD()

out <- file.path(work, paste0("chr", chr, "_SKAT.tsv"))
write.table(res$results, file=out, sep="\t",
            quote=FALSE, row.names=FALSE)
