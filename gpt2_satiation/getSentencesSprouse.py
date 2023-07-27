import json
import sys
import random

source = sys.argv[1]
#dest = sys.argv[2]
dataset = "datasets/" + source.strip("Stim.txt").strip("stimuli/")


f = open(source)
#out = open(dest, "w")

jsons = []
sentences = {}

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
    sentence_key = "Target"
    if "Target"  not in stim:
        sentence_key = "sentence"
    sentence = stim[sentence_key]
    punct = sentence.strip()[-1]
    formatted = sentence.strip().strip(punct) + f' {punct}\n'
    condition = stim["condition"]
    if condition in sentences:
        sentences[condition].append(formatted)
    else:
        sentences[condition] = [formatted]

# Generate FILL, UNGRAM training set (10) and test set (6)
for condition in ["FILL", "UNGRAM"]:
    test6 =  dataset + "_" + condition + "_test6.txt"
    test15 =  dataset + "_" + condition + "_test15.txt"
    train10 = dataset + "_" + condition + "_train10.txt"

    testSet = set(sentences[condition][:6])#random.sample(sentences[condition], 15)
    remaining = set(sentences[condition]).difference(testSet)

    # testOut = open(test6, "w")
    # for sentence in testSet:
    #     testOut.write("!ARTICLE\n")
    #     testOut.write(sentence)
    
    # train10Out = open(train10, "w")
    # for sentence in remaining:
    #     train10Out.write(sentence)

    testSet = set(sentences[condition][:15])
    testOut = open(test15, "w")
    for sentence in testSet:
        testOut.write("!ARTICLE\n")
        testOut.write(sentence)