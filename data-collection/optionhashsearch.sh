#!/bin/bash -
#
# Cybersecurity Ops with bash
# hashsearch.sh
#
# Description:
# Recursively search a given directory for a file that
# matches a given SHA-1 hash
#
# Usage:
# optionhashsearch.sh <hash> <directory> [-1]
#   hash - SHA-1 hash value to file to find
#   directory - Top directory to start search
#   -1 - Stop searching when a match is found

HASH=$1
DIR=${2:-.}
ONEMATCH=$3

# convert pathname into an absolute path
function mkabspath() {
    if [[ $1 == /* ]]; then
        ABS=$1
    else
        ABS="$PWD/$1"
    fi
}

find $DIR -type f |
    while read fn; do
        THISONE=$(sha1sum "$fn")
        THISONE=${THISONE%% *}
        if [[ $THISONE == $HASH ]]; then
            mkabspath "$fn"
            echo $ABS
            if [[ $ONEMATCH ]]; then
                exit
            fi
        fi
    done
