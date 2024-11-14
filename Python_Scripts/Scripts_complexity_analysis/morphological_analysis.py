import glob
import os
import math
import random
import gzip
import pandas


def count_characters(file):
    data = file.replace(" ", "")
    number_of_characters = len(data)
    return number_of_characters


def calculate_10_percent(num):
    return math.ceil((num / 100) * 10)


def delete_characters(f, n):
    # Convert the string to a list of characters for easier manipulation
    f_list = list(f)

    for _ in range(n):
        index = random.randint(0, len(f_list) - 1)

        # Ensure that the character at the chosen index is not a whitespace
        while f_list[index].isspace():
            index = random.randint(0, len(f_list) - 1)

        # Remove the character at the chosen index
        del f_list[index]

    # Convert the list back to a string
    return ''.join(f_list)


def check_size(file):
    file_stats = os.stat(file)
    file_size = file_stats.st_size
    return file_size


if __name__ == '__main__':
    os.chdir(r'/input_complexity/')
    my_files = glob.glob('*.txt')
    path = r'/workspace/'
    all_zipped = []
    for my_file in my_files:
        # open and read the file
        text = open(my_file, "r", encoding='utf-8')
        text = text.read()
        # get the total number of characters of the file
        number = count_characters(text)
        # calculate 10 percent of the total number of characters
        number_to_delete = calculate_10_percent(number)
        zipped = [my_file]
        # get the file name
        name = os.path.splitext(my_file)
        for x in range(100):
            print(x)
            try:
                # randomly delete 10 percent of the characters of the file
                new_text = delete_characters(text, number_to_delete)
                # write the distorted text to a new file
                with open(path + name[0] + '_deletion.txt', 'w', encoding='utf-8') as new_file:
                    new_file.write(new_text)
                # gzip the distorted file
                with open(path + name[0] + '_deletion.txt', 'rb') as in_f, gzip.open(
                        path + name[0] + '_deletion.txt' + '.gz', 'w') as out_f:
                    out_f.writelines(in_f)
                # get file size zipped and distorted file
                zipped_distorted_file_size = check_size(path + name[0] + '_deletion.txt.gz')
                # add the file size of the distorted zipped file to zipped list
                zipped.append(zipped_distorted_file_size)
            except:
                print(my_file)
        # add zipped to all_unzipped
        all_zipped.append(zipped)
    df_zipped = pandas.DataFrame(all_zipped)
    df_zipped.to_excel('Morph_Zipped.xlsx')
