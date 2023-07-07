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
    
out.write('"item_number","list_number","sentence_id"\n')
for i in range(len(jsons)):
    out.write(str(jsons[i]["item"]) + "," + str(jsons[i]["list"]) + "," + str(i) + "\n")
