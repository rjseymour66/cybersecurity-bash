## awk
- `-f` custom field delimiter. Space is default 

```bash
# print each line where the users last name is jones (first last)
# space is default delimiter
# $0 is whole line
# $1 is first word, etc
# compare second word ($2), then print line
# awk runs the code in the braces
awk '$2 == "Jones" {print $0}' awkusers.txt
```

## join

Combines lines of two files that share a common field.

- `-j` join using the specified field number
- `-t` specify char to use as a field separator. Space is default.
- `--header` use first line of each file as the header

```bash
# join the 3rd field of file1.txt with 1st field of file2.txt
# -t specifies the comma "," as the delimiter
join -1 3 -2 1 -t, file1.txt file2.txt
```

## sed

Perform edits on a stream of data, such as replacing characters (called _in place_ replacement):

- -i edit specified file and overwrite in place

```bash
# in a file, replace all instances of 10.0.4.35 with 10.0.4.27
sed 's/10\.0\.4\.35/10.0.4.27/g' ips.txt
# s/<regex>/<replace with>/<flags>
# s is substitute
# g is global, so it replaces each occurence on the line, not just the first.

# convert Linux line endings to Windows
# -i makes the changes in place
sed -i 's/$/\r/' linux.txt
```

## tail

Output last lines of file. 10 by default.

- `-f` monitor the file and output lines as they're added
- `-n` output number of lines specified. `-n +2` starts output at second line of file

```bash
# output last line
tail -n 1 file.txt
```

## tr

Translate or map from one character to another, deleted unwanted characters. Only reads from STDIN and writes to STDOUT.

- `-d` delete the character from the input stream
- `-s` (squeeze) replace repeated instances of a character with a single instance

```bash
# change all backslashes to forward slashes and colons to bars
# need 2 backslashes to escape the second one--backslash is special in tr ('\n', '\r', etc)
# character position in first arg map to char position in the second 
tr '\\:' '/|' < infile.txt > outfile.txt

# convert Windows line endings to linux
tr -d '\r' < wrong.txt > right.txt
```

## Processing delimited files

```bash
# get just first field, 'name' in this case
cut -d ',' -f1 file.txt

# extract fields 1 - 3
cut -d ',' -f1-3

# extract fields 1 and 4
cut -d ',' -f1,4

# pass to tr to remove char then skip top line with tail
cut -d ',' -f1 file.txt | tr -d '"' | tail -n +2
```

### Iterating through delmited data

`awk` can process line-by-line and match against other files

```bash
# grep for the output of awk subshell command in passwords file
# this will return matches for each line of the awk command
grep "$(awk -F "," '{print $4}' csvex.txt)" passwords.txt 
```

### Processing by character position

```bash
# chain 2 cut commands to get the 3rd field, then chars from the field
cut -d ',' -f3 csvex.txt | cut -c2-13 | tail -n +2

# cut from character 2 to end of line
cut -d ' ' -f4,10 filename.txt | cut -c2-
```

## JSON

```bash
# extract k/v pair (-o displays match only, not whole line)
grep -o '"keyName": ".*"' file.json
grep -o '"firstName": ".*"' file.json

# get value with no '"'
grep -o '"keyName": ".*"' file.json | cut -d " " -f2 | tr -d '\"'

# jq
# get val for key .title
jq '.title' book.json 

# get vals for every firstName key in authors array
jq '.authors[].firstName' book.json 

# get vals for index 1 firstName key in authors array
jq '.authors[1].firstName' book.json 
```

## Aggregating data

```bash
# find all files in /data, grep for the value, then cat each grepped line to the .txt file
find /data -type f -exec grep '{}' -e 'ProductionWebServer' \; -exec cat '{}' >> ProductionWebServerAgg.txt \;
```