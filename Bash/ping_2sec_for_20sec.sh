#!/bin/bash

#########################################################
# Simple script to ping 3 hosts for 20 seconds with 2   #
# second breaks between the pings.                      #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 07/02/2004   - Inital Release             #
#########################################################

SECONDS=0

	while [[ SECONDS -lt 20 ]];
	      do
		for host in nfs0 nfs1 nfs2; do ping -c 1 $host | head -2; done
	sleep 2
	done

