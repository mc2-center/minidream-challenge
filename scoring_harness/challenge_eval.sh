#!/usr/bin/env bash

# Automation of validation and scoring
script_dir=$(dirname $0)
if [ ! -d "$script_dir/log" ]; then
  mkdir $script_dir/log
fi

#----------------------------
# Activate conda environment
#----------------------------
source /home/lpeng/miniconda3/bin/activate /home/lpeng/miniconda3/envs/minidream-2022

#----------------------------
# Validate submissions
#----------------------------
# Remove --send-messages to do rescoring without sending emails to participants
# python $script_dir/challenge.py -u "synapse user here" --send-messages --notifications validate --all >> $script_dir/log/score.log 2>&1

#----------------------------
# Score submissions
#----------------------------
python3 $script_dir/challenge.py -u "bgrande" -u "mnikolov" -u "linglp0122" --send-messages --notifications score --all >> $script_dir/log/score.log 2>&1
