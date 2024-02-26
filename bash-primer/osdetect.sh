#!/bin/bash - 
#
# osdetect.sh
#
# Description:
# Distinguish between MS-Windows/Linux/MacOS
#
# Usage: bash osdetect.sh
#   output will be one of: Linux MSWin macOS

# 'type' checks what kind of command its arg is. -t tells it 
# to print nothing if nothing is found. 
# 
# Redirect STDOUT and STDERR to /dev/null
if type -t wevtutil &> /dev/null
then
    OS=MSWin
elif type -t scutil &> /dev/null
then
    OS=macOS
else
    OS=Linux
fi
echo $OS