#!/bin/bash
#########################################################
# Script to update /etc/dnsmasq.conf with hosts that	#
# are allowed to PXE boot.				#
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 11/02/2012   - Inital Release             #
#########################################################

#Get the variables to add to the dnsmasq.conf file.

	echo -ne "\e[1;37;40mEnter the hostname: \e[0m"
		read -e hostname
	echo -ne "\e[1;37;40mEnter the MAC address: \e[0m"
		read -e macaddress
	echo -ne "\e[1;37;40mEnter the IP address: \e[0m"
		read -e ipaddress

	if [ -f /etc/dnsmasq.conf ]
	   then
		file=/etc/dnsmasq.conf
	   else
		echo -ne "\n\e[1;37;40m/etc/dnsmasq.conf file not found. Exiting. \e[0m\n\n"
		exit 1
	fi
	
#Format the user input so it's readable by dnsmasq. 
#Create check variables.

topline=`echo -ne "#$hostname"`
botline=`echo -ne "dhcp-host=$macaddress,$ipaddress"`
newline=$'\n'
chk1=`grep -Fx "#$hostname" $file`
chk2=`grep $macaddress $file | cut -c 11-27`

#Add the user supplied information to /etc/dnsmasq.conf

	if [[ $chk1 == $topline ]];
	   then
		echo -ne "\n\e[1;37;40mHost already exists in /etc/dnsmasq.conf\e[0m\n"
		echo -ne "\e[1;37;40m/etc/dnsmasq.conf has not been updated. Exiting.\e[0m\n\n"
		exit 1
        elif [[ $chk2 == $macaddress ]];
	   then
		echo -ne "\n\e[1;37;40mMAC Address already exists in /etc/dnsmasq.conf\e[0m\n"
		echo -ne "\e[1;37;40m/etc/dnsmasq.conf has not been updated. Exiting.\e[0m\n\n"
		exit 1
	   else
		sed -i "152i$topline" $file
		sed -i "153i$botline\\${newline}" $file
		echo -ne "\n\e[1;37;40m/etc/dnsmasq.conf successfully updated.\e[0m\n"
		echo -ne "\e[1;37;40mRestarting dnsmasq\e[0m\n\n"
		/etc/init.d/dnsmasq restart
	fi
