#!/bin/bash

for file in /var/log/auth.log.4.gz /var/log/auth.log.3.gz /var/log/auth.log.2.gz /var/log/auth.log.1 /var/log/auth.log; do
    if [ ! -f "$file" ]; then
    continue
    fi
zcat -f "$file" | while read -r line; do
    case "$line" in
        *"New seat seat0"*|*"System is rebooting"*|*"System is powering down"*|*"New session"*)
            data=$(echo "$line" | awk -F 'T' '{print $1}')
            ora=$(echo "$line" | awk -F'[T.]' '{print $2}')
            ;;
        *)
        continue
        ;;
    esac
    case "$line" in
        *"New seat seat0"*)
            echo "$data $ora reboot system_boot"
            ;;
        *"systemd-logind"*New\ session*of\ user\ gdm*)
            echo "$data $ora gdm seat0 login_screen"
            ;;
        *"systemd-logind"*New\ session*of\ user*)
            if [[ "$line" != *"of user gdm"* ]]; then
            pers=$(echo "$line" | awk -F 'of user ' '{print $2}' | tr -d '.')
            echo "$data $ora $pers"
            fi
            ;;
        *"System is rebooting"*)
            echo "$data $ora reboot system_boot"
            ;;
        *"System is powering down"*)
             echo "$data $ora shutdown"
             ;;
        esac
done
done
