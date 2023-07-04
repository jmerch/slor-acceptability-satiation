import sys
import math

source = sys.argv[1]

f = open(source)
out = open("../data/surprisals.csv", "w")

sentence_id = 2
curr_total = 0
exp_inc_total = 0
exp_dec_total = 0
exp_sum_total = 0
num_words = 0
surprisals = []
lines = f.readlines()
lines.pop(0)
out.write('"sentence_id","mean_surprisal","weight_first","weight_last","weight_sum"\n')
for line in lines:
    data = line.strip().split(" ")
    word = data[0]
    surprisal = float(data[1])
    num_words += 1
    surprisals.append(surprisal)
    if (word == '?'):
        for i in range(num_words):
            inc_weight = math.exp(-i)
            dec_weight = math.exp(-(num_words - i - 1))
            exp_inc_total += surprisals[i] * inc_weight
            exp_dec_total += surprisals[i] * dec_weight
            exp_sum_total += surprisals[i] * (inc_weight + dec_weight)
            curr_total += surprisals[i]
        out.write(f'{sentence_id},{curr_total / num_words},{exp_inc_total / num_words},{exp_dec_total / num_words},{exp_sum_total / num_words}\n')
        sentence_id += 1
        curr_total = 0
        exp_dec_total = 0
        exp_inc_total = 0
        exp_sum_total = 0
        num_words = 0
