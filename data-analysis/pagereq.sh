#!/bin/bash -
#
# Cybersecurity Ops with bash
# pagereq.sh
#
# Description:
# Count the number of page requests for a given IP address using bash
#
# Usage:
# pagereq <ip address> < inputfile
#   <ip address> IP address to search for
#

declare -A cnt
while read addr d1 d2 datim gmtoff getr page therest; do
    if [[ $1 == $addr ]]; then let cnt[$page]+=1; fi
done
for id in ${!cnt[@]}; do
    printf "%8d %s\n" ${cnt[$id]} $id
done
