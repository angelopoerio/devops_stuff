# Introduction
A test environment for [iperf](https://iperf.fr/) 

# Usage
* On one of the node run (iperf server):
``` shell
iperf -s
```
* On the other one:
``` shell
iperf -c ip_of_the_iperf_server
```

# Advanced stuff
* You can change the network adapter (NIC) of the VM with the **nic_type** option, as explained [here](https://www.vagrantup.com/docs/virtualbox/networking.html)

# Requirements
- Ansible

# Author
Angelo Poerio <angelo.poerio@gmail.com>
