#!/bin/bash

#SBATCH -J bismark            # job name
#SBATCH -a 1-1%1                      # job array
#SBATCH -N 1                # number of nodes
#SBATCH -c 8                # number of cores
#SBATCH --mem-per-cpu 8042  # memory pool for all cores
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

source ./bismark_params2.sh


DEDU_DIR=$ALIGN_DIR_SE'/deduplication'

MERGED_SUFFIX='_dedup.merged.bam'
CALL_DIR=$ALIGN_DIR_SE'/methyl_call'

CALL_PATH=$(ls $DEDU_DIR/*$MERGED_SUFFIX | sed -n "$INDEX"p)
FILE_NAME=${CALL_PATH##*/}
SAMPLE_NAME=${FILE_NAME%$MERGED_SUFFIX*}


bismark_methylation_extractor --gzip --CX --output_dir $CALL_DIR \
--bedGraph \
--scaffolds \
$DEDU_DIR/$FILE_NAME

wait
conda deactivate
