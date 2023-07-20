#!/bin/bash

dir="data/"
stim="${dir}${1}Stim.${2}"
surpIn="${dir}${1}SurpIn.txt"
surpOut="${dir}${1}SurpOut.txt"
ids="${dir}${1}ID_to_cond.csv"
means="scripts/${1}means.R"

sudo python3 scripts/sentenceExtractor.py $stim $surpIn
sudo python3 scripts/surprisal.py $surpIn gpt2 | sudo tee $surpOut > /dev/null
sudo python3 scripts/averageSurp.py $surpOut $ids $1
#Rscript $means