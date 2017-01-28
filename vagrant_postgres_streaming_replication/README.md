# Intro
A postgres cluster (master/slave) in streaming replication

# Howto
* Boot: vagrant up
If everything is ok you should be able to save data in the master node and see them replicated in the slave one
* SSH in the master or slave node and issue: select * from pg_stat_activity to check the replication status

# Author 
 Angelo Poerio <angelo.poerio@gmail.com>
