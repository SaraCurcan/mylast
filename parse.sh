#!/bin/bash

for file in /var/log/auth.log*; do
while read -r line; do
    if echo "$line" | grep -q "New seat seat0"; then
        data=$(echo "$line" | awk -F [T] '{print $1}')
        ora=$(echo "$line" | awk -F [T.] '{print $2}')
         echo "$data $ora reboot system_boot"
    fi
    if echo "$line" | grep -q "New session .* of user gdm"; then
        data1=$(echo "$line" | awk -F [T] '{print $1}')
        ora1=$(echo "$line" | awk -F [T.] '{print $2}')
        echo "$data1 $ora1 gdm seat0 "
    fi
   
done < "$file"
done