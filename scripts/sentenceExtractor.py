import json
import sys

source = sys.argv[1]
dest = sys.argv[2]
lines_only = "Sprouse" in source

f = open(source)
out = open(dest, "w")

jsons = []

if not lines_only:
    if ".json" in source:
        jsons = json.load(f)
    else:
        lines = f.readlines()
        clean_lines = []
        for line in lines:
            clean_lines.append(line.strip().strip(','))

        for line in clean_lines:
            jsons.append(json.loads(line))

    for stim in jsons:
        out.write("!ARTICLE\n")
        sentence_key = "Target"
        if "Target"  not in stim:
            sentence_key = "sentence"
        sentence = stim[sentence_key]
        punct = sentence.strip()[-1]
        out.write(sentence.strip().strip(punct) + f' {punct}\n')
else:
    lines = f.readlines()
    for line in lines:
        punct = line.strip()[-1]
        out.write("!ARTICLE\n")
        out.write(line.strip().strip(punct) + f' {punct}\n')
