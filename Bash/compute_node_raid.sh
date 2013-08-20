#!/bin/bash

#########################################################
# Script to check the status of the RAIDs on the 	# 
# compute nodes and send the report to the admin.	#
# 	                                                #
# 						        #
# 				                        #
#########################################################

_raidstatus=`/usr/bin/bpsh -ap /sbin/mdadm --detail /dev/md0 | egrep "Failed Devices" > /tmp/computenode.tmp`
_tmpfileloc=/tmp/computenode.tmp
	if [ -f $_tmpfileloc ]
		then
			mailx -s "Compute Node Raid Status" email@myorg.com < $_tmpfileloc
			rm -f $_tmpfileloc
		else
			exit
	fi
exit 0
