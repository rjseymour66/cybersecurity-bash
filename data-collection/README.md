## Data of interest

- Logfiles in `/var/log`
- Command history in `$HISTFILE` in `.bash_history`
- Temp files
- User data in `/home`
- Browser history

## Remote commands with SSH

Execute remote commands if the remote machine is running the SSH service:

```bash
ssh <hostname> command
ssh mycomputer ps

# redirect to file on local machine
ssh <hostname> ps > filename.out

# redirect on remote machine
#   backslash escapes > on local shell, passes to 
#   remote where it is executed)
ssh <hostname> ps \> /tmp/ps.out

# run local script on remote system.
#   This runs the bash command on the remote and 
#   passes that command the lines of script.sh
ssh <hostname> bash < ./script.sh
```

## Gather Linux logs

```bash
# ${} is parameter expansion, which retrieves the value of a variable
tar -czf ${HOSTNAME}_logs.tar.gz /var/logs
```
- `c` creates archive file
- `z` zips the file
- `f` specifies name for output file

Important log files:
- `/var/log/apache2/`
- `/var/log/auth.log`
- `/var/log/kern.log`
- `/var/log/messages`
- `/var/log/syslog`

Get info about log files from `syslog.conf` or `rsyslog.conf`.

## Gather system info

| Linux Command   |MSWin  Bash |Purpose |
|-----------------|------------|--------|
| uname -a        |uname -a    | O.S. version etc|
|cat /proc/cpuinfo|systeminfo  | system hardware and related info|
|ifconfig         |ipconfig    | Network interface information|
|ip route         |route print | routing table|
|arp -a           |arp -a      | ARP table|
|netstat -a       |netstat -a  | network connections|
|mount            |net share   | mounted disks|
|ps -e            |tasklist    | running processes|


## readarray

`readarray` reads from STDIN and reads until it hits a newline or EOF. Here is how you read from a file:

```bash
readarray INPUTARRAY

for LINE in "${INPUTARRAY[@]}"; do
    # do work
done

# read contents of file into VAR array. -t removes trailing \n
readarry -t VAR < file.txt
```

## String slicing

```bash
# '#' means match from the left (like comments)
# '%' means match from the right (like 5%, in general math) 

# removes everything to the right of STRING, including "|"
VAR=${STRING%%|*}

# removes first match to left of STRING, including "|"
VAR=${STRING#*|}

# removes SUBSTRING
VAR=${STRING//SUBSTRING/}
```

## Searching the filesystem

```bash
# find searchs provided dir and subdir
# name searches for file name that matches pattern
find /home -name '*password*'
find /home -name '.*'

# surpress errors
find /home -name '*password*' 2>/dev/null

# file > 5GB
find /home -size +5G

# find 5 largest files in filesystem, supressing errors
ls / -R -s 2>/dev/null | sort -n -r | head -5

# modified time searches
find /home -mmin -5         # modified less than 5 mins ago
find /home -mtime -1        # modified less than 24 hrs ago
find /home -mtime +2        # modified more than 2 days ago
find /home -atime -1        # modified less than 24 hours ago

# exec option executes the command and replaces '{}' with the filepath
# search for all files in /home that were accessed less than 24 
# hours ago, and copy them to the pwd
find /home -type f -atime -1 -exec cp '{}' ./ \;    # '\;' ends the exec clause, not separate bash commands
                                                    # '{}' expands to the path of each result found in /home

# content search

# search home and subdirs for the string 'password'
grep -r -i /home -e 'password'  # -e means use regex

# find and grep. get all files in /home with password in the title and copy to pwd
find /home -type -f -exec grep 'password' '{}' \; -exec cp '{}' . \;


# search by file type

```

### find in a loop

```bash
find $DIR <option> -type f | while read FN; do
    file $FN | egrep -q $CASEMATCH "$PATTERN"
    if (($? == 0)); then # found one
        echo $FN
        if [[ $COPY ]]; then
            cp -p $FN $DESTDIR
        fi
    fi
done
```

## getops CLI parser

```bash
# while loop that uses getops builtin
# 'c:irR' are the accepted options. ":" means "c" accepts an arg
# opt is user-provided variable that shell stores each option
#   in for the loop
# OPTARG is the arg currently in process
# OPTIND is the next arg
while getopts 'c:irR' opt; do
    case "${opt}" in
    c) # copy found files to specified directory
        COPY=YES
        DESTDIR="$OPTARG"
        ;;
    i) # ignore u/l case differences in search
        CASEMATCH='-i'
        ;;
    [Rr]) # recursive, accept upper or lowercase
        unset DEEPORNOT ;;
    *)  # matches anything--unknown/unsupported option
        # error mesg will com from getopts, so just exit
        exit 2 ;;
    esac
done
# shift resets parsed args. If 3 args were read, this resets the arg count of the next arg to be processed(OPTIND) from $4 to $1.
# getops tracks args with OPTIND-it refers to the next arg to be processed
shift $((OPTIND - 1))
```

### default values

```bash
# :- means if PATTERN isn't set, set to 'PDF document'
# set STARTDIR to '.'
PATTERN=${1:-PDF document} # use 1st arg, but if not set, use 'PDF document'
STARTDIR=${2:-.} # use the 2nd arg, but if not set, use cwd
```

## Message digest value

```bash
$ sha1sum cmd.txt 
a5376365573cea36944c5fafe6793101e096a632  cmd.txt
```

## Transferring data

```bash
# can add a similar line to end of collection scripts
scp info.tar.gz user@hostname:/home/path/to/dest
```

scp 