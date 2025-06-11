
#!/bin/bash
#SBATCH --job-name=plink_split
#SBATCH --array=1-22
#SBATCH --time=00:30:00
#SBATCH --mem=4G
#SBATCH --chdir=/scratch/jsxm6270/data
#SBATCH --output=/scratch/jsxm6270/data/chromosome_separate/logs/plink_%a.out
#SBATCH --error=/scratch/jsxm6270/data/chromosome_separate/logs/plink_%a.err

PLINK_EXE="/scratch/jsxm6270/tools/plink"

DATA_PREFIX="/scratch/jsxm6270/data/LEEDS_Freeze_One.GL.splitmulti"
OUTROOT="/scratch/jsxm6270/data/chromosome_separate"
mkdir -p "$OUTROOT/logs"

CHR=${SLURM_ARRAY_TASK_ID}

"$PLINK_EXE" --bfile "$DATA_PREFIX" \
      --chr-set 22 --chr "$CHR" \
      --make-bed \
      --out "${OUTROOT}/chromosome${CHR}"

echo "Finished chromosome $CHR"
