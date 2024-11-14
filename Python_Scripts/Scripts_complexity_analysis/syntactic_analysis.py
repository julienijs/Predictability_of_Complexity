import glob
import os
import random
import gzip
import pandas
import re


def tokenize(s: str) -> list[str]:
    return s.split()


def delete_pct_words(s: str, pct: float = 0.1) -> str:
    word_patt = r"\b([\w'-]+)\b"
    matched_tokens: list[re.Match] = list(re.finditer(word_patt, s))
    tokens_count: int = len(matched_tokens)
    pct_is_k: int = int(tokens_count * pct)
    matches_to_replace: list[re.Match] = random.sample(matched_tokens, k=pct_is_k)
    matches_to_replace.sort(key=lambda x: x.end(), reverse=True)
    for match in matches_to_replace:
        s = s[:match.start(1)] + s[match.end(1):]
    # Clean up double spaces
    # s = re.sub(r"[ ]{2,}", ' ', s)
    # s = re.sub(r"(\n|^)( )(?=\w)", '', s)
    return s


def check_size(file):
    file_stats = os.stat(file)
    file_size = file_stats.st_size
    return file_size


if __name__ == '__main__':
    os.chdir(r'/input_complexity/')
    my_files = glob.glob('*.txt')
    path = r'/workspace/'
    all_unzipped = []
    all_zipped = []
    for my_file in my_files:
        # get size of original file
        original_file_size = check_size(my_file)
        # gzip the original file
        with open(my_file, 'rb') as f_in, gzip.open(path + my_file + '.gz', 'w') as f_out:
            f_out.writelines(f_in)
        # get the file size of the zipped file
        zipped_file_size = check_size(path + my_file + '.gz')
        # open and read the file
        text = open(my_file, "r", encoding='utf-8')
        text = text.read()
        # make list
        zipped = [my_file]
        unzipped = [my_file]
        # do 100 times
        for x in range(100):
            try:
                # randomly delete 10 percent of the characters of the file
                new_text = delete_pct_words(text, 0.1)
                # get the file name
                name = os.path.splitext(my_file)
                # write the distorted text to a new file
                with open(path + name[0] + '_deletion.txt', 'w', encoding='utf-8') as new_file:
                    new_file.write(new_text)
                # get the file size of the distorted file
                distorted_file_size = check_size(path + name[0] + '_deletion.txt')
                # add the file size of the distorted file to unzipped list
                unzipped.append(distorted_file_size)
                assert os.path.isfile(path + name[0] + '_deletion.txt')
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
        # add unzipped to all_unzipped
        all_unzipped.append(unzipped)
        # add zipped to all_unzipped
        all_zipped.append(zipped)
    df_unzipped = pandas.DataFrame(all_unzipped)
    df_zipped = pandas.DataFrame(all_zipped)
    df_zipped.to_excel('Synt_Zipped.xlsx')
    df_unzipped.to_excel('Synt_Unzipped.xlsx')
