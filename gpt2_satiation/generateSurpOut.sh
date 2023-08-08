#!/bin/bash

# Use from acceptability_modeling folder

# arg 1: model condition; arg 2: test data condition

# test="../gpt2_satiation/datasets/gen_${2}_test15.txt"
# model10="../gpt2_satiation/checkpoints/${1}_10_0724-1epoch/checkpoint-10"
# save10="../gpt2_satiation/SurpOut/gen_${1}10train_${2}test_SurpOut.txt"

for train_cond in 'CNPC' 'POLAR' 'SUBJ' 'WH'
do
    for num_train in 0 #num_train is being used as num_unscrambled
    do
        test_data="../gpt2_satiation/datasets/old/gen_${train_cond}_test15.txt"
        model_path="../gpt2_satiation/checkpoints/${train_cond}_30_B_${num_train}_WS_0724-1epoch/checkpoint-30"
        save_path="../gpt2_satiation/output/SurpOut/train30B_WS_test15/${train_cond}_30_B_${num_train}_WS_SurpOut.txt"
        
        #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
        python scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
    done
done


# for train_cond in 'CNPC_10_A1WS' 'CNPC_10_B1WS'
# do
#     for test_cond in 'CNPC_10_A1' 'CNPC_10_A2' 'CNPC_10_B1' 'CNPC_10_B2' 
#     do
#         test_data="../gpt2_satiation/datasets/${test_cond}_test.txt"
#         model_path="../gpt2_satiation/checkpoints/${train_cond}_0724-1epoch/checkpoint-10"
#         save_path="../gpt2_satiation/output/SurpOut/${train_cond}train_${test_cond}test_SurpOut.txt"
#         #echo $test_data
        
#         #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#         python scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
#     done
# done

