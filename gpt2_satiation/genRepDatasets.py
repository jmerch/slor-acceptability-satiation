import random, json

stimuli = open("stimuli/genStim.txt")

lines = stimuli.readlines()

clean_lines = []

for line in lines:
  clean_lines.append(line.strip().strip(','))

jsons = []

for line in clean_lines:
  jsons.append(json.loads(line))

conds = {"POLAR": [], "SUBJ": [], "WH": [], "FILL": [], "UNGRAM": [], "CNPC": []}

for json in jsons:
    conds[json["condition"]].append(json)

conds["FILLER"] = conds["FILL"] + conds["UNGRAM"]

for cond in list(conds.keys()):
    random.shuffle(conds[cond])

cond_list = ["POLAR", "SUBJ", "WH", "FILLER"]
#### EXP1 ####
exp1_conds = conds.copy()
NUM_BLOCKS = 12
outputp = open("datasets/gen_rep/gen_train_POLAR.txt", "w")
outputs = open("datasets/gen_rep/gen_train_SUBJ.txt", "w")
outputw = open("datasets/gen_rep/gen_train_WH.txt", "w")
for i in range(NUM_BLOCKS):
    for cond in cond_list:
        data = exp1_conds[cond].pop()
        context = data["Context"].strip().strip(".") + " ."
        target = data["Target"].strip().strip("?") + " ?"
        if cond == "FILLER":
            for output in [outputp, outputs, outputw]:
                output.write(context + "\n")
                output.write(target + "\n")
        elif cond == "SUBJ":
            outputs.write(context + "\n")
            outputs.write(target + "\n")
        elif cond == "WH":
            outputw.write(context + "\n")
            outputw.write(target + "\n")
        elif cond == "POLAR":
            outputp.write(context + "\n")
            outputp.write(target + "\n")

for cond in cond_list:
    output = open(f'datasets/gen_rep/gen_test_{cond}.txt', "w")
    for i in range(10):
        data = exp1_conds[cond].pop()
        context = data["Context"].strip().strip(".") + " ."
        target = data["Target"].strip().strip("?") + " ?"
        output.write(context + "\n")
        output.write(target + "\n")
