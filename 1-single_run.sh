#!/bin/bash
# 
# SBATCH -p sesyncshared
# SBATCH --share
Rscript --vanilla single_run.R $1 $2