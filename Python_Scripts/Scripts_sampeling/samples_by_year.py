import os
import random


def sample_lines_from_files(input_dir, output_dir, num_samples_per_file):
    # Create the output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Get a list of all files in the input directory
    files = [file for file in os.listdir(input_dir) if os.path.isfile(os.path.join(input_dir, file))]

    for file in files:
        file_path = os.path.join(input_dir, file)
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as current_file:
            lines = current_file.readlines()

            # Reset num_samples_per_file for each file
            samples_to_take = min(num_samples_per_file, len(lines))

            # Sample random lines per file
            sampled_lines = random.sample(lines, samples_to_take)
            print(str(file) + ": " + str(len(sampled_lines)))

            # Write sampled lines to the output file for each file
            output_file_path = os.path.join(output_dir, f"random_sample_{file}")
            with open(output_file_path, 'w', encoding='utf-8') as output_file:
                for line in sampled_lines:
                    output_file.write(line)

    print(f"Random samples written to {output_dir} successfully!")


input_directory = r''
output_directory = r''
num_samples = 5000

sample_lines_from_files(input_directory, output_directory, num_samples)
