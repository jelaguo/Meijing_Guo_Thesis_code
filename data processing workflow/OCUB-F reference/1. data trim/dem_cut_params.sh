#!/bin/bash

NUM_CORES=$SLURM_NTASKS 
INDEX=$SLURM_ARRAY_TASK_ID

# Directories and paths

WD='/data/scratch/DBC/UBCN/CANCDYN/jguo/all-seq/01/SLX-23666/all/OCUBF_R'

TRIM1_DIR=$WD'/fastq/round1-3'
DEMUL_DIR=$WD'/demul'


REPORT_CUTADAPT_DIR1=$WD'/qc/round1-3/1'
REPORT_CUTADAPT_DIR1_2=$WD'/qc/round1-3/2'
REPORT_CUTADAPT_DIR1_3=$WD'/qc/round1-3/3'


FASTQ1_SUFFIX=".r_1.fq.gz"  
FASTQ2_SUFFIX="${FASTQ1_SUFFIX/1/2}"



