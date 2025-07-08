#!/usr/bin/env bash
# Run the 5-step SKAT-O pipeline for ONE chromosome, wiring the steps together
# with SLURM dependencies and chromosome-specific job names.
# Usage:  ./run_chr_chain.sh  <chromosome 1-22 or X>

CHR=$1
if [[ -z "$CHR" ]]; then
    echo "Usage: $0 <chromosome 1-22 or X>" ; exit 1
fi

cd /scratch/jsxm6270/gca_skat_V2/scripts

# ─── STEP 1 extract ──────────────────────────────────────────────────────────
jid1=$(sbatch --parsable \
      --job-name=chr${CHR}_extract \
      extract_chr.sh "$CHR")

# ─── STEP 2 MAF filter (after STEP 1) ────────────────────────────────────────
jid2=$(sbatch --parsable \
      --dependency=afterok:${jid1} \
      --job-name=chr${CHR}_maf \
      filter_maf.sh "$CHR")

# ─── STEP 3 build SetID (after STEP 2) ───────────────────────────────────────
jid3=$(sbatch --parsable \
      --dependency=afterok:${jid2} \
      --job-name=chr${CHR}_setid \
      build_setid_perchrom.sh "$CHR")

# ─── STEP 4 build SSD/Info (after STEP 3) ────────────────────────────────────
jid4=$(sbatch --parsable \
      --dependency=afterok:${jid3} \
      --job-name=chr${CHR}_ssd \
      build_ssd_perchrom.sh "$CHR")

# ─── STEP 5 run SKAT-O (after STEP 4) ────────────────────────────────────────
jid5=$(sbatch --parsable \
      --dependency=afterok:${jid4} \
      --job-name=chr${CHR}_skato \
      run_skato_perchrom.sh "$CHR")

echo "Chromosome ${CHR} job chain submitted:"
echo "  extract → ${jid1}"
echo "  maf     → ${jid2}"
echo "  setid   → ${jid3}"
echo "  ssd     → ${jid4}"
echo "  skato   → ${jid5}"
