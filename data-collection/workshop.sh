#!/bin/bash

# 4. ls -R on 192.168.10.32 and write to filelist.txt
ssh 192.168.10.32 ls -R >filelist.txt

# 5. getlocal.sh to scp to server
DumpInfo >"$TMPFILE" 2>&1

scp "$TMPFILE" user@someserver:/home/user/"$TMPFILE"

# 6.
