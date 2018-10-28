#script ping
from threading import Thread
import subprocess
from Queue import Queue
#=====================================
number_of_hosts=0
number_of_ports=0
ips=[]
ports=[]

with open('./data/list_hosts') as f:
    for line in f:
    	line = line.rstrip('\n')
        ips.append(line)
        number_of_hosts+=1
	num_threads = number_of_hosts
with open('./data/list_ports') as f:
    for line in f:
    	line = line.rstrip('\n')
        ports.append(line)
        number_of_ports+=1
num_threads = number_of_hosts
queue = Queue()
#wraps system ping command
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
            for port in ports:
                ret_port = subprocess.call("echo exit | telnet %s %s | grep 'Connected'" % (ip, port),
                                      shell=True,
                                      stdout=open('/dev/null', 'w'),
                                      stderr=subprocess.STDOUT)
                if ret_port ==0:
                	print "\t%s:%s\topen" % (ip, port)
                else:
                	print "\t%s:%s\tclosed" % (ip, port)
        else:
            print "%s\tdid not respond" % ip
        q.task_done()
#Spawn thread pool
for i in range(num_threads):
    worker = Thread(target=pinger, args=(i, queue))
    worker.setDaemon(True)
    worker.start()
#Place work in queue
for ip in ips:
    queue.put(ip)
#Wait until worker threads are done to exit    
queue.join()