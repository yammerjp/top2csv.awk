# top2csv.awk

top2csv.awk formats the output of the `top` command into CSV format

## Usage

```sh
# Change directory to the root directory of this repository
cd /path/to/top2csv.awk

# Outputs CPU and memory usage and other data at specified times and a fixed number of times.
top -b -d 10 -n 6 -i > top.log

# create csv
cat top.log | awk -f top2csv.awk > top.csv

# if you want to output in TSV format
cat top.log | awk -f top2csv.awk -v FORMAT="TSV" > top.tsv
```
