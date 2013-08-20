#!/bin/bash

#########################################################
# Script to update the local mrilab repository located  #
# at /data/mril0/CentOS/6.3. Only run this script from  #
# gtnode-00!						#
# This script is automated through cron on gtnode-00.	#
# Please see /etc/cron.d/mrilabrepo.			#							
#########################################################

_localdir="/data/mril0/CentOS/6.3"

if [ -d $_localdir ]
	then
		cd $_localdir
		reposync .
		createrepo --update .
	else
		exit
	fi
exit $?
