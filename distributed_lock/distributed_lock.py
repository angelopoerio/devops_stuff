import etcd
import sys
from time import sleep
from optparse import OptionParser
from random import randint

parser = OptionParser()
parser.add_option("-e","--etcd",dest="etcd_host",help="etcd hostname")
parser.add_option("-p","--port",dest="etcd_port",help="etcd port")
parser.add_option("-l","--lock",dest="lock_name",help="lock's key", default="lock_test")
parser.add_option("-c","--client",dest="client",help="client's name",default="dist_lock_{0}".format(randint(1,1000)))

def acquire_lock(client, lock_name, client_name):
    print "({0}) Trying to acquire the lock {1} ...".format(client_name, lock_name)
    lock = etcd.Lock(client, lock_name)
    lock.acquire(lock_ttl=60) # TTL to avoid permanent deadlock in case of not graceful exit
    print "({0}) lock {1} acquired".format(client_name,lock_name)
    print "({0}) sleeping a bit ...".format(client_name)
    sleep(randint(5,10))
    print "({0}) releasing the lock {1}".format(client_name, lock_name)
    lock.release()

if __name__ == "__main__":
    (opts, args) = parser.parse_args()
    if opts.etcd_host is None or opts.etcd_port is None:
        print "etcd hostname and port are mandatory!"
        sys.exit(1)

    client=etcd.Client(host=opts.etcd_host,port=int(opts.etcd_port))

    while True:
        acquire_lock(client, opts.lock_name, opts.client)
