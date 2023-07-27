import sys

source = sys.argv[1]
condition = sys.argv[2]
#name = sys.argv[3]
f = open(source)
out = open("output/"+condition+"_WordByWord_surprisals.csv", "w")
out.write("sentence,condition,word,surprisal\n")
lines = f.readlines()
lines.pop(0)
word_num = 0
sentence = 1
for line in lines:
    data = line.strip().split(" ")
    word = data[0]
    surprisal = float(data[1])
    word_num += 1
    out.write(f'{sentence},{condition},{word_num},{surprisal}\n')
    if (word in '?.' ):
        word_num = 0
        sentence += 1
out.close()
f.close()
