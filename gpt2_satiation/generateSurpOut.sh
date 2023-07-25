#!/bin/bash

# Use from acceptability_modeling folder

# arg 1: model condition; arg 2: test data condition

test="../gpt2_satiation/datasets/gen_${2}_test15.txt"
model10="../gpt2_satiation/checkpoints/${1}_10_0724-1epoch/checkpoint-10"
save10="../gpt2_satiation/SurpOut/gen_${1}10train_${2}test_SurpOut.txt"

for train_cond in WH, POLAR, CNPC, SUBJ;
    for test_cond in WH, POLAR, CNPC, SUBJ;
        for num_train in 10, 20, 30;
            do
                python3 
            done