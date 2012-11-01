#!/bin/bash

#########################################################
# Simple script to update the localrepo			#
#########################################################

LOCALDIR="/data/repo/CentOS/6.3"

if [ -d $LOCALDIR ]
	then
		cd $LOCALDIR
		reposync .
		createrepo --update .
	else
		exit
	fi
exit $?
