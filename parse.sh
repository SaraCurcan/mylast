#!/bin/bash

for file in /var/log/auth.log.4.gz /var/log/auth.log.3.gz /var/log/auth.log.2.gz /var/log/auth.log.1 /var/log/auth.log; do
    if [ ! -f "$file" ]; then
    continue
    fi
zcat -f "$file" | while read -r line; do
    if echo "$line" | grep -q "New seat seat0"; then
        data=$(echo "$line" | awk -F [T] '{print $1}')
        ora=$(echo "$line" | awk -F [T.] '{print $2}')
         echo "$data $ora reboot system_boot"
    fi
    if echo "$line" | grep -q "New session .* of user gdm"; then
        data_1=$(echo "$line" | awk -F [T] '{print $1}')
        ora_1=$(echo "$line" | awk -F [T.] '{print $2}')
        echo "$data_1 $ora_1 gdm seat0 login_screen"
    fi
   if echo "$line" | grep -q "systemd-logind.*: New session .* of user .*"; then
        if ! echo "$line" | grep -q "of user gdm"; then
        data_2=$(echo "$line" | awk -F [T] '{print $1}')
        ora_2=$(echo "$line" | awk -F [T.] '{print $2}')
        pers=$(echo "$line" | awk -F 'of user ' '{print $2}' | tr -d '.')
        echo "$data_2 $ora_2 $pers"
        fi
    fi
    if echo "$line" | grep -q "System is rebooting"; then
        data_3=$(echo "$line" | awk -F [T] '{print $1}')
        ora_3=$(echo "$line" | awk -F [T.] '{print $2}')
        echo "$data_3 $ora_3 reboot system_boot"
    fi
    if echo "$line" | grep -q "System is powering down"; then
        data_4=$(echo "$line" | awk -F [T] '{print $1}')
        ora_4=$(echo "$line" | awk -F [T.] '{print $2}')
        echo "$data_4 $ora_4 shutdown"
    fi

done
done 
#1,40 min...