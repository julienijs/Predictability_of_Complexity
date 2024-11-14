import glob
import os
import re
import pandas
from bs4 import BeautifulSoup


def get_metadata(text):
    soup = BeautifulSoup(text)
    file = soup.find("file")
    file = re.sub(r'<[^<>]*>', '', str(file))
    period = soup.find("period")
    period = re.sub(r'<[^<>]*>', '', str(period))
    quartcent = soup.find("quartcent")
    quartcent = re.sub(r'<[^<>]*>', '', str(quartcent))
    decade = soup.find("decade")
    decade = re.sub(r'<[^<>]*>', '', str(decade))
    year = soup.find("year")
    year = re.sub(r'<[^<>]*>', '', str(year))
    genre = soup.find("genre")
    genre = re.sub(r'<[^<>]*>', '', str(genre))
    subgenre = soup.find("subgenre")
    subgenre = re.sub(r'<[^<>]*>', '', str(subgenre))
    title = soup.find("title")
    title = re.sub(r'<[^<>]*>', '', str(title))
    author = soup.find("author")
    author = re.sub(r'<[^<>]*>', '', str(author))
    gender = soup.find("gender")
    gender = re.sub(r'<[^<>]*>', '', str(gender))
    author_birth = soup.find("author_birth")
    author_birth = re.sub(r'<[^<>]*>', '', str(author_birth))
    m = {"file": file, "period": period, "quartcent": quartcent, "decade": decade, "year": year, "genre": genre,
         "subgenre": subgenre, "title": title, "author": author, "gender": gender, "author_birth": author_birth}
    return m


def clean(lines):
    new_lines = []
    for line in lines:
        if not line.startswith('<'):
            line = line.lower()
            line = re.sub(r'[^a-z\s]', '', str(line))
            line = re.sub(r'  ', ' ', str(line))
            if line != '\n':
                if not line.isspace():
                    new_lines.append(line)
    return new_lines


if __name__ == '__main__':
    os.chdir(r'')
    my_files = glob.glob('*.txt')
    path = r''
    metadata = []
    for my_file in my_files:
        my_text = open(my_file, "r", encoding='utf-8')
        my_lines = my_text.readlines()
        my_text = my_text.read()
        meta = get_metadata(my_text)
        metadata.append(meta)
        my_lines = clean(my_lines)
        with open(path + my_file, 'w', encoding='utf-8') as new_file:
            new_file.writelines(my_lines)
    # write metadata to excel file
    df = pandas.DataFrame.from_dict(metadata)
    df.to_excel('CLMET_Metadata.xlsx')
