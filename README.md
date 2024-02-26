# Cybersecurity Bash

The command line is all of the various non-GUI executables installed wtih an OS, including the built-ins, executables, keywords, and scripting capabilities available from the shell--the command line _interface_. Its how commands were given to a computer before GUIs.

## Basics

When several words appear on the command line, bash assumes that the first word is the name of the program to run and the remaining words are command arguments.

### Commands, Args, Built-ins, and Keywords

The commands that you can run are either files, built-ins, or keywords:
- files are executable programs
- built-ins are part of the shell, such as `pwd` or `cd`
- keywords are part of the language of the shell, such as `if`

## Commands

```bash
$ type -t cat # identify what the argument is
file

# compgen lists what commands (-c), keywords (-k), and built-ins (-b) are available
$ compgen -k
if
then
else
elif
fi
case
esac
...
```

### STDIN, STDOUT, STDERR

Every program is a process, and every process has 3 distinct file descriptors:
- `stdin`: File descriptor 0. Default source for input to a program
- `stdout`: File descriptor 1. Default place for sending output (the console)
- `stderr`: File descriptor 2. Where error messages are written


### Redirection and piping

Redirection is when you change the input and outputs of a program without modifying the program.

| Operator | Description | Example |
|----------|:------------|---------|
| `>` | Sends the output of the value on the left to the value on the right. | `$ ls -la > listing.out` |
| `<` | Sends the value on the right to the STDIN of the value on the left. | `$ program < input.txt` |
| `2>` | Redirect STDERR messages to the value on the right. | `$ cp -r /etc/a /etc/b 2> err.msg` |
| `2>&1`, `&>`| Send output to STDOUT and STDERR. Place this  | `XXXXXXXXXXX` |

The following command sends `input.txt` to the STDIN of `program`, and sends the output to `output.out`:
```bash
$ program < input.txt > output.out
```

To distinguish between STDOUT and STDERR, use the file descriptor `2>`. The following command redirects error messages to `err.msgs`:
```bash
$ program 2> err.msgs
```
Or, combine all redirection methods:
```bash
$ program < input.txt > output.out 2> err.msgs
```

Combined redirect: To send STDERR to the same location as STDOUT, combine the error messages with the standard output:
```bash
$ program < input.txt > output.out 2>&1
# shorthand
$ program < input.txt &> output.out
```
The previous command sends input.txt to program, then sends the STDOUT and STDERR to output.out. The shorthand is more clear.

Commonly, you can discard STDOUT by sending it to `/dev/null`:
```bash
$ program < input.txt > /dev/null
```

The `tee` command sends output to STDOUT and the file that follows the command:
```bash
$ program < input.txt | tee results.out # the -a option allows tee to append to the file
```
To append to a file, use the `>>` operator:
```bash
$ program < input.txt >> appended.file
```
To append STDOUT and STDERR, use `&>>`:
```bash
$ program < input.txt &>> appended.file
```

### Running commands in the background

Use the `&` operator at the end of the command to run it in the background:
```bash
$ ping 10.20.30.40 > ping.log &
```

When you run a task in the background, send both STDOUT and STDERR so the task doesn't log everything to the console:
```bash
$ ping 10.20.30.40 &> ping.log &
```

To bring a job back to the foreground, use `jobs` to list running tasks, then use `fg` with the corresponding task number:
```bash
$ ping 192.168.10.56 &> ping.log &
[1] 7452
$ jobs
[1]+  Running                 ping 192.168.10.56 &> ping.log &
$ fg 1
ping 192.168.10.56 &> ping.log
^C
```
Stop a running job with `Ctrl+z`, and send it to the background with `bg`:
```bash
$ ping 192.168.10.56 &> ping.log &
[1] 7572
$ fg 1
ping 192.168.10.56 &> ping.log
^Z
[1]+  Stopped                 ping 192.168.10.56 &> ping.log
$ bg 1
[1]+ ping 192.168.10.56 &> ping.log &
$ fg 1
ping 192.168.10.56 &> ping.log
^C
```

## Scripts

Scripts contain more than one shell commands. Use `chmod 755 scriptname` to make it executable. Begin each bash script with one of the following lines:
```bash
#!/bin/bash -
#!/usr/bin/env bash
```

The second option uses `env` to look up the location of the `bash` executable. This is supposed to solve portability problems.

## Bash primer

```bash
# output
echo 'word'
printf 'word\n'
```

### Variables

```bash
VARNAME=varvaluetext
# to get the var, prepend a $
echo $VARNAME

# single quotes preseve space
VARNAME='this is the variable value'
# double quotes allow substitutions
NEWVAR="this is $VARNAME"

# store value of shell command
PRINTDIR=$(pwd)
echo $PRINTDIR
```
### Positional parameters

```bash
$@ # stores all args and makes them avaialable in array
$0 # name of script
$1 # first param
$2 # second param
$# # number of params passed

for var in $@
do
    echo "Hello, $var."
done

# 'for' loops over the arguments by default, as long as you don't ad the 'in x' part
for ARG
do
    echo here is an argument: $ARG
done
```

### Input

```bash
# read accepts input from stdin and stores in var
read INPUTVAR
echo $INPUTVAR
```

### Conditionals

> `$?` stores the return code for a command. Use it directly after the command runs.

```bash
# if a command returns a 0, then do x, y, and z
if <command>
then
    <something>
else
    <something else>
fi
```

### Tests

| Operator | Use case |
|:---------|:---------|
| -d | Test if directory exists|
| -e | Test if file exists|
| -r | Test if file exists and is readable |
| -w | Test if file exists and is writeable |
| -x | Test if file exists and is executable |
| -eq | Test if numbers are equal |
| -gt | Test if first number is greater than second number |
| -lt | Test if first number is less than second number |

```bash
# [[ ]] is the compound command
if [[ -e $FILENAME ]]
then
    echo $FILENAME existsd
fi

# numbers
if [[ $VAL -lt $MIN ]]
then
    echo "$VAL is too small"
fi

# for arithmetic operations, or when comparing numbers with 
# the < or > signs, use (( ))
if (( VAL > 2))
then
    echo "value $VAL is too small
fi

if (( $? )) ; then echo "previous command failed" ; fi
```

### Loops


```bash
# while loop
i=0
while (( i < 100 ))
do
    echo $i
    let i++
done

# for loop
for ((i=0; i < 100; i++))
do
    echo $i
done
```

### Functions

Function arguments are accessible with $1, $2,.... You have to store the script args in variables to use them in functions
- $# is the number of args passed to the func
- $0 is still the name of the script

Functions return a status. To return other values, set a variable to hold the value.

```bash
function myfunc()
{
    # do something
}

# call functions like a shell command
myfunc arg1 arg2 arg3

# both of these functions run in a subshell
myfunc arg1 arg1 | next-step | etc
RETVAL=$(myfunc arg1 arg1)
```

### Pattern matching

```bash
*   # match any number of any character
?   # match a single character ex. source.? returns source.c but not source.cpp
[ ] # match any of the characters within the brackets
```

#### Bracket matching

```bash
[0-9]  # range
[!cat] # match anything other than the chars in the brackets
[^cat] # match anything other than the chars in the brackets
*[[:punct:]]jpg # match any file with any number of characters followed by a 
                # punctuation character, then 'jpg'
```

> more patterns if you turn on shell's `extglob` option

| Character class | Description |
|:----------------|:------------|
| [:alnum:] | Alphanumeric |
| [:alpha:] | Alphabetic|
| [:ascii:] | ASCII |
| [:blank:] | Space and tab|
| [:ctrl:]  | Control characters|
| [:digit:] | Number|
| [:graph:] | Anything other than control characters and space|
| [:lower:] | Lowercase|
| [:print:] | Anything other than control characters|
| [:punct:] | Puncuation|
| [:space:] | Whitespace, including line breaks|
| [:upper:] | Uppercase|
| [:word:]  | Letters, numbers, and underscore|
| [:xdigit:] | Hexadecimal |

## Regex primer

In bash, regex are valid only when using the `=~` comparison in the double-bracket (`[[ ]]`) compound command.

### grep

Searches a file for a pattern and prints the line if there is a match:

```bash
grep <options> <pattern> <filenames>
grep -R -i 'password' /home

# egrep to extend syntax for ?, +, {, |, (, and )
```

| Option | Description |
|:-------|:------------|
| `-c`   | Count number of lines that match the pattern |
| `-E`   | Enable extended regex |
| `-f`   | Read from a file |
| `-i`   | Ignore case |
| `-l`   | Print only filename and path where the pattern was found |
| `-n`   | Print line number where pattern was found |
| `-P`   | Enable Perl regex (for [shortcuts](#shortcuts)) |
| `-R, -r` | Recursively search subdirectories |

### Metacharacters

Escape with `\` to treat characters without special meaning.

```bash
. # match any single character except newline
? # preceding char is optional, match zero or one time
* # preceding char is optional, match zero or more times
+ # match preceding char one or more times
```

### Grouping 

group with parentheses to treat characters as one item

```bash
egrep 'And be one (stranger|traveler), long I stood' frost.txt 
3    And be one traveler, long I stood
```
### Brackets and character classes

`[]` define character classes and lists of acceptable characters:

| Example | Description |
|:--------|:------------|
| `[abc]` | Match only `a`, `b`, or `c` |
| `[1-5]` | Match digits in range from `1` to `5` |
| `[a-zA-Z]` | Match lower or uppercase letter |
| `[0-9 +-*/]` | Match any number or math symbol |
| `[0-9a-fA-F]` | Match any hexadecmial digit |
| `[1-475]` | Match numbers between `1` and `4`, and digits `7` and `5` |

#### Shortcuts

> Not supported by `egrep`, must use `-P` option:

| Shortcut | Description |
|:---------|:------------|
| `\s`  | Whitespace  |
| `\S`  | Not whitespace |
| `\d`  | Digit |
| `\D`  | Not digit |
| `\w`  | Word |
| `\W`  | Not word |
| `\x`  | Hexidecimal number |

#### Character classes

Only match single character, use `+` or `*` to find repetition, and has to be in brackets (`[[:<char-class>:]]`):

| Character class | Description |
|:----------------|:------------|
| [:alnum:] | Alphanumeric |
| [:alpha:] | Alphabetic|
| [:ctrl:]  | Control characters|
| [:digit:] | Number|
| [:graph:] | Anything other than control characters and space|
| [:lower:] | Lowercase|
| [:print:] | Anything other than control characters|
| [:punct:] | Puncuation|
| [:space:] | Whitespace, including line breaks|
| [:xdigit:] | Hexadecimal |

### Back references

A back reference lets you reference a previous regex match. You have to close the regex in `( )`, and then reference it later with a backslash and number.

The following back reference matches any HTML tag. The `\1` means, "match again with whatever was matched in the preceding parentheses":

```bash
egrep <([a-zA-Z]*)>.*</\1> file.txt
```

You can have more than one back reference, e.g. `()...\2`, `()...\3`, etc..

### Quantifiers

```bash
T{5}   # T must appear 5 consecutive times
T{3,6} # T must appear 3 to 6 times
T{5,}  # T must appear 5 or more times
```

### Anchors and word boundaries

```bash
^[1-5] # beginning anchor. Matching string must start with 1-5 as the first char
[1-5]$ # end anchor. Matching string must end with 1-5 as the first char
```