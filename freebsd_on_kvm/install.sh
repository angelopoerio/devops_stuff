#!/bin/bash

# A little script to install FreeBSD as guest on kvm hypervisor
# Author: Angelo Poerio <angelo.poerio@gmail.com>

# create the network bridge (not persistent)
ip link add br0 type bridge
ip link set wlan0 master br0 # change as you need (some wifi drivers does not support bridge mode)

virt-install \
-n freebsd10 \
-r 512 \
--vcpus=1 \
--accelerate \
-v \
-c FreeBSD-10.2-RELEASE-amd64-bootonly.iso \
-w bridge:br0 \
--vnc \
--disk path=/var/lib/libvirt/images/freebsd10.img,size=4 
