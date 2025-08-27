#!/bin/bash

#SBATCH -J bismark            # job name
#SBATCH -N 1                # number of nodes
#SBATCH -c 2                # number of cores
#SBATCH --mem-per-cpu 8042  # memory pool for all cores
#SBATCH -t 0-24:00           # time (D-HH:MM)
#SBATCH -o bismark.%a.out  # STDOUT
#SBATCH -e bismark.%a.err  # STDERR
#SBATCH --mail-user=jela.guo@icr.ac.uk
#SBATCH --mail-type=ALL

source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate methylation_env

bismark_genome_preparation /data/scratch/DBC/UBCN/CANCDYN/genomes/homo-sapiens/hg38/bisulphite-emseq

wait
conda deactivate
