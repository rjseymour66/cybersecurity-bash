## awk

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

```bash
# join the 3rd field of file1.txt with 1st field of file2.txt
# -t specifies the comma "," as the delimiter
join -1 3 -2 1 -t, file1.txt file2.txt
```

## sed

Perform edits on a stream of data, such as replacing characters (called _in place_ replacement):

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

Output last lines of file. 10 by default:

```bash
# output last line
tail -n 1 file.txt
```

## tr

Translate or map from one character to another, deleted unwanted characters. Only reads from STDIN and writes to STDOUT:

```bash
# change all backslashes to forward slashes and colons to bars
# need 2 backslashes to escape the second one--backslash is special in tr ('\n', '\r', etc)
# character position in first arg map to char position in the second 
tr '\\:' '/|' < infile.txt > outfile.txt

# convert Windows line endings to linux
tr -d '\r' < wrong.txt > right.txt
```