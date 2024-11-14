import glob
import os
import re


def clean(text):
    # set everything to lower caps
    text = text.lower()
    # remove everything except for word characters, spaces, and tabs
    text = re.sub(r'[^\w\s\t]', '', text)
    # remove consecutive spaces and tabs
    text = re.sub(r' +|\t+', ' ', text)
    # remove leading and trailing whitespace
    text = re.sub(r'^\s+|\s+$', '', text, flags=re.MULTILINE)
    # remove lines containing '@'
    text = re.sub(r'.*@.*\n', '', text)
    # return text
    return text


def process_text(text):
    # Remove original line breaks and replace with space
    text = text.replace('\r', ' ').replace('\n', ' ')

    # Remove leading whitespace from each line
    text = re.sub(r'^\s+', '', text, flags=re.MULTILINE)

    # Insert a newline after every sentence
    processed_text = re.sub(r'(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|!|\?|")\s', '\n', text)

    return processed_text


if __name__ == '__main__':
    os.chdir(r'')
    my_files = glob.glob('*.txt')
    path = r''

    for my_file in my_files:
        input_file_path = os.path.join(os.getcwd(), my_file)
        output_file_path = os.path.join(path, my_file)

        with open(input_file_path, "r", errors='replace') as file:
            my_text = file.read()

        my_text = process_text(my_text)
        my_text = clean(my_text)

        with open(output_file_path, 'w', encoding='utf-8') as file:
            file.write(my_text)

        print(f"Processing of {my_file} completed.")
