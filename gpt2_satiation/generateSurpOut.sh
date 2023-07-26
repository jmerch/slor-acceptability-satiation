#!/bin/bash

# Use from acceptability_modeling folder

# arg 1: model condition; arg 2: test data condition

# test="../gpt2_satiation/datasets/gen_${2}_test15.txt"
# model10="../gpt2_satiation/checkpoints/${1}_10_0724-1epoch/checkpoint-10"
# save10="../gpt2_satiation/SurpOut/gen_${1}10train_${2}test_SurpOut.txt"

for train_cond in 'WH' 'SUBJ'
do
    for test_cond in 'CNPC'
    do
        for num_train in 10 20 30
        do
            test_data="../gpt2_satiation/datasets/gen_${test_cond}_test15.txt"
            model_path="../gpt2_satiation/checkpoints/${train_cond}_${num_train}_0724-1epoch/checkpoint-${num_train}"
            save_path="../gpt2_satiation/output/SurpOut/gen_${train_cond}${num_train}train_${test_cond}test_SurpOut.txt"
            #echo $test_data
            
            HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
            python scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
        done
    done
done
