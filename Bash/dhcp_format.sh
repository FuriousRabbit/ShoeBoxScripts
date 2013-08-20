#!/bin/bash

#########################################################
# Script to get remote nodes ip and mac address. The	#
# script then outputs the information in a format that  #
# can be copied and pasted to a iscdhcp configuration	#
# for static dhcp entries.				#
#							#
# Written by: Robbie Reese 				#
# Changes: 						#
# v0.1 - 03/17/2012 - Inital Release 			#
#########################################################

_tmphostlist="/tmp/hostlist"

#Function to get nodes ip and mac and do some initial formatting
parsehosts() {
for host in gtnode-{00..13}
    do
        echo -ne "host $host {"
        echo -ne "\nhardware ethernet " && ssh $host "ip addr | grep -B 1 "10.54" | head -1 | awk '{ print \$2 }'"
        echo -ne "fixed-address " && ssh $host "ip addr | grep 10.54 | awk '{ print \$2 }' | sed 's/\/16//g'"
        echo -ne "}"
        echo -ne "\n"
done
}

#Create the output for static dhcpd configuration copy and paste
echo -ne "Gathering host statistics and formatting the information ...\n\n"
parsehosts > $_tmphostlist
sed -i 's/\([0-9a-z]$\)\(.*\)/\1;\2/' /tmp/hostlist
sed -i 's/^/        /g' /tmp/hostlist
cat /tmp/hostlist
rm /tmp/hostlist
