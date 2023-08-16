#!/bin/bash
# Use from gpt2_satiation

# for num in 10 20 30
# do
#     model_path="checkpoints/B_sets/WH_${num}_B_0724-1epoch/checkpoint-${num}"
#     test_data="datasets/old_gen_sets/gen_WH_test15.txt"
#     save_path="output/SurpOut/A_B_sets/WH_${num}_Btrain_WH_15_test_SurpOut.txt"
#     python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
# done

# For adapt exp 1, 2, 2WS:
for test_cond in 'CNPC' 'FILL' 'SUBJ' 'UNGRAM' 'WH'
do
    #for exp 1 (train on all, test on indiv)
    model_path="checkpoints/adapt_rep/adapt_exp1_train_0724-1epoch/checkpoint-150"
    test_data="datasets/adapt_rep/adapt_test_${test_cond}_test.txt"
    save_path="output/SurpOut/adapt_rep/adapt_exp1_${test_cond}test_SurpOut.txt"
    python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

    # for exp 2
    if [[ $test_cond != 'FILL' ]] && [[ $test_cond != 'UNGRAM' ]]; then
        model_path="checkpoints/adapt_rep/adapt_exp2_train_${test_cond}_0724-1epoch/checkpoint-90"
        test_data="datasets/adapt_rep/adapt_test_${test_cond}_test.txt"
        save_path="output/SurpOut/adapt_rep/adapt_exp2_${test_cond}train_${test_cond}test_SurpOut.txt"
        python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

        model_path="checkpoints/adapt_rep_WS/adapt_exp2_train_${test_cond}_WS_0724-1epoch/checkpoint-150"
        test_data="datasets/adapt_rep/adapt_test_${test_cond}_test.txt"
        save_path="output/SurpOut/adapt_rep/adapt_exp2_${test_cond}_WStrain_${test_cond}test_SurpOut.txt"
        python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
    fi
done

# # For gen exp 1, 2:
# for train_cond in 'POLAR' 'SUBJ' 'WH'
# do
#     model_path="checkpoints/gen_rep/gen_train_${train_cond}_0724-1epoch/checkpoint-48"
#     for test_cond in 'SUBJ' 'WH'
#     do
#         test_data="datasets/gen_rep/gen_test_${test_cond}_test.txt"
#         save_path="output/SurpOut/gen_rep/gen_${train_cond}train_${test_cond}test_SurpOut.txt"
#         python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
#     done
# done

# for train_cond in 'POLAR' 'SUBJ' 'WH'
# do
#     #A1-A2
#     model_path="checkpoints/A12B12/${train_cond}_10_A1_0724-1epoch/checkpoint-10"
#     test_data="datasets/A12B12/${train_cond}_10_A2_test.txt"
#     save_path="output/SurpOut/A12B12/${train_cond}_10_A1train_${train_cond}_10_A2test_SurpOut.txt"
#     #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#     python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

#     #A1-B2
#     model_path="checkpoints/A12B12/${train_cond}_10_A1_0724-1epoch/checkpoint-10"
#     test_data="datasets/A12B12/${train_cond}_10_B2_test.txt"
#     save_path="output/SurpOut/A12B12/${train_cond}_10_A1train_${train_cond}_10_B2test_SurpOut.txt"
#     #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#     python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

#     #B2-A1
#     model_path="checkpoints/A12B12/${train_cond}_10_B2_0724-1epoch/checkpoint-10"
#     test_data="datasets/A12B12/${train_cond}_10_A1_test.txt"
#     save_path="output/SurpOut/A12B12/${train_cond}_10_B2train_${train_cond}_10_A1test_SurpOut.txt"
#     #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#     python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null

#     #A1WS-A1
#     model_path="checkpoints/A12B12/${train_cond}_10_A1WS_0724-1epoch/checkpoint-10"
#     test_data="datasets/A12B12/${train_cond}_10_A1_test.txt"
#     save_path="output/SurpOut/A12B12/${train_cond}_10_A1WStrain_${train_cond}_10_A1test_SurpOut.txt"
#     #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#     python ../acceptability_modeling/scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
# done


# # for train_cond in 'CNPC_10_A1WS' 'CNPC_10_B1WS'
# # do
# #     for test_cond in 'CNPC_10_A1' 'CNPC_10_A2' 'CNPC_10_B1' 'CNPC_10_B2' 
# #     do
# #         test_data="../gpt2_satiation/datasets/${test_cond}_test.txt"
# #         model_path="../gpt2_satiation/checkpoints/${train_cond}_0724-1epoch/checkpoint-10"
# #         save_path="../gpt2_satiation/output/SurpOut/${train_cond}train_${test_cond}test_SurpOut.txt"
# #         #echo $test_data
        
# #         #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
# #         python scripts/surprisal.py $test_data $model_path | tee $save_path > /dev/null
# #     done
# # done

