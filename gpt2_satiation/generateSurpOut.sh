#!/bin/bash

# Use from acceptability_modeling folder

# arg 1: model condition; arg 2: test data condition

# test="../gpt2_satiation/datasets/gen_${2}_test15.txt"
# model10="../gpt2_satiation/checkpoints/${1}_10_0724-1epoch/checkpoint-10"
# save10="../gpt2_satiation/SurpOut/gen_${1}10train_${2}test_SurpOut.txt"

for train_cond in 'CNPC_10_A1' 'CNPC_10_A2' 'CNPC_10_B1' 'CNPC_10_B2'
do
    for test_cond in 'CNPC_10_A1' 'CNPC_10_A2' 'CNPC_10_B1' 'CNPC_10_B2'
    do
        test_data="../gpt2_satiation/datasets/${test_cond}_test.txt"
        model_path="../gpt2_satiation/checkpoints/${train_cond}_0724-1epoch/checkpoint-10"
        save_path="../gpt2_satiation/output/SurpOut/${train_cond}train_${test_cond}test_SurpOut.txt"
        #echo $test_data
        
        #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
        python scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
    done
done

# for train_cond in 'FILL' 'UNGRAM'
# do
#     for test_cond in 'FILL'
#     do
#         for num_train in 10
#         do
#             test_data="../gpt2_satiation/datasets/sprouse2016_${test_cond}_test15.txt"
#             model_path="../gpt2_satiation/checkpoints/${train_cond}_${num_train}_0724-1epoch/checkpoint-${num_train}"
#             save_path="../gpt2_satiation/output/SurpOut/gen_${train_cond}${num_train}train_Sprouse${test_cond}test_SurpOut.txt"
#             #echo $test_data
            
#             #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#             python scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
#         done
#     done
# done
