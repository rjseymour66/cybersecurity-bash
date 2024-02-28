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