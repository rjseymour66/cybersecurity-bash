#!/bin/bash - 
#
# argcnt.sh
#
# Description:
# Counts the number of arguments passed to the script.
#
# Usage: ./argcnt.sh <param-1> <param-2> <param-3>

# how many arguments are supplied to the script
echo there are $# arguments

# label each argument
i=0
for var
do
    echo "arg$i: $var"
    let i++
done

# list only the even arguments
printf "\n**** Evens only ****\n"

k=0
for var
do
    VAL=$((k % 2))
    if [[ $VAL -eq 0 ]]
    then
        echo "arg$k: $var"
    fi
    let k++
done