import os
def main():
    source = sys.argv[1]
    condition = sys.arv[2]
    name = sys.argv[3]
    f = open(source)
    out = open("output/"+name+"_WordByWord_surprisals.csv", "w")
    out.write("sentence,condition,word,surprisal")
    lines = f.readlines()
    lines.pop(0)
    word = 0
    sentence = 1
    for line in lines:
        data = line.strip().split(" ")
        word = data[0]
        surprisal = float(data[1])
        word += 1
        out.write(f'{sentence},{name},{word},{surprisal}')
        if (word in '?.' ):
            word = 0
            sentence += 1
