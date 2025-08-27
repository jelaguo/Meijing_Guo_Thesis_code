# Run respectively in each methylation extraction directory on bismark report files
for file in *_splitting_report.txt; do
>   grep -E "Total number of methylation call strings processed:" "$file" | sed "s|^|$file:|"
> done > methylation_mapping_summary.txt