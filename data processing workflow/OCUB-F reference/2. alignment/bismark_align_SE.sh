#!/bin/bash

#SBATCH -J bismark            # job name
#SBATCH -a 1-1%1                      # job array
#SBATCH -p smp
#SBATCH -N 1                # number of nodes
#SBATCH -c 8                # number of cores
#SBATCH --mem-per-cpu 16084  # memory pool for all cores
#SBATCH -t 0-24:00           # time (D-HH:MM)
#SBATCH -o bismark.%a.out  # STDOUT
#SBATCH -e bismark.%a.err  # STDERR
#SBATCH --mail-user=jela.guo@icr.ac.uk
#SBATCH --mail-type=ALL

source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate methylation_env

NUM_CORES=$SLURM_NTASKS
INDEX=$SLURM_ARRAY_TASK_ID

source ./bismark_params.sh

bismark \
-phred33-quals  -bowtie2 \
--non_directional \
--rg_tag --rg_id $SAMPLE_NAME'1' --rg_sample $SAMPLE_NAME'1' \
--un \
--ambiguous \
-p 4 \
--output_dir /data/scratch/DBC/UBCN/CANCDYN/jguo/all-seq/01/SLX-23666/all/OCUBF_R/bismark/SE/nondirectional  \
--genome /data/scratch/DBC/UBCN/CANCDYN/genomes/homo-sapiens/hg38/bisulphite \
-B $SAMPLE_NAME'1' \
$FIN_TRIM_DIR/$SAMPLE_NAME'.r_1.round2.fq.gz'

wait
conda deactivate
