#!/bin/bash
sudo openconnect -b tunnel.company.org
TUNIP=`ip addr | grep tun0 | tail -1 | cut -c 10-23`
sudo route add -net 172.26.12.0 netmask 255.255.255.0 gw $TUNIP
