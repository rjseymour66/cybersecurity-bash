#!/bin/bash -
#
# Cybersecurity Ops with bash
# histogram.sh
#
# Description:
# Generate a horizontal bar chart of specified data
#
# Usage: ./histogram.sh
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

#
# "main"
#
declare -A RA
declare -i MAXBAR max
max=0
MAXBAR=50 # how large the largest bar should be

while read labl val; do
    let RA[$labl]=$val
    # keep the largest value; for scaling
    ((val > max)) && max=$val
done

# scale and print it
for labl in "${!RA[@]}"; do
    printf '%-20.20s ' "$labl"
    pr_bar ${RA[$labl]} $max
done
