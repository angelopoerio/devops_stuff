#!/bin/bash

# A quick & dirty provisioning script to setup a master/slave postgres streaming replication
# Author: Angelo Poerio <angelo.poerio@gmail.com>

install_requirements () {
	yum install -y gcc-c++.x86_64 wget.x86_64 readline-devel.x86_64 zlib-devel.x86_64 
}

setup_sys_env () {
	useradd postgres
        mkdir /data
        chown -R postgres:postgres /data
	mkdir /usr/local/postgres
}

download_and_compile () {
      wget https://ftp.postgresql.org/pub/source/v9.6.1/postgresql-9.6.1.tar.gz -O /tmp/postgresql.tar.gz
      tar -xvzf /tmp/postgresql.tar.gz -C /tmp
      cd /tmp/postgres*
      ./configure --prefix=/usr/local/postgres
      make && make install
      chown -R postgres:postgres /usr/local/postgres 
}

setup_db() {
	sudo -u postgres /usr/local/postgres/bin/initdb -D /data
}

setup_master() {
	sudo -u postgres sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /data/postgresql.conf
	sudo -u postgres sed -i 's/#max_wal_senders = 0/max_wal_senders = 10/g'  /data/postgresql.conf 
        sudo -u postgres sed -i 's/#wal_level = minimal/wal_level = hot_standby/g'  /data/postgresql.conf		
        sudo -u postgres sed -i 's/#hot_standby = off/hot_standby = on/g'  /data/postgresql.conf	
	sudo -u postgres echo "host replication replicator 192.168.33.11/32 md5" >> /data/pg_hba.conf
	sudo -u postgres /usr/local/postgres/bin/pg_ctl -D /data start
	sleep 10
	sudo -u postgres /usr/local/postgres/bin/psql -c "CREATE ROLE replicator WITH REPLICATION PASSWORD 'password' LOGIN;"
}

setup_slave() {
	rm -rf /data 
	mkdir /data	
	chown -R postgres:postgres /data
	sudo -u postgres bash -c 'export PGPASSWORD="password";/usr/local/postgres/bin/pg_basebackup --xlog-method=stream -D /data -U replicator -h 192.168.33.10'
	sudo -u postgres bash -c "cat > /data/recovery.conf <<- _EOF1_
  standby_mode = 'on'
  primary_conninfo = 'host=192.168.33.10 port=5432 user=replicator password=password'
  trigger_file = '/tmp/postgresql.trigger'
_EOF1_
"
	chmod -R 700 /data	
	sudo -u postgres /usr/local/postgres/bin/pg_ctl -D /data start
}

check_if_postgres_present() { # it should check in a better way
	if [ -d /data ]
	then 
		exit 0
	fi
}

check_if_postgres_present
install_requirements
setup_sys_env
download_and_compile
setup_db

case $1 in
	--master)
		setup_master
		;;
	--slave)
		setup_slave
		;;
esac
