RUN=Cipermtrans # your run tag
BASE=/scratch/jsxm6270/gca_skat_${RUN}
cd ${BASE}/chr_work
# header once
head -n 1 chr1/chr1_SKAT.tsv \
  > ${BASE}/data/SKAT_${RUN}_combined.tsv
# append every chromosome
for chr in {1..22} ; do
    tail -n +2 chr${chr}/chr${chr}_SKAT.tsv \
      >> ${BASE}/data/SKAT_${RUN}_combined.tsv
done
