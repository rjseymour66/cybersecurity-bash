#!/bin/bash -
#
# Cybersecurity Ops with bash
# histogram_plain.sh
#
# Description:
# Generate a horizontal bar chart of specified data without
# associative arrays, good for older versions of bash
#
# Usage: ./histogram_plain.sh
#  input format: label value
#

function pr_bar() {
    local -i i raw maxraw scaled
    raw=$1
    maxraw=$2
    ((scaled = (MAXBAR * raw) / maxraw))
    # min size guarantee
    ((raw > 0 && scaled == 0)) && scaled=1

    for ((i = 0; i < scaled; i++)); do printf '#'; done
    printf '\n'
} # pr_bar

declare -a RA_key RA_val
declare -i max ndx
max=0
maxbar=50 # how large the bar should be

ndx=0
while read labl val; do
    RA_key[$ndx]=$labl
    RA_val[$ndx]=$val
    # keep the largest value; for scaling
    ((val > max)) && max=$val
    let ndx++
done

# scale and print it
for ((j = 0; j < ndx; j++)); do
    printf "%-20.20s " ${RA_key[$j]}
    pr_bar ${RA_val[$j]} $max
done
