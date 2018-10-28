#python telnet lib
import sys
import telnetlib
import socket
import subprocess
from threading import Thread
from Queue import Queue
ips=[]
from_port=20
to_port=24
number_of_hosts=0
num_threads=4
data_folder='./data/'
list_hosts_file='list_hosts'
####################################################################
# Create list of IP from file 
with open(data_folder+list_hosts_file) as f:
    for line in f:
       line = line.rstrip('\n')
       ips.append(line)
       number_of_hosts+=1
def live_hosts(host, port):
    try:
        t = telnetlib.Telnet (host, port)
        t.close ()
    except socket.error:
        return 1
    return port
queue = Queue()
######################################################################
def pinger(i, q):
    """Pings subnet"""
    while True:
        ip = q.get()
        ret = subprocess.call("ping -c 1 %s" % ip,
                               shell=True,
                               stdout=open('/dev/null', 'w'),
                               stderr=subprocess.STDOUT)
        if ret == 0:
            print "%s\talive" % ip
            f = open(data_folder+ip, 'w')
            for port in range(from_port,to_port):
                if live_hosts(ip, port) != 1:
                   f.write("%s\n" % port)
                   print "%s:%s\tOPEN" % (ip,port)
                else:
                   print "%s:%s\tCLOSED" % (ip,port)
            f.close()
        else:
            print "%s\tdid not respond" % ip
        q.task_done()
#Spawn thread pool
for i in range(num_threads):
    worker = Thread(target=pinger, args=(i, queue))
    #worker.setDaemon(True)
    worker.start()
#Place work in queue
for ip in ips:
    queue.put(ip)
#Wait until worker threads are done to exit 
queue.join(10)