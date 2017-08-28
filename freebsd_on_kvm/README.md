# Introduction
A little script to install FreeBSD as guest on the kvm hypervisor

# Howto
* Run the script
``` shell
chmod +x;./install.sh
```
* if everything worked you should have the following output
``` shell
root@angelo-Aspire-E1-531G:~/devops_stuff/freebsd_on_kvm# virsh list --all
 Id    Name                           State
----------------------------------------------------
 4     freebsd10                      running
```
* access the FreeBSD VM:
``` shell
virt-viewer freebsd10
```
* dump the VM configuration:
``` shell
root@angelo-Aspire-E1-531G:~/devops_stuff/freebsd_on_kvm# virsh dumpxml freebsd10
<domain type='kvm' id='4'>
  <name>freebsd10</name>
  <uuid>c0e71ea1-5d67-4c66-fcb6-1e6c1d4ce0b7</uuid>
  <memory unit='KiB'>524288</memory>
  <currentMemory unit='KiB'>524288</currentMemory>
  <vcpu placement='static'>1</vcpu>
  <resource>
    <partition>/machine</partition>
  </resource>
  ...
  (a lot more stuff ...)
```

# Misc
* [Python API usage example for libvirt](https://github.com/wiedi/libvirt/tree/master/examples/python)




