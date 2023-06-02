#!/usr/bin/env bash

# Automation of validation and scoring
script_dir=$(dirname $0)
if [ ! -d "$script_dir/log" ]; then
  mkdir $script_dir/log
fi

#----------------------------
# Activate conda environment
#----------------------------
source /home/vchung/miniconda3/bin/activate /home/vchung/miniconda3/envs/minidream

#----------------------------
# Score submissions
#----------------------------
python3 $script_dir/challenge.py \
  -u "mc2-center" \
  --send-messages \
  --notifications score \
  --all >> $script_dir/log/score.log 2>&1
