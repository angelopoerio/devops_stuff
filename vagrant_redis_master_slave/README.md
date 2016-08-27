# Intro
2 redis instances running in master/slave mode running in virtual machines

# Howto
* Boot: vagrant up
If everything is ok you should be able to save data in the master node and see them replicated in the slave one
* SSH in the master node: vagrant ssh master, then use the redis-cli client to save some data
* SSH in the slave node: vagrant ssh node, you should see the replicated data (use the redis-cli client)

# Author 
 Angelo Poerio <angelo.poerio@gmail.com>
