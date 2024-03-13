#!/bin/bash -
#
# Cybersecurity Ops with bash
# countem.sh
#
# Description:
# Count the number of instances of an item using bash
#
# Usage:
# countem.sh < inputfile
#
# script equivalent:
# cut -d ' ' -f1 access.log | sort | uniq -c | sort -rn

declare -A cnt # assoc. array
while read id xtra; do
    let cnt[$id]++
done
# now display what we counted
# for each key in the (key,value) assoc. array
for id in "${!cnt[@]}"; do
    printf '%d %s\n' "${cnt[$id]}" "$id"
done
