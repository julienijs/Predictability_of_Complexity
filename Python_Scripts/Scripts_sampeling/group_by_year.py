import os
import re
from collections import Counter


def group_files_by_year(input_dir, output_dir):
    # Create the output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Get a list of all files in the input directory
    files = os.listdir(input_dir)

    # Group files by year using regular expression
    files_by_year = {}
    pattern = re.compile(r'(\d{4})_')  # Assumes the year is a 4-digit number

    for file in files:
        match = pattern.search(file)
        if match:
            year = match.group(1)
            files_by_year.setdefault(year, []).append(file)

    # Combine files for each year
    year_counts = Counter()
    for year, year_files in files_by_year.items():
        combined_file_path = os.path.join(output_dir, f"combined_{year}.txt")
        with open(combined_file_path, 'w', encoding='utf-8') as combined_file:
            for file in year_files:
                file_path = os.path.join(input_dir, file)
                with open(file_path, 'r', encoding='utf-8') as current_file:
                    combined_file.write("\n")  # Start on a new line
                    combined_file.write(current_file.read())
            year_counts[year] = len(year_files)

    # Print out the count for each year
    print("Year-wise file counts:")
    for year, count in sorted(year_counts.items()):
        print(f"{year}: {count} files")

    print("Files grouped by year successfully!")


input_directory = r''
output_directory = r''

group_files_by_year(input_directory, output_directory)
