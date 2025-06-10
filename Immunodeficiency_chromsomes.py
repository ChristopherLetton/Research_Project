import pandas as pd
import requests
import time
import os
print("Current working directory:", os.getcwd())
print("Files in this directory:", os.listdir())

# Load your Excel file
df = pd.read_excel(r"Primary immunodeficiency or monogenic inflammatory bowel disease.xlsx")

# Extract Ensembl IDs from GRCh38 column
ensembl_ids = df['EnsemblId(GRch38)'].dropna().unique().tolist()

# Function to get chromosome from Ensembl API
def get_chromosome(ensembl_id):
    url = f"https://rest.ensembl.org/lookup/id/{ensembl_id}?content-type=application/json"
    response = requests.get(url)
    if response.ok:
        data = response.json()
        return data.get('seq_region_name', 'NA')
    return 'NA'

# Query chromosomes
chromosome_data = []
for eid in ensembl_ids:
    chrom = get_chromosome(eid)
    chromosome_data.append({'Ensembl_ID': eid, 'Chromosome': chrom})
    time.sleep(0.1)  # polite pause to avoid rate-limiting

# Merge with original data
chrom_df = pd.DataFrame(chromosome_data)
merged_df = df.merge(chrom_df, left_on='EnsemblId(GRch38)', right_on='Ensembl_ID', how='left')

# Save to new Excel file
merged_df.to_excel("Immunodeficiency_with_chromosomes.xlsx", index=False)

print("Saved to 'Immunodeficiency_with_chromosomes.xlsx'")