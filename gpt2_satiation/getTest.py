import sys
source = sys.argv[1]
dest = f'{source}_test.txt'

input = open(f'{source}.txt')
lines = input.readlines()

out = open(dest, "w")
for line in lines:
    out.write('!ARTICLE\n')
    out.write(line)