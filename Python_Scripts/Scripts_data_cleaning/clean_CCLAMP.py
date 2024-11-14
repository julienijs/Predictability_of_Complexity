import glob
import os
import re


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
    my_files = glob.glob('*.txt')
    path = r''
    for my_file in my_files:
        my_text = open(my_file, "r", encoding='utf-8')
        my_text = my_text.read()
        my_text = clean(my_text)
        with open(path + my_file, 'w', encoding='utf-8') as new_file:
            new_file.write(my_text)
