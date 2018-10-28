#/bin/bash
#================================
#LIST_PORTS_FILE='./data/list_ports'
LIST_IP_FILE='./data/list_hosts'
TELNET_PATH='/usr/bin/telnet'
DATA_DIR='./data'
#Log file
LOG_FILE="/tmp/$(date +%Y-%m-%d_%H).log"
#State constants
UP=0 #IP or PORT is up
DOWN=1 #IP or PORT is down
#================================
while read IP; do
ping -c 1 $IP >> /dev/null
	if [ $? -eq 0 ]; then 
	  	while read PORT; do
	  		echo exit | $TELNET_PATH $IP $PORT 2>/dev/null | grep "Connected" >> /dev/null
	  		if [ $? -eq 0 ]; then
	  			echo "$IP;$UP;$PORT;$UP" >> $LOG_FILE
	  		else
	  			echo "$IP;$UP;$PORT;$DOWN" >> $LOG_FILE
	  		fi
		done < $DATA_DIR/$IP
		else
        echo "$IP;$DOWN;$PORT;$DOWN" >> $LOG_FILE
	fi
done < $LIST_IP_FILE