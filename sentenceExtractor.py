import json
import sys

source = sys.argv[1]

f = open(source)

lines = f.readlines()
clean_lines = []
for line in lines:
    clean_lines.append(line.strip().strip(','))
    
jsons = []
for line in clean_lines:
    jsons.append(json.loads(line))
    
for stim in jsons:
    print("!ARTICLE\n", stim["Target"].strip("?") + " ?")

#print("!ARTICLE\n", jsons[0]["Target"])

