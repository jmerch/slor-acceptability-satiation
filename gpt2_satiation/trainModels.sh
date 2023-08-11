#!/bin/bash

# For adapt_rep exp 1:
train_name="adapt_rep/adapt_exp1_train"
test_name="adapt_rep/adapt_test_FILL"        
#HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
python satiation.py --config configs/0724-1epoch.yaml --train_name $train_name --test_name $test_name

train_name=""
echo $train_name

# For adapt_rep exp 2:
for train_cond in 'CNPC' 'SUBJ' 'WH'
do
    train_name="adapt_rep/adapt_exp2_train_${train_cond}"
    test_name="adapt_rep/adapt_test_${train_cond}"
            
    #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
    python satiation.py --config configs/0724-1epoch.yaml --train_name $train_name --test_name $test_name
done

# For gen exp 1 & 2:
for train_cond in 'SUBJ' 'WH' 'POLAR'
do
    train_name="gen_rep/gen_train_${train_cond}"
    test_name="gen_rep/gen_test_${train_cond}"
    #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
    python satiation.py --config configs/0724-1epoch.yaml --train_name $train_name --test_name $test_name
done

# for train_cond in 'POLAR' 'SUBJ' 'WH'
# do
#     for cond in 'A1' 'B2' 'A1WS'
#     do
#         for num_train in 10 #num_train is being used as num_WS
#         do
#             if [ $cond = 'A1' ]
#             then
#                 test_set="A2"
#             fi

#             if [ $cond = 'B2' ]
#             then
#                 test_set="B1"
#             fi

#             if [ $cond = 'A1WS' ]
#             then
#                 test_set="A1"
#             fi

#             test_name="A12B12/${train_cond}_${num_train}_${test_set}"
#             train_name="A12B12/${train_cond}_${num_train}_${cond}"
            
#             #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
#             python satiation.py --config configs/0724-1epoch.yaml --train_name $train_name --test_name $test_name
#         done
#     done
# done
