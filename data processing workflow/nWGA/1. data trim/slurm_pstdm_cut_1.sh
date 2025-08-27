#!/bin/bash

#SBATCH -J methyl_cutadapt            # job name
#SBATCH -a 1-12%12			# job array  (see ncore) (the actual number is 1-24%24 but for dummy test we run 2)
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



DEMUL1_PATH=$(ls $DEMUL_DIR/*$FASTQ1_SUFFIX | sed -n "$INDEX"p)
DEMUL2_PATH=${DEMUL1_PATH/$FASTQ1_SUFFIX/$FASTQ2_SUFFIX}
DEMUL1_FILE_NAME=${DEMUL1_PATH##*/}
DEMUL2_FILE_NAME=${DEMUL2_PATH##*/}
DEMUL_NAME=${DEMUL1_FILE_NAME%$FASTQ1_SUFFIX*}

cutadapt -j 0 \
--nextseq-trim=20 \
--times=2 \
-a AGATCGGAAGAGC \
-A AGATCGGAAGAGC \
--minimum-length=35 \
--json=$REPORT_CUTADAPT_DIR1'/json'/$DEMUL_NAME'.cutadapt-01.json' \
-o $TRIM1_DIR/$DEMUL_NAME'.r_1.fq.gz' \
-p $TRIM1_DIR/$DEMUL_NAME'.r_2.fq.gz' \
$DEMUL1_PATH $DEMUL2_PATH &> $REPORT_CUTADAPT_DIR1'/txt'/$DEMUL_NAME'.cutadapt-01.txt'


fastqc -q -t 8 $TRIM1_DIR/$DEMUL_NAME.r_1.fq.gz $TRIM1_DIR/$DEMUL_NAME.r_2.fq.gz -o $REPORT_CUTADAPT_DIR1'/txt/fq'


wait
conda deactivate



