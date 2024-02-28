#!/bin/bash -
#
# printnames.sh
#
# Description:
# Reads names and writes them to a file
#
# Usage:
# bash readnames.sh < cmds.txt
#  names.txt is a file with a list of names
#

function FormatNames() {
    # print lastname, firstname
    FIRST=${LINE%%|*}
    FIRST_TRIM=$(echo $FIRST | tr -d '[:space:]')
    LAST=${LINE##*|}
    LAST_TRIM=$(echo $LAST | tr -d '[:space:]')
    printf '%s, %s\n' "$FIRST_TRIM" "$LAST_TRIM"
}

function WriteNames() {
    printf 'Data analyzed on host "%s"\n' "$HOSTNAME"
    printf 'Report run by "%s"\n\n' "$USER"

    readarray INPUTARRAY

    for LINE in "${INPUTARRAY[@]}"; do

        # ignore comments
        if [[ ${LINE:0:1} == '#' ]]; then continue; fi

        FormatNames

    done
    printf "\nProcessing Complete\n"
}

WriteNames >"info.info" 2>&1
