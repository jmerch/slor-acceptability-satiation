import sys

source = sys.argv[1]
dest = sys.argv[2]

input = open(source)
out = open(dest, "w")
lines = input.readlines()
inContext = True
out.write(lines.pop(0))
for line in lines:
    if not inContext:
        out.write(line.strip() + "\n")
    if "? " in line or ". " in line:
        inContext = not inContext
input.close()
out.close()
