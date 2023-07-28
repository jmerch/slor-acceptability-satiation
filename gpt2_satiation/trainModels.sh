#!/bin/bash

for train_data in 'CNPC_10_A1' 'CNPC_10_A2' 'CNPC_10_B1' 'CNPC_10_B2'
do
    for test_data in 'CNPC_10_A1' 'CNPC_10_A2' 'CNPC_10_B1' 'CNPC_10_B2'
    do
        config = 'configs/0724-1epoch.yaml'
        python satiation.py --config $config --train_name $train_data --test_name $test_data
    done
done

# for condition in 'CNPC' 'POLAR' 'SUBJ' 'WH'
# do
#     for num_train in 10 20 30
#     do
#         config = '0724-1epoch.yaml'
#         train_name = gen_"$condition"_train"$num_train"
#         test_name = 
#         python satiation.py --config $config --train_name train_name
#     done
# done