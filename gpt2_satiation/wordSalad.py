import sys, random

source = sys.argv[1]
out = source.strip().strip(".txt") + "WS.txt"

input = open(source)
out = open(out, "w")

for line in input.readlines():
    words = line.strip().split()
    words.pop(-1)
    random.shuffle(words)
    salad = ' '.join([word for word in words])
    salad += " ?\n"
    out.write(salad)
input.close()
out.close()
