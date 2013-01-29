#!/bin/bash

#########################################################
# Script to check the status of the RAIDs on the 	# 
# compute nodes and send the report to the admin.	#
# 	                                                #
# 						        #
# 				                        #
#########################################################

RAIDSTATUS=`/usr/bin/bpsh -ap /sbin/mdadm --detail /dev/md0 | egrep "Failed Devices" > /tmp/computenode.tmp`
TMPFILELOC=/tmp/computenode.tmp
	if [ -f $TMPFILELOC ]
		then
			mailx -s "Compute Node Raid Status" jrreese@cnmc.org < $TMPFILELOC
			rm -f $TMPFILELOC
		else
			exit
	fi
exit 0
