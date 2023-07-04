import json
import sys

source = sys.argv[1]
dest = sys.argv[2]

f = open(source)
out = open(dest, "w")
lines = f.readlines()
clean_lines = []
for line in lines:
    clean_lines.append(line.strip().strip(','))


jsons = []
for line in clean_lines:
    jsons.append(json.loads(line))
    
for stim in jsons:
    out.write("!ARTICLE\n")
    out.write(stim["Target"].strip("?") + " ?\n")
out.close()
#print("!ARTICLE\n", jsons[0]["Target"])

