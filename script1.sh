#!/bin/bash

file_data="intrare.txt" #fisier de intrare


n=0 		#nr de linii de afisat
p=""		#timp specificat
s=""		#timp minim
t=""		#timp maxim

#veirifcarea flagurilor

#veirifcarea flagurilor
while [ $# -gt 0 ]; do
	case "$1" in
	-n) 
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

contor=0    		###contorul pentru -n
###procesare date
while read -r DATA ORA REST; do
	timp="$DATA $ORA"

	if [ -n "$s" ]; then       
		[[ "$timp" < "$s" ]] && continue  
	fi
	
	if [ -n "$t" ]; then 
		[ "$timp" > "$t" ] && continue
	fi
	
	###identificare user, sursa si actiunea (pastrate in variabila REST)
	if echo "$REST" | grep -q "reboot"; then
		USER="reboot"
		SURSA="system_boot"
		ACTIUNE="reboot"	
	elif echo "$REST" | grep -q "shutdown"; then
		USER="shutdown"
		SURSA="-"
		ACTIUNE="shutdown"	
	elif echo "$REST"| grep -q "login_screen"; then
		USER="gdm"
		SURSA="seat0"
		ACTIUNE="login"
	else 
		USER=$(echo "$REST" | awk '{print $1}')
		SURSA=$(echo "$REST" | awk '{print $2}')
		ACTIUNE="login"
	fi
	
	#####afisare
	echo "$USER $SURSA $DATA $ORA $ACTIUNE"
	contor=$((contor + 1))
	###conditia de oprire pt numar maxim de linii -n:
	if [ "$n" -ne 0 ] && [ "$contor" -ge "$n" ]; then
		break
	fi
done < "$file_data"
	
	
	
