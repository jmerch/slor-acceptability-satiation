#!/bin/bash

for train_cond in 'POLAR' 'SUBJ' 'WH'
do
    for cond in 'A1' 'B2' 'A1WS'
    do
        for num_train in 10 #num_train is being used as num_WS
        do
            if [ $cond = 'A1' ]
            then
                test_set="A2"
            fi

            if [ $cond = 'B2' ]
            then
                test_set="B1"
            fi

            if [ $cond = 'A1WS' ]
            then
                test_set="A1"
            fi

            test_name="A12B12/${train_cond}_${num_train}_${test_set}"
            train_name="A12B12/${train_cond}_${num_train}_${cond}"
            
            #HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
            python satiation.py --config configs/0724-1epoch.yaml --train_name $train_name --test_name $test_name
        done
    done
done
