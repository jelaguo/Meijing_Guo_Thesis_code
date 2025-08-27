
#run in each respective demultiplexed directory on raw fastq files
out_tsv="./demul_reads.tsv"

# Start/overwrite output file
echo -e "Sample\tCount" > "$out_tsv"

# Loop over all per-sample FASTQ.gz files
for f in ./*.fastq.gz; do
    name=$(basename "$f" .fastq.gz)
    count=$(zcat "$f" | awk 'END {print NR/4}')
    echo -e "${name}\t${count}" >> "$out_tsv"
done