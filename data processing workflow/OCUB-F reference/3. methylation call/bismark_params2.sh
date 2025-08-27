#!/bin/bash

NUM_CORES=$SLURM_NTASKS 
INDEX=$SLURM_ARRAY_TASK_ID

# Directories and paths

WD='/data/scratch/DBC/UBCN/CANCDYN/jguo/all-seq/01/SLX-23666/all/OCUBF_R'


FIN_TRIM_DIR=$WD'/fastq/round1-3'   
FIN_TRIM_DIR2=$WD'/fastq/round4-5'
FASTQ1_SUFFIX=".r_1.fq.gz"  
FASTQ2_SUFFIX="${FASTQ1_SUFFIX/1/2}"

TRIM1_PATH=$(ls $FIN_TRIM_DIR/*$FASTQ1_SUFFIX | sed -n "$INDEX"p)
TRIM2_PATH=${TRIM1_PATH/$FASTQ1_SUFFIX/$FASTQ2_SUFFIX}

ALIGN_DIR_SE=$WD'/bismark/SE/nondirectional'
ALIGN_DIR_PE=$WD'/bismark/PE/nondirectional'
#remove path, get file name (ie anything before final / )
TRIM1_FILE_NAME=${TRIM1_PATH##*/}
#get sample name, remove $FASTQ1_SUFFIX
SAMPLE_NAME=${TRIM1_FILE_NAME%$FASTQ1_SUFFIX*}



echo "[methylseq $(date +"%Y-%m-%d %T")] Starting pipeline"
echo "Using: $NUM_CORES cores"

