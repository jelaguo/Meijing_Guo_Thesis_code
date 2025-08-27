#!/bin/bash

#SBATCH -J methyl_cutadapt            # job name
#SBATCH -a 1-24%24			# job array  (see ncore) (the actual number is 1-24%24 but for dummy test we run 2)
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
METADATA_FILE='/data/scratch/DBC/UBCN/CANCDYN/jguo/all-seq/01/SLX-23666/metadata/SLX-23666.223WLJLT1.s_1.contents.csv'

FASTQ_DIR='/data/scratch/DBC/UBCN/CANCDYN/jguo/all-seq/01/SLX-23666/fastq' 
# Get read file names
FASTQ1_PATH=$(ls $FASTQ_DIR/*$FASTQ1_SUFFIX | sed -n "$INDEX"p)
FASTQ2_PATH=${FASTQ1_PATH/$FASTQ1_SUFFIX/$FASTQ2_SUFFIX}
#remove path, get file name (ie anything before final / )
FASTQ1_FILE_NAME=${FASTQ1_PATH##*/}
#get sample name, remove $FASTQ1_SUFFIX
SAMPLE_NAME=${FASTQ1_FILE_NAME%$FASTQ1_SUFFIX*}
echo "[methylseq] Analysing samples with stem: $SAMPLE_NAME"

# Establish sample name
BARCODE=$(cut -d\. -f2 <<< "$SAMPLE_NAME")

LINE=$(grep $BARCODE $METADATA_FILE)
SAMPLE_ID=$(echo $LINE | awk -F',' '{ print $4 }' -)
echo "Sample name is: $SAMPLE_ID"

if [ $(grep -ic "Pool" <<< "$SAMPLE_ID" ) -eq 1 ]
then
#this is a pooled sample
    echo "Pooled sample"
else
    echo "Not a pooled sample"
cp $FASTQ1_PATH $DEMUL_DIR/$SAMPLE_ID'.r_1.fq.gz'
cp $FASTQ2_PATH $DEMUL_DIR/$SAMPLE_ID'.r_2.fq.gz'

fastqc -q -t 8 $DEMUL_DIR/$SAMPLE_ID.r_1.fq.gz $DEMUL_DIR/$SAMPLE_ID.r_2.fq.gz -o $DEMUL_DIR'/fq'
fi

wait
conda deactivate
