#!/bin/bash

# Use from gpt2_satiation

for train_cond in 'POLAR' 'SUBJ' 'WH'
do
    #A1-A2
    model_path="checkpoints/A12B12/${train_cond}_10_A1_0724-1epoch/checkpoint-10"
    test_data="datasets/A12B12/${train_cond}_10_A2_test.txt"
    save_path="output/SurpOut/A12B12/${train_cond}_10_A1train_${train_cond}_10_A2test_SurpOut.txt"
    #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
    python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

    #A1-B2
    model_path="checkpoints/A12B12/${train_cond}_10_A1_0724-1epoch/checkpoint-10"
    test_data="datasets/A12B12/${train_cond}_10_B2_test.txt"
    save_path="output/SurpOut/A12B12/${train_cond}_10_A1train_${train_cond}_10_B2test_SurpOut.txt"
    #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
    python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

    #B2-A1
    model_path="checkpoints/A12B12/${train_cond}_10_B2_0724-1epoch/checkpoint-10"
    test_data="datasets/A12B12/${train_cond}_10_A1_test.txt"
    save_path="output/SurpOut/A12B12/${train_cond}_10_B2train_${train_cond}_10_A1test_SurpOut.txt"
    #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
    python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

    #A1WS-A1
    model_path="checkpoints/A12B12/${train_cond}_10_A1WS_0724-1epoch/checkpoint-10"
    test_data="datasets/A12B12/${train_cond}_10_A1_test.txt"
    save_path="output/SurpOut/A12B12/${train_cond}_10_A1WStrain_${train_cond}_10_A1test_SurpOut.txt"
    #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
    python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
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

