#!/bin/bash

tip="$1"
shift

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
{
for file in /var/log/auth.log.4.gz /var/log/auth.log.3.gz /var/log/auth.log.2.gz /var/log/auth.log.1 /var/log/auth.log; do
    if [ ! -f "$file" ]; then
    continue
    fi
zcat -f "$file" | while read -r line; do
    case "$line" in
            *"New seat seat0"*|*"System is rebooting"*|*"System is powering down"*|*"New session"*|*"pam_unix(gdm-password:auth): authentication failure"*)
                data=$(echo "$line" | awk -F 'T' '{print $1}')
                ora=$(echo "$line" | awk -F'[T.]' '{print $2}')
                ;;
            *)
            continue
            ;;
        esac
    if [ "$tip" == "last" ]; then
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
                echo "$data $ora $pers tty2"
                fi
                ;;
            *"System is rebooting"*)
                echo "$data $ora reboot system_boot"
                ;;
            *"System is powering down"*)
                echo "$data $ora shutdown"
                ;;
            *)
                ;;
            esac
    elif [ "$tip" == "lastb" ];then
        case "$line" in
        *"pam_unix(gdm-password:auth): authentication failure"*)
            pers1=$(echo "$line"| awk -F' user=' '{print $2}' | awk '{print $1}')
            echo "$data $ora $pers1 login_failure"
        ;;
        *)
            ;;
        esac
    fi
done
done
}|{

contor=0    		###contorul pentru -n
###procesare date
while read -r DATA ORA REST; do
	timp="$DATA $ORA"
    timp_p="$DATA"

	if [ -n "$s" ]; then       
		[[ "$timp" < "$s" ]] && continue  
	fi
	
	if [ -n "$t" ]; then 
		[[ "$timp" > "$t" ]] && continue
	fi
    if [ -n "$p" ]; then
        [[ "$timp_p" != "$p" ]] && continue
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
done
} | column -t