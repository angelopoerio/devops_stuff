apt-get install -y bird

cat << 'EOF' > /etc/bird/bird.conf
router id 192.168.33.11;

protocol bgp router_2
{
    local as 64513;
    source address 192.168.33.11;
    import all;
    export all;
    multihop 2;
    neighbor 192.168.33.10 as 64512;
}

protocol static
{
    route  192.168.34.0/24 via 192.168.33.11;
}

protocol device
{
    scan time 5;
}

protocol kernel {
	learn;			
	persist;		
	scan time 20;		
	export all;		
}
EOF

service bird restart