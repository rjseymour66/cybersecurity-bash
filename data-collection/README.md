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
ssh ps > filename.out

# redirect on remote machine
#   backslash escapes > on local shell, passes to 
#   remote where it is executed)
ssh ps \> /tmp/ps.out

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

| Linux Command   |MSWin  Bash |XML tag    |Purpose |
|-----------------+------------+-----------+--------|
| uname -a        |uname -a    |uname      |O.S. version etc|
|cat /proc/cpuinfo|systeminfo  |sysinfo    |system hardware and related info|
|ifconfig         |ipconfig    |nwinterface|Network interface information|
|ip route         |route print |nwroute    |routing table|
|arp -a           |arp -a      |nwarp      |ARP table|
|netstat -a       |netstat -a  |netstat    |network connections|
|mount            |net share   |diskinfo   |mounted disks|
|ps -e            |tasklist    |processes  |running processes|


## readarray

`readarray` reads from STDIN and reads until it hits a newline or EOF. Here is how you read from a file:

```bash
readarray INPUTARRAY

for LINE in "${INPUTARRAY[@]}"; do
    # do work
done
```

## String slicing

```bash
# '#' means match from the left (like comments)
# '%' means match from the right (like 5%, in general math) 

# removes everything to the right of STRING, including "|"
VAR=${STRING%%|*}
# removes first match to left of STRING, including "|"
VAR=${STRING#*|}
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