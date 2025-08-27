#!/bin/bash

#SBATCH -J methyl_cutadapt            # job name
#SBATCH -a 1-12%12			# job array  
#SBATCH -N 1                # number of nodes
#SBATCH -c 8                # number of cores  (this was adjusted based on the job size)
#SBATCH --mem-per-cpu 8042  # memory pool for all cores
#SBATCH -t 0-2:00           # time (D-HH:MM)
#SBATCH -o methyl.%a.out  # STDOUT
#SBATCH -e methyl.%a.err  # STDERR

source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate methylation_env

NUM_CORES=$SLURM_NTASKS
INDEX=$SLURM_ARRAY_TASK_ID

source ./dem_cut_params.sh

ROUND2_SUFFIX1='.r_1.round2.fq.gz'
ROUND2_SUFFIX2='.r_2.round2.fq.gz'

TRIM1_PATH=$(ls $TRIM1_DIR/*$ROUND2_SUFFIX1 | sed -n "$INDEX"p)
TRIM2_PATH=${TRIM1_PATH/$ROUND2_SUFFIX1/$ROUND2_SUFFIX2}
TRIM1_FILE_NAME=${TRIM1_PATH##*/}
TRIM2_FILE_NAME=${TRIM2_PATH##*/}
TRIM_NAME=${TRIM1_FILE_NAME%$ROUND2_SUFFIX1*}

cutadapt -j 0 \
-u -5 -U -5 \
-u 40 -U 40 \
--nextseq-trim=20 \
--pair-filter=any \
--minimum-length=35 \
--json=$REPORT_CUTADAPT_DIR1_3/$TRIM_NAME'.cutadapt-03.json' \
-o $TRIM1_DIR/$TRIM_NAME'.r_1.round3.fq.gz' \
-p $TRIM1_DIR/$TRIM_NAME'.r_2.round3.fq.gz' \
$TRIM1_PATH $TRIM2_PATH &> $REPORT_CUTADAPT_DIR1_3'/txt'/$TRIM_NAME'.cutadapt-03.txt'



fastqc -q -t 8 $TRIM1_DIR/$TRIM_NAME.r_1.round3.fq.gz $TRIM1_DIR/$TRIM_NAME.r_2.round3.fq.gz -o $REPORT_CUTADAPT_DIR1_3'/txt/fq'

wait
conda deactivate


