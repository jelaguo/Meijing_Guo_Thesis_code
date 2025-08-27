#!/bin/bash

#SBATCH -J bismark            # job name
#SBATCH -a 1-12%12                      # job array
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
ALL_SUFFIX='.bam'
ALIGN1_SUFFIX='1.bam'
ALIGN2_SUFFIX='2.bam'
DEDU_DIR=$ALIGN_DIR_SE'/deduplication'

ALIGN_PATH1=$(ls $ALIGN_DIR_SE/*$ALIGN1_SUFFIX | sed -n "$INDEX"p)
ALIGN_PATH2=${ALIGN_PATH1/$ALIGN1_SUFFIX/$ALIGN2_SUFFIX}
ALIGN_FILE_NAME=${ALIGN_PATH1##*/}
SAMPLE_NAME=${ALIGN_FILE_NAME%$ALIGN1_SUFFIX*}
echo $SAMPLE_NAME

deduplicate_bismark $ALIGN_PATH1 -s -bam -o $SAMPLE_NAME.1 --output_dir $DEDU_DIR
deduplicate_bismark $ALIGN_PATH2 -s -bam -o $SAMPLE_NAME.2 --output_dir $DEDU_DIR
samtools merge -n $DEDU_DIR/$SAMPLE_NAME'_dedup.merged.bam' $DEDU_DIR/$SAMPLE_NAME'.1.deduplicated.bam' $DEDU_DIR/$SAMPLE_NAME'.2.deduplicated.bam'
rm $DEDU_DIR/$SAMPLE_NAME'.1.deduplicated.bam' $DEDU_DIR/$SAMPLE_NAME'.2.deduplicated.bam'
conda deactivate




