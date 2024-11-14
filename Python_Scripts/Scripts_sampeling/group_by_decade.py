import os
import re
from collections import Counter

def group_files_by_decade(input_dir, output_dir):
    # Create the output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Get a list of all files in the input directory
    files = os.listdir(input_dir)

    # Group files by decade using regular expression
    files_by_decade = {}
    pattern = re.compile(r'(\d{4})_')  # Assumes the year is a 4-digit number

    for file in files:
        match = pattern.search(file)
        if match:
            year = int(match.group(1))
            decade = (year // 10) * 10  # Get the decade (e.g., 1990s, 2000s)
            decade_str = f"{decade}s"
            files_by_decade.setdefault(decade_str, []).append(file)

    # Combine files for each decade
    decade_counts = Counter()
    for decade, decade_files in files_by_decade.items():
        combined_file_path = os.path.join(output_dir, f"combined_{decade}.txt")
        with open(combined_file_path, 'w', encoding='utf-8') as combined_file:
            for file in decade_files:
                file_path = os.path.join(input_dir, file)
                with open(file_path, 'r', encoding='utf-8') as current_file:
                    combined_file.write("\n")  # Start on a new line
                    combined_file.write(current_file.read())
            decade_counts[decade] = len(decade_files)

    # Print out the count for each decade
    print("Decade-wise file counts:")
    for decade, count in sorted(decade_counts.items()):
        print(f"{decade}: {count} files")

    print("Files grouped by decade successfully!")

input_directory = r''
output_directory = r''

group_files_by_decade(input_directory, output_directory)
