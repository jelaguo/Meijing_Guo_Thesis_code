# run in each respective bismark alignment directory on reads aligned via single end mode
for file in *_report.txt; do
>   grep -E "Number of alignments with a unique best hit|Mapping efficiency" "$file" | sed "s|^|$file:|"
> done > mapping_summary.txt