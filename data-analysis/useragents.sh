#!/bin/bash -
#
# Cybersecurity Ops with bash
# useragents.sh
#
# Description:
# Read through a log looking for unknown user agents
#
# Usage:
# pagereq ./useragents.sh < <inputfile>
#   <inputfile> Apache access log
#

# mismatch - search through the array of known names
#   returns 1 (false) if it finds a match
#   returns 0 (true) if there is no match

# default first arg
FILENAME=${1:-'known.hosts'}

function mismatch() {
    local -i i
    for ((i = 0; i < $KNSIZE; i++)); do
        [[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1
    done
    return 0
}

# read up the known ones
readarray -t KNOWN <"useragents.txt"
KNSIZE=${#KNOWN[@]}

# preprocess logfile (stdin) to pick out ipaddr and user agent
awk -F'"' '{print $1, $6}' |
    while read ipaddr dash1 dash2 dtstamp delta useragent; do
        if mismatch "$useragent"; then
            echo "anomaly: $ipaddr $useragent"
        fi
    done
