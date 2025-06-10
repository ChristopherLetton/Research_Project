import pandas as pd
import os

# Set working directory (update if needed)
os.chdir(r"C:\Users\chris\OneDrive - University of Leeds\Modules\.Research Project\Scripts")

# Load Excel files
df1 = pd.read_excel("Autoinflammatory_with_chromosomes.xlsx")
df2 = pd.read_excel("Immunodeficiency_with_chromosomes.xlsx")

# Combine 'Chromosome' columns
chromosomes = pd.concat([
    df1['Chromosome'].dropna(),
    df2['Chromosome'].dropna()
])

# Get unique values
unique_chroms = chromosomes.unique()

# Define sort key function
def chrom_sort_key(chrom):
    try:
        return int(chrom)  # Numbers 1–22
    except ValueError:
        if chrom == 'X':
            return 23
        elif chrom == 'Y':
            return 24
        elif chrom == 'MT' or chrom == 'M':
            return 25
        else:
            return 26  # Anything else at the end

# Sort chromosomes using the key
sorted_chroms = sorted(unique_chroms, key=chrom_sort_key)

# Output result
print("Unique chromosomes in size order:")
print(sorted_chroms)