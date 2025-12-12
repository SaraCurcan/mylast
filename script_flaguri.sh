#!/bin/bash

n=0
p=0
s=0
t=0

while [ $# -gt 0 ]; do
	case "$1" in
	-)n 
		n="$2"
	 	shift 2
	;; 
	-s)
		s="$2"
		shift 2
	;;
	-t)
		t="$2"
		shift 2
	;;
	-p)
		p="$2"
		shift 2
	;;
	*)
		shift
	;;
	esac
done

date_user=()

login_keys=()
login_timp=()
while read line; do
	date_time=$(echo "$linie" | awk '{print $1" "$2}')
	activity=$(echo "$linie" | awk '{print $3}')
	user=$(echo "$linie" | awk '{print $4}')
	src=$(echo "$linie" | awk '{print $5}')
	
	key="${user}_${src}"
	
	if [ "$activivity" = "login" ]; then 
		keys=$keys+ "$key"
		valori=$valori+ "$date_time"
	fi 
	
	if [ "$activivity" = "logout" ]; then 
		index=0
