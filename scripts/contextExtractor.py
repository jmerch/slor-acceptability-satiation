import json
import sys

source = sys.argv[1]
dest = sys.argv[2]

f = open(source)
out = open(dest, "w")

jsons = []


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
    context = stim["Context"]
    punct = context.strip()[-1]
    out.write(context.strip().strip(punct) + f' {punct}\n')
    sentence_key = "Target"
    if "Target"  not in stim:
        sentence_key = "sentence"
    sentence = stim[sentence_key]
    punct = sentence.strip()[-1]
    out.write(sentence.strip().strip(punct) + f' {punct}\n')
