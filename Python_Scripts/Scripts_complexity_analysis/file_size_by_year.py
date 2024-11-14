import os
import glob
import pandas
import re


def check_size(file):
    file_stats = os.stat(file)
    file_size = file_stats.st_size
    return file_size


def get_year(file):
    year_match = re.search(r'(\d{4})', file)
    file_year = int(year_match.group())
    return file_year


def no_extensions(file):
    f_name = file.split(".")
    return f_name[0]


if __name__ == '__main__':
    my_dict = {'filename': [],
               'year': [],
               'size': []}
    os.chdir(r'/zipped')
    my_files = glob.glob('*.gz')
    for my_file in my_files:
        size = check_size(my_file)
        year = get_year(my_file)
        filename = no_extensions(my_file)
        my_dict["filename"].append(filename)
        my_dict["year"].append(int(year))
        my_dict["size"].append(size)
    data = pandas.DataFrame.from_dict(my_dict)
    print(data)
    #data.to_excel('CCLAMP_by_year_Zipped_Sizes.xlsx')
    data.to_excel('CLMET_Zipped_Sizes.xlsx')
