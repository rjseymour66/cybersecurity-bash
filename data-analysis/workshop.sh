#!/bin/bash -
#
# Workshop questions pg 107
#

# 1. write this command with awk:
# cut -d ' ' -f1,10 access.log | ./summer.sh | sort -k 2.1 -rn

awk '{print $1 " " $10}' access.log | ./summer.sh | sort -k 2.1 -rn

# 2. Add count at end of each histogram line
