#!/bin/bash



folder="../results/mtor_model_0_8_5_0_general_model/dataset_parameter_scan/"
model="mtor_model_0_8_5_0_general_model_scan_1_mTORC1_"
timepoints=(3 20 45)
suffixes=("4" "3" "2" "1" "0")


echo "create ${files[$index]} output file and correspondent header line"
touch quantitation_of_general_model.csv


for i in ${!timepoints[*]}
do
  echo -e "\tmTORC1 KD quantitation (time point: ${timepoints[$i]} min)"
  echo "" >> quantitation_of_general_model.csv
  echo -e "\nmTORC1 Knockdown (time point: ${timepoints[$i]} min)\n" >> quantitation_of_general_model.csv
  echo -e "Time\tp70-S6K-T389" >> quantitation_of_general_model.csv
  suffixes=("4" "3" "2" "1" "0")
  line=$((${timepoints[$i]}+2))
  for suffix in ${suffixes[*]}
  do
    awk -v ln=$line 'FNR==ln {print $1"\t"$7}' ${folder}${model}$suffix.csv >> quantitation_of_general_model.csv
  done
done
