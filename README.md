# Cybersecurity Bash

The command line is all of the various non-GUI executables installed wtih an OS, including the built-ins, executables, keywords, and scripting capabilities available from the shell--the command line _interface_. Its how commands were given to a computer before GUIs.

## Basics

When several words appear on the command line, bash assumes that the first word is the name of the program to run and the remaining words are command arguments.

### Commands, Args, Built-ins, and Keywords

The commands that you can run are either files, built-ins, or keywords:
- files are executable programs
- built-ins are part of the shell, such as `pwd` or `cd`
- keywords are part of the language of the shell, such as `if`

### STDIN, STDOUT, STDERR

Every program is a process, and every process has 3 distinct file descriptors:
- `stdin`: File descriptor 0. Default source for input to a program
- `stdout`: File descriptor 1. Default place for sending output (the console)
- `stderr`: File descriptor 2. Where error messages are written


### Redirection and piping

Redirection is when you change the input and outputs of a program without modifying the program.

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