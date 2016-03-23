#!/bin/bash
nslookup dnsnametoresolve > /tmp/ip.txt
ip=$(sed -n '6p' /tmp/ip.txt)
ip=$(echo ${ip#*:})
iptables --flush
iptables -A INPUT -s $ip/32 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s $ip/32 -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -s $ip/32 -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -s $ip/32 -p tcp -m tcp --dport 443 -j ACCEPT
iptables -P INPUT DROP
/etc/init.d/iptables-persistent save
/etc/init.d/iptables-persistent reload
#service iptables save
#service iptables restart
