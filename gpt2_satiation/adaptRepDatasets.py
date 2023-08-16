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
    #random.seed(10)
    random.shuffle(conds[cond])

cond_list = ["CNPC", "SUBJ", "WH", "FILL", "UNGRAM"]
#### EXP1 ####
exp1_conds = conds.copy()
NUM_BLOCKS = 15
output1 = open("datasets/adapt_rep_WS/adapt_exp1_train.txt", "w")
output2c = open("datasets/adapt_rep_WS/adapt_exp2_train_CNPC.txt", "w")
output2s = open("datasets/adapt_rep_WS/adapt_exp2_train_SUBJ.txt", "w")
output2w = open("datasets/adapt_rep_WS/adapt_exp2_train_WH.txt", "w")
for i in range(NUM_BLOCKS):
    random.shuffle(cond_list)
    for cond in cond_list:
        data = exp1_conds[cond].pop()
        context = data["Context"].strip().strip(".") + " ."
        target = data["Target"].strip().strip("?") + " ?"
        if cond in ["FILL", "UNGRAM"]:
            for file in [output2c, output2s, output2w]:
                file.write(context + "\n")
                file.write(target + "\n")
        if cond == "CNPC":
            output2c.write(context + "\n")
            output2c.write(target + "\n")
        elif cond == "WH":
            output2w.write(context + "\n")
            output2w.write(target + "\n")
        elif cond == "SUBJ":
            output2s.write(context + "\n")
            output2s.write(target + "\n")
        output1.write(context + "\n")
        output1.write(target + "\n")

#### EXP1_WS ####
exp1_conds = conds.copy()
output2c = open("datasets/adapt_rep_WS/adapt_exp2_train_CNPC_WS.txt", "w")
output2s = open("datasets/adapt_rep_WS/adapt_exp2_train_SUBJ_WS.txt", "w")
output2w = open("datasets/adapt_rep_WS/adapt_exp2_train_WH_WS.txt", "w")
for i in range(NUM_BLOCKS):
    random.shuffle(cond_list)
    for cond in cond_list:
        data = exp1_conds[cond].pop()
        context = data["Context"].strip().strip(".") + " ."
        target = data["Target"].strip().strip("?") + " ?"
        
        c_words = context.strip().split()
        t_words = target.strip().split()
        c_words.pop(-1)
        t_words.pop(-1)
        random.shuffle(c_words)
        random.shuffle(t_words)
        c_salad = ' '.join([word for word in c_words])
        c_salad += " .\n"
        t_salad = ' '.join([word for word in t_words])
        t_salad += " ?.\n"

        if cond in ["FILL", "UNGRAM"]:
            for file in [output2c, output2s, output2w]:
                file.write(context + "\n")
                file.write(target + "\n")
        if cond == "CNPC":
            output2c.write(context + "\n")
            output2c.write(target + "\n")
            
            output2s.write(c_salad)
            output2s.write(t_salad)
            output2w.write(c_salad)
            output2w.write(t_salad)
        elif cond == "WH":
            output2w.write(context + "\n")
            output2w.write(target + "\n")

            output2s.write(c_salad)
            output2s.write(t_salad)
            output2c.write(c_salad)
            output2c.write(t_salad)
        elif cond == "SUBJ":
            output2s.write(context + "\n")
            output2s.write(target + "\n")

            output2c.write(c_salad)
            output2c.write(t_salad)
            output2w.write(c_salad)
            output2w.write(t_salad)
        output1.write(context + "\n")
        output1.write(target + "\n")

for cond in cond_list:
    output = open(f'datasets/adapt_rep_WS/adapt_test_{cond}.txt', "w")
    for i in range(6):
        data = exp1_conds[cond].pop()
        context = data["Context"].strip().strip(".") + " ."
        target = data["Target"].strip().strip("?") + " ?"
        output.write(context + "\n")
        output.write(target + "\n")
