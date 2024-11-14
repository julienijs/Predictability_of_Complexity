import os
import json
from bs4 import BeautifulSoup

# Define directories
json_dir = r'\metadata'
xml_dir = r'\text'
output_dir = r'\plain_text'

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)


def sanitize_filename(filename):
    # Replace invalid characters with underscore
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        filename = filename.replace(char, '_')
    return filename


# Iterate over JSON files
for json_file in os.listdir(json_dir):
    if json_file.endswith('.json'):
        with open(os.path.join(json_dir, json_file), 'r', encoding='utf-8') as f:
            data = json.load(f)

        # Extract data from JSON
        xml_filename = data.get('id')
        date = data.get('dates')
        title = data.get('titre')

        # Check if corresponding XML file exists
        xml_path = os.path.join(xml_dir, xml_filename)
        if os.path.exists(xml_path):
            # Parse XML and extract text using BeautifulSoup with lxml parser
            with open(xml_path, 'r', encoding='utf-8') as xml_file:
                soup = BeautifulSoup(xml_file, 'lxml')  # Specify 'lxml' parser
                body = soup.find('body')  # Adjust the tag name if necessary

                # Extract words from 'word' attribute in <x:wf> tags and handle <lb> tags for line breaks
                text_content = []
                if body:
                    for element in body.find_all(['x:wf', 'lb']):
                        if element.name == 'x:wf':
                            word = element.get('word')
                            if word:
                                text_content.append(word)
                        elif element.name == 'lb':
                            text_content.append('\n')  # Add a line break

                # Join words and line breaks
                final_text = ' '.join(text_content).replace(' \n ', '\n').replace('\n ', '\n').replace(' \n', '\n')
                final_text = final_text.replace('.', 'X\n')  # Add a line break after "."
                final_text = final_text.replace('!', 'X\n')  # Add a line break after "!"
                final_text = final_text.replace('?', 'X\n')  # Add a line break after "?"
                final_text = "".join([s for s in final_text.splitlines(True) if s.strip("\r\n")])  # Remove empty lines

            # Generate new filename
            clean_title = sanitize_filename(title)
            new_filename = f"{date}_{clean_title}.txt"

            # Write to new file
            with open(os.path.join(output_dir, new_filename), 'w', encoding='utf-8') as output_file:
                output_file.write(final_text)
        else:
            print(f"Warning: XML file {xml_filename} not found for JSON {json_file}")
