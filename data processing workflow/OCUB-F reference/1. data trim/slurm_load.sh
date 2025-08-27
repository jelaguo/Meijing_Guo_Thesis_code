#!/bin/bash

#SBATCH -J methyl_cutadapt            # job name
#SBATCH -a 1-1%1			# job array  (see ncore) 
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

FASTQ_DIR='/data/scratch/DBC/UBCN/CANCDYN/jguo/all-seq/01/SLX-23666/all/OCUBF_R/fastq/raw'
# Get read file names
FASTQ1_PATH=$(ls $FASTQ_DIR/*$FASTQ1_SUFFIX | sed -n "$INDEX"p)
FASTQ2_PATH=${FASTQ1_PATH/$FASTQ1_SUFFIX/$FASTQ2_SUFFIX}
#remove path, get file name (ie anything before final / )
FASTQ1_FILE_NAME=${FASTQ1_PATH##*/}
#get sample name, remove $FASTQ1_SUFFIX
SAMPLE_NAME=${FASTQ1_FILE_NAME%$FASTQ1_SUFFIX*}
echo "[methylseq] Analysing samples with stem: $SAMPLE_NAME"

cp $FASTQ1_PATH $DEMUL_DIR/$SAMPLE_NAME'.r_1.fq.gz'
cp $FASTQ2_PATH $DEMUL_DIR/$SAMPLE_NAME'.r_2.fq.gz'

fastqc -q -t 8 $DEMUL_DIR/$SAMPLE_NAME.r_1.fq.gz $DEMUL_DIR/$SAMPLE_NAME.r_2.fq.gz -o $DEMUL_DIR'/fq'
fi

wait
conda deactivate
