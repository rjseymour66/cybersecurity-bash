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
# hashsearch.sh <hash> <directory>
#   hash - SHA-1 hash value to file to find
#   directory - Top directory to start search

HASH=$1
DIR=${2:-.} # if $2 is not set, default to cwd

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
            echo ${ABS\.\.\//}
        fi
    done

# 3c1bb0cd5d67dddc02fae50bf56d3a3a4cbc7204
