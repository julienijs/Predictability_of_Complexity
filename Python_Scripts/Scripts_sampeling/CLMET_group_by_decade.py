import os
import pandas as pd
from collections import Counter


def group_files_by_decade_from_meta(input_dir, output_dir, meta_file):
    # Create the output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Load metadata from Excel
    metadata = pd.read_excel(meta_file)

    # Ensure required columns exist
    if 'decade' not in metadata.columns or 'file' not in metadata.columns:
        raise ValueError("The Excel file must contain 'decade' and 'file' columns.")

    # Group files by decade
    files_by_decade = metadata.groupby('decade')['file'].apply(list).to_dict()

    # Combine files for each decade
    decade_counts = Counter()
    for decade, filenames in files_by_decade.items():
        combined_file_path = os.path.join(output_dir, f"combined_{decade}.txt")
        with open(combined_file_path, 'w', encoding='utf-8') as combined_file:
            for filename in filenames:
                file_path = os.path.join(input_dir, filename)
                if os.path.exists(file_path):
                    with open(file_path, 'r', encoding='utf-8') as current_file:
                        combined_file.write("\n")  # Start on a new line
                        combined_file.write(current_file.read())
                    decade_counts[decade] += 1
                else:
                    print(f"Warning: {filename} not found in {input_dir}.")

    # Print out the count for each decade
    print("Decade-wise file counts:")
    for decade, count in sorted(decade_counts.items()):
        print(f"{decade}: {count} files")

    print("Files grouped by decade successfully!")


# Define input, output, and meta file paths
input_directory = r''
output_directory = r''
meta_file = r'CLMET_Metadata.xlsx'

# Run the function
group_files_by_decade_from_meta(input_directory, output_directory, meta_file)
