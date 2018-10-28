#!/bin/sh
#================================
LIST_IP_FILE_LG='./data/list_hosts_LG'
LIST_IP_FILE_BE='./data/list_hosts_BE'
USER_LG=$1
PASSWORD_LG=$2

USER_BEPCUST=$3
PASSWORD_BEPCUST=$4
#Log file
LOG_FILE_BE="/tmp/BE_$3_$(date +%Y-%m-%d_%H_%M_%s).log"
LOG_FILE_LG="/tmp/LG_$1_$(date +%Y-%m-%d_%H_%M_%s).log"
#State constants
UP=0 #IP or PORT is up
DOWN=1 #IP or PORT is down
#================================
# cat $LIST_IP_FILE
##############################################
#
echo "################ LG hosts #####################"
while read IP; do
ping -c 1 $IP >> /dev/null
	if [ $? -eq 0 ]; then 
		#echo "$(date +%Y-%m-%d_%H); $IP; $UP" >> $LOG_FILE 	
		sh check_access.sh $USER_LG $PASSWORD_LG $IP >> $LOG_FILE_LG
	else
        echo "Host $IP  is not reachable" >> $LOG_FILE_LG
        #echo "$(date +%Y-%m-%d_%H); $IP; $DOWN" >> $LOG_FILE
	fi
done < $LIST_IP_FILE_LG
grep "access to host" "$LOG_FILE_LG"
echo "################ BE hosts #####################"

while read IP; do
ping -c 1 $IP >> /dev/null
	if [ $? -eq 0 ]; then 
		#echo "$(date +%Y-%m-%d_%H); $IP; $UP" >> $LOG_FILE 	
		sh check_access.sh $USER_BEPCUST $PASSWORD_BEPCUST $IP >> $LOG_FILE_BE
	else
        echo "Host $IP is not reachable" >> $LOG_FILE_BE
        #echo "$(date +%Y-%m-%d_%H); $IP; $DOWN" >> $LOG_FILE
	fi
done < $LIST_IP_FILE_BE
grep "access to host" "$LOG_FILE_BE"