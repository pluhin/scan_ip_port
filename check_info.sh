#!/bin/sh
# Get ports 
# Script for scan of hosts (line by line IPs ftom file LIST_IP_FILE), ports (from END_PORT to START_PORT). 
# Result will be stored in files named DATA_DIR/IP
DATA_DIR='./data'
LIST_IP_FILE='$DATA_DIR/list_hosts'
while read IP; do
	echo "Host $IP"
	echo "" > $DATA_DIR/$IP.txt
	# Set start and and port #
	END_PORT=80
	START_PORT=20
	##########################
	while [ $START_PORT -le $END_PORT ]
	do
	  	echo "checking: $IP port: $START_PORT"
	  	echo exit | telnet $IP $START_PORT 2>/dev/null | grep "Connected" >> /dev/null
	  	if [ $? -eq 0 ]; then
	  		echo $START_PORT >> $DATA_DIR/$IP
	  	fi
	  	START_PORT=$[$START_PORT+1]
	done
	echo "Result:"
	cat ./data/$IP
	echo "================================================="
done < $LIST_IP_FILE
