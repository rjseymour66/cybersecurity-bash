#!/bin/bash

# 1. cut to get col 1, 2, 5
cut -d ';' -f1,2,5 tasks.txt

# 2. join to merge w texts
# procowner: 2, task: 2
join -1 2 -2 2 -t\; procowner.txt tasks.txt

# 3. tr replace all ; in task with tab and print to STDOUT
tr ';' '\t' <tasks.txt

# 4. first and last names of authors
find . -name book.json -exec grep -o '"firstName": ".*"' '{}' \; -exec grep -o '"lastName": ".*"' '{}' \;

jq '.authors[].firstName, .authors[].lastName' book.json
