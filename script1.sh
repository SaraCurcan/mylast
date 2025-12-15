#!/bin/bash

file_data="file" #fisier de intrare

n=0 		#nr de linii de afisat
p=""		#timp specificat
s=""		#timp minim
t=""		#timp maxim


#veirifcarea flagurilor
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


login_sursa=()		###retine sursa(tty, seat0 etc)
login_time=() 		###retine data si ora de login pt fiecare user

contor=0    		###contorul pentru -n
while read -r DATA ORA ACTIUNE USER SURSA; do
	timp="$DATA-$ORA"
	if [ -n "$s" ]; then       
		[["$timp" < "$s"]] && continue  
	fi
	
	if [ -n "$t" ]; then 
		["$timp" > "$t"] && continue
	fi
	
	date_user="$USER-$SURSA"     ###datele sunt pastrate pentru fiecare sesiune(login_time sau login_sursa)
	
	if ["$actiune" = "login"]; then 
		login_time[$date_user]="$timp"
		login_sursa[$date_user]="$SURSA"
	fi
	
	contor=$((contor+1))	
	if [ "$n" -ne 0 ] && [ "$contor" -ge "$n" ];then
		break;
	fi
done < "nume_fisier"
	
	
	
