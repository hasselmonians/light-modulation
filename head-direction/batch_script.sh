#!/bin/bash -l

#$ -P hasselmogrp
#$ -N head-direction
#$ -e err

module load matlab

matlab -nojvm -r "head_direction_script; exit()"
