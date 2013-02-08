#!/bin/bash
#########################################################
# This script cheks to see if a specified service is    #
# running on all computenodes. If it is not running the # 
# script will attempt to start the service.             #
#							#
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 01/08/2013   - Inital Release             #
#########################################################

_cnodes=`bpstat -n | sed 's/^/n/'`
_service="sge_execd"
_exepath="/opt/sge/bin/lx-amd64/sge_execd"

for c in $_cnodes
do
	set -- $c
	_hostname="$1"

	echo "Checking if service $_service is running on $_hostname ..."
	bpsh $_hostname ps -ef | grep -q $_service
		if [ $? -eq 0 ]; then
			sleep 3
			echo "$_service is running on $_hostname"
			sleep 2
		else
			sleep 3
			echo -ne "\e[1;31;40m$_service is not running on $_hostname.\e[0m \n" 
			echo -ne "\e[1;37;40mStarting $_service...\e[0m"
	 		bpsh $_hostname $_exepath
			bpsh $_hostname ps -ef | grep -q $_service
				if [ $? -eq 0 ]; then
                        		sleep 3
                        		echo "$_service started on $_hostname"
                        		sleep 2
				else
					echo "$_service couldn't be started!"
			   	fi	
			sleep 2
		fi	
done
