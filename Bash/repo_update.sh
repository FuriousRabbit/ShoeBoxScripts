#!/bin/bash

#########################################################
# Script to update a local repository		        #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 01/02/2006   - Inital Release             #
#########################################################

LOCALDIR="/repo/CentOS/6.3"

if [ -d $LOCALDIR ]
	then
		cd $LOCALDIR
		reposync .
		createrepo --update .
	else
		exit
	fi
exit $?
