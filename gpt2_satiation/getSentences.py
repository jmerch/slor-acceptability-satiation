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
        sentences[condition].add(formatted)
    else:
        sentences[condition] = set({formatted})

for condition in ["WH", "SUBJ", "POLAR"]:
    test15 =  dataset + "_" + condition + "_test15.txt"
    train10 = dataset + "_" + condition + "_train10.txt"
    train20 = dataset + "_" + condition + "_train20.txt"
    train30 = dataset +  "_" + condition +"_train30.txt"

    #print(condition)
    testSet = random.sample(sentences[condition], 15)
    remaining = sentences[condition].difference(testSet)
    #print(len(remaining))
    train10set = random.sample(remaining, 10)
    #print(len(train10set))
    train20set = random.sample(remaining, 20)
    #print(len(train20set))

    testOut = open(test15, "w")
    for sentence in testSet:
        testOut.write(sentence)
    train10Out = open(train10, "w")
    for sentence in train10set:
        train10Out.write(sentence)
    train20Out = open(train20, "w")
    for sentence in train20set:
        train20Out.write(sentence)
    train30Out = open(train30, "w")
    for sentence in remaining:
        train30Out.write(sentence)
