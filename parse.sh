#!/bin/bash

for file in /var/log/auth.log*; do
while read -r line; do
    if echo "$line" | grep -q "New seat seat0"; then 
        data=$(echo "$line" | awk -F 'T' 'print {$1}')
        ora=$(echo "$line" | awk -F 'T|.' 'print {$1}')
         echo "$data $ora eboot system_boot"
    fi
done < "$file"
done