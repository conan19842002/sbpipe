#!/bin/bash

# License (GPLv3):
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either model 2 of the License, or (at
# your option) any later model.
#    
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#
#
# Institute for Ageing and Health
# Newcastle University
# Newcastle upon Tyne
# NE4 5PL
# UK
# Tel: +44 (0)191 248 1106
# Fax: +44 (0)191 248 1101
#
# $Revision: 2.0 $
# $Author: Piero Dalle Pezze $
# $Date: 2013-05-30 16:14:32 $


# This scripts provides the user with a complete pipeline of scripts for running 
# a model simulation using copasi



# Import the library timer.sh for computing the pipeline elapsed time 
. ${SB_PIPE_LIB}/bash/timer.sh




# Input parameters
# The file containing the model configuration, usually in working_folder (e.g. model.conf)
model_configuration=$1


printf "\nReading file ${model_configuration} : \n"
# import the model configuration data (project, model-name, association-pattern)
old_IFS=$IFS
IFS=$'\n'
lines=($(cat ${model_configuration}))  # array
IFS=$old_IFS
printf "\n\n"




# read the project name
project=""
# read the main model name (e.g. mtor_mito_ros_model_v27_pw3.m)
model=""
# Copasi models list (1 model per species to perturb) (e.g mtor_mito_ros_model_v27_copasi_scan_mTORC1.cps ...)
simulate__copasi_model=""
# the number of simulation to be run.
# minimum 2 (required for plotCI, otherwise, ci95 and sderr are NA -> error in ylim)
# For stochastic simulations, run 500
# For testing, run 5
simulate__model_simulations_number=2
# The duration of the simulation (e.g. 50)
# This is required for plotting
simulate__duration=1
# The inteval size of each simulation step (e.g. 0.01)
# This is required for plotting
simulate__interval_size=0.1
# the work team: kathrin or glyn
team=""
# The folder containing the models
models_folder=""
# The folder containing the models simulations
simulations_folder=""
# The folder containing the temporary computations
tmp_folder=""
# The dataset simulation dir (e.g. dataset)
dataset_simulation_dir=""
# The dataset short simulation dir (e.g. dataset_short)
dataset_short_simulation_dir=""
# The dataset timecourses dir (e.g. tc)
tc_dir=""
# The dataset mean timecourses dir (e.g. tc_mean)
tc_mean_dir=""
# The dataset mean timecourses with experimental data dir (e.g. tc_mean_with_exp)
tc_mean_with_exp_dir=""
# The prefix name of the report of the simulation (e.g. report_simulation__)
simulate__prefix_results_filename=""
# The prefix name of the statistics report of the simulation (e.g. stats_simulation__)
simulate__prefix_stats_filename=""
# The prefix name of the statistics report of the simulation (e.g. stats_experiments__)
simulate__prefix_exp_stats_filename=""



# read the project and the model name
old_IFS=$IFS
IFS=$'='
for line in "${lines[@]}"; do
  read -a array <<< "${line}"
  case "${array[0]}" in
    ("project") 				echo "$line"; project="${array[1]}" ;; 
    ("model") 					echo "$line"; model="${array[1]}" ;;
    ("simulate__copasi_model") 			echo "$line"; simulate__copasi_model="${array[1]}" ;;
    ("team") 					echo "$line"; team="${array[1]}" ;;
    ("simulate__model_simulations_number") 	echo "$line"; simulate__model_simulations_number=${array[1]} ;;
    ("simulate__duration") 			echo "$line"; simulate__duration=${array[1]} ;;
    ("simulate__interval_size") 		echo "$line"; simulate__interval_size=${array[1]} ;;       
    ("models_folder") 				echo "$line"; models_folder="${array[1]}" ;;
    ("data_folder") 				echo "$line"; data_folder="${array[1]}" ;;
    ("simulations_folder") 			echo "$line"; simulations_folder="${array[1]}" ;;
    ("tmp_folder") 				echo "$line"; tmp_folder="${array[1]}" ;;      
    ("dataset_simulation_dir") 			echo "$line"; dataset_simulation_dir="${array[1]}" ;;      
    ("dataset_short_simulation_dir") 		echo "$line"; dataset_short_simulation_dir="${array[1]}" ;;
    ("tc_dir") 					echo "$line"; tc_dir="${array[1]}" ;;      
    ("tc_mean_dir") 				echo "$line"; tc_mean_dir="${array[1]}" ;;
    ("tc_mean_with_exp_dir") 			echo "$line"; tc_mean_with_exp_dir="${array[1]}" ;;      
    ("simulate__prefix_results_filename") 	echo "$line"; simulate__prefix_results_filename="${array[1]}" ;;
    ("simulate__prefix_stats_filename") 	echo "$line"; simulate__prefix_stats_filename="${array[1]}" ;;      
    ("simulate__prefix_exp_stats_filename") 	echo "$line"; simulate__prefix_exp_stats_filename="${array[1]}" ;;
  esac
done
IFS=$old_IFS


# remove the path in case this was specified.
#model_configuration=$(basename ${model_configuration})
#model_configuration_with_path="${SB_PIPE}/${project}/${work_folder}/${model_configuration}"


models_dir="${SB_PIPE}/${project}/${models_folder}/"
results_dir="${SB_PIPE}/${project}/${simulations_folder}/${model%.*}/"
data_dir="${SB_PIPE}/${project}/${data_folder}/"
tmp_dir="${SB_PIPE}/${project}/${tmp_folder}/"




printf "\n\n\n<START PIPELINE>\n\n\n"
# Get the pipeline start time
tmr=$(timer)





    
printf "\n\n\n"
printf "##############################################################\n"      
printf "##############################################################\n"
printf "### Processing model ${simulate__copasi_model} \n"
printf "##############################################################\n"
printf "##############################################################\n"
printf "\n\n"
      

      
printf "\n\n\n"
printf "###############################\n"
printf "Cleaning folder ${results_dir}:\n"
printf "###############################\n"
printf "\n"
# rm -rf ${results_dir}/${dataset_simulation_dir}/*
# rm -rf ${results_dir}/${dataset_short_simulation_dir}/*
# rm -rf ${results_dir}/${tc_dir}/*
# rm -rf ${results_dir}/${tc_mean_dir}/*
# rm -rf ${results_dir}/${tc_mean_with_exp_dir}/*
# rm -rf ${results_dir}/${simulate__prefix_results_filename}${model_noext}.* ${results_dir}/${simulate__prefix_stats_filename}${model_noext}.*
mkdir -p ${tmp_dir} ${results_dir}/${dataset_simulation_dir}/ ${results_dir}/${dataset_short_simulation_dir}/ ${results_dir}/${tc_dir}/ ${results_dir}/${tc_mean_dir}/ ${results_dir}/${tc_mean_with_exp_dir}



printf "\n\n\n"
printf "######################\n"
printf "Executing simulations:\n"
printf "######################\n"
printf "\n"
bash ${SB_PIPE}/bin/sb_simulate/simulate__run_copasi.sh ${simulate__copasi_model} ${models_dir} ${results_dir}/${dataset_simulation_dir}/ ${tmp_dir}/ ${simulate__model_simulations_number}



printf "\n\n\n"
printf "####################################\n"
printf "Generating plots for one simulation (SKIP):\n"
printf "####################################\n"
printf "\n"
# cp ${results_dir}/${dataset_simulation_dir}/${simulate__copasi_model%.*}__sim_1.csv ${results_dir}/${dataset_short_simulation_dir}/
# Rscript ${SB_PIPE}/bin/sb_simulate/simulate__plot.R ${simulate__copasi_model%.*} ${results_dir}/${dataset_short_simulation_dir}/ ${results_dir}/${tc_dir}/    



printf "\n\n\n"
printf "#######################################\n"
printf "Generating statistics from simulations:\n"
printf "#######################################\n"
printf "\n"
Rscript ${SB_PIPE}/bin/sb_simulate/simulate__plot_error_bars.R ${simulate__copasi_model%.*} ${results_dir}/${dataset_simulation_dir}/ ${results_dir}/${tc_mean_dir}/ ${results_dir}/${simulate__prefix_stats_filename}${simulate__copasi_model%.*}.csv ${team} ${simulate__duration} ${simulate__interval_size}



printf "\n\n\n"
printf "#######################################\n"
printf "Generating statistics from experiments (SKIP):\n"
printf "#######################################\n"
printf "\n"
#Rscript ${SB_PIPE}/bin/sb_simulate/simulate__plot_exp_error_bars.R ${data_dir}/${dataset_exp}/ ${results_dir}/${tc_mean_exp}/ ${results_dir}/${simulate__prefix_exp_stats_filename}${simulate__copasi_model%.*}.csv



printf "\n\n\n"
printf "#########################################\n"
printf "Generating overlapping plots (sim + exp) (SKIP):\n"
printf "#########################################\n"
printf "\n"
#Rscript ${SB_PIPE}/bin/sb_simulate/simulate__plot_sim_exp_error_bars.R ${simulate__copasi_model%.*} ${results_dir}/${tc_mean_dir}/ ${results_dir}/${tc_mean_exp_dir}/ ${results_dir}/${tc_mean_with_exp_dir}/ ${results_dir}/${simulate__prefix_stats_filename}${simulate__copasi_model%.*}.csv ${results_dir}/${simulate__prefix_exp_stats_filename}${simulate__copasi_model%.*}.csv



printf "\n\n\n"
printf "###################\n"
printf "Generating reports:\n"
printf "###################\n"
printf "\n"
bash ${SB_PIPE}/bin/sb_simulate/simulate__gen_report.sh ${simulate__copasi_model%.*} ${results_dir}/ ${tc_mean_dir} ${simulate__prefix_results_filename}





# Print the pipeline elapsed time
printf '\n\n\nPipeline elapsed time: %s\n' $(timer $tmr) 
printf "\n<END PIPELINE>\n\n\n"

