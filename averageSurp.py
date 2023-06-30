import sys

source = sys.argv[1]

f = open(source)

sentence_id = 2
curr_total = 0
num_words = 0
lines = f.readlines()
lines.pop(0)
print('"sentence_id","mean_surprisal"')
for line in lines:
    data = line.strip().split(" ")
    word = data[0]
    surprisal = float(data[1])
    num_words += 1
    curr_total += surprisal
    if (word == '?'):
        print(f'{sentence_id},{curr_total / num_words}')
        sentence_id += 1
        curr_total = 0
        num_words = 0
