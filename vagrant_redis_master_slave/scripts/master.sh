#!/bin/bash

if [ -z $(which redis-server) ] # check if already installed
then
	wget http://download.redis.io/releases/redis-3.2.3.tar.gz
	tar -xvzf redis-3.2.3.tar.gz
	cd redis-3.2.3
	./configure 
	make
	make install
fi

if [ -z $(pidof redis-server) ]
then
	redis-server --daemonize yes --protected-mode no --bind 0.0.0.0
fi
