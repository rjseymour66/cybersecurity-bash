## sort

Rearrange a text file into numerical or alpha order.
-r
: descending order

-f
: ignore case

-n
: numerical ordering

-k 
: sort based on key in a line, delmited by whitespace by default

-o
: write output to specified file


```bash
# sort by 3rd column
sort -k 3 filename.txt

# sort by chars 4 and 5 of field 2 (non-zero index)
sort -k 2.4,2.5 filename.txt
```

## uniq

Filters out duplicate lines that occur adjacent to one another. Usually `sort` first:
-c
: prints number of times line is repeated

-f
: ignore the specified number of fields before comparison

-i
: ignore case.

## Sorting and arranging data

Look for extremes--things that occurred least or most frequently:
- requests returning 404
- reqs from single IP address returning 404
- reqs returning 401
 Use `sort`, `head`, `tail` commands at end of pipeline:

```bash
... | sort -k 2.1 -rn | head -15
```

## arrays and associative arrays (bash 4.0+) and `read`

```bash
# -A is assoc. array for bash 4.0+
declare -A arrayName1 arrayName2

# lowercase a is a regular array
declare -a RA_key RA_val

# access el in array
${ar[index]}

# get key values already in assoc. array (key, val)--don't think
# that the '!' negates a value--it is part of the language
${!ar[@]}

# each variable for read gets assigned the corresponding var
# so, index gets the first word, xtra gets remaining. If there
# are no remaining, xtra is empty string.
while read index xtra
do
    # do stuff
done
```

## get keys in assoc.array

```bash
for var in "${!array[@]}"
do
    # do something
done
```

## formatting strings

```bash
# id is 15 chars long, left-justified (-15)
# %8 is 8 digits long
printf "%-15s %8d\n" "${id}" "{cnt[${id}]}"
```
## local integers

```bash
# use the i to declare integers (4 here)
local -i i raw maxraw scale
```

## double parentheses

```bash
# you don't need $ to indicate 'value of'
((result=(COUNT*i)/maxcount))
```