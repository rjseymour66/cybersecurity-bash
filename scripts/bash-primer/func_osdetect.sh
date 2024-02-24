#!/bin/bash - 
#
# func_osdetect.sh
#
# Description:
# Distinguish between MS-Windows/Linux/MacOS
#
# Usage: bash osdetect.sh
#   output will be one of: Linux MSWin macOS

function getOS()
{
    if type -t wevtutil &> /dev/null
    then
        echo MSWin
    elif type -t scutil &> /dev/null
    then
        echo macOS
    else
        echo Linux
    fi
}

# OS=$(getOS)
# echo OS
echo $(getOS)