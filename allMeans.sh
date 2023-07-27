#!/bin/bash

dir="../gpt2_satiation/output/SurpOut/"
ids="data/genID_to_cond.csv"
for i in 10 20 30
  do
  for cond in $@
    do
      if [ "$cond" != "FILL" ];
        then
          if [ "$cond" != "UNGRAM" ];
            then
              echo "${cond}: ${i}"
              surpOut="${dir}gen_${cond}${i}train_${1}test_SurpOut.txt"
              name="gen_${cond}${i}_${1}test"
              sudo python3 scripts/averageSurp.py $surpOut $ids $name
            fi
        fi
    done
  done
