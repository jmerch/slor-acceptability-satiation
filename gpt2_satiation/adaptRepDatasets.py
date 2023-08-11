import random, json

stimuli = open("stimuli/adapt2stim.txt")

lines = stimuli.readlines()

clean_lines = []

for line in lines:
  clean_lines.append(line.strip().strip(','))

jsons = []

for line in clean_lines:
  jsons.append(json.loads(line))

conds = {"CNPC": [], "SUBJ": [], "WH": [], "FILL": [], "UNGRAM": []}

for json in jsons:
    conds[json["condition"]].append(json)

for cond in list(conds.keys()):
    random.shuffle(conds[cond])

cond_list = ["CNPC", "SUBJ", "WH", "FILL", "UNGRAM"]
#### EXP1 ####
exp1_conds = conds.copy()
NUM_BLOCKS = 15
output1 = open("datasets/adapt_rep/adapt_exp1_train.txt", "w")
output2c = open("datasets/adapt_rep/adapt_exp2_train_CNPC.txt", "w")
output2s = open("datasets/adapt_rep/adapt_exp2_train_SUBJ.txt", "w")
output2w = open("datasets/adapt_rep/adapt_exp2_train_WH.txt", "w")
for i in range(NUM_BLOCKS):
    random.shuffle(cond_list)
    for cond in cond_list:
        data = exp1_conds[cond].pop()
        if cond in ["FILL", "UNGRAM"]:
            for file in [output2c, output2s, output2w]:
                file.write(data["Context"] + "\n")
                file.write(data["Target"] + "\n")
        if cond == "CNPC":
            output2c.write(data["Context"] + "\n")
            output2c.write(data["Target"] + "\n")
        elif cond == "WH":
            output2w.write(data["Context"] + "\n")
            output2w.write(data["Target"] + "\n")
        elif cond == "SUBJ":
            output2s.write(data["Context"] + "\n")
            output2s.write(data["Target"] + "\n")
        output1.write(data["Context"] + "\n")
        output1.write(data["Target"] + "\n")

for cond in cond_list:
    output = open(f'datasets/adapt_rep/adapt_test_{cond}.txt', "w")
    for i in range(6):
        data = exp1_conds[cond].pop()
        output.write(data["Context"] + "\n")
        output.write(data["Target"] + "\n")
