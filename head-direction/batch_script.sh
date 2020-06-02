#!/bin/bash -l

#$ -P hasselmogrp
#$ -pe omp 8
#$ -N head-direction

module load matlab

matlab -nojvm -r "head_direction_script; exit()"
