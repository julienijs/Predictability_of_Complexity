import glob
import os
import re
import random


def clean(text):
    # delete tags
    text = re.sub(r'<[^<>]*>', '', str(text))
    # set everything to lower caps
    text = text.lower()
    # remove everything except for word characters and spaces
    text = re.sub(r'[^\w\s]', '', str(text))
    # remove double spaces
    text = re.sub(r'  ', ' ', str(text))
    # return text
    return text


if __name__ == '__main__':
    os.chdir(r'')
    my_files = glob.glob('un_*')
    output_path = r''
    for my_file in my_files:
        with open(my_file, "r", encoding='utf-8') as f:
            my_text = f.read()
        my_text = clean(my_text)
        lines = my_text.split('\n')

        # If the file has more than 5000 lines, sample 5000 randomly; otherwise, use all lines
        if len(lines) > 5000:
            lines = random.sample(lines, 5000)

        my_text = '\n'.join(lines)

        # Ensure the file is saved with a .txt extension
        output_file_name = os.path.basename(my_file) + '.txt'
        output_file = os.path.join(output_path, output_file_name)
        with open(output_file, 'w', encoding='utf-8') as new_file:
            new_file.write(my_text)
