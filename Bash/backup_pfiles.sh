#!/bin/bash

#########################################################
# Script to backup files from a scanner to a local      #
# directory.		                                #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 04/17/2013   - Inital Release             #
#########################################################

_pfiles="/data/archive/pfiles"
_directories=$( ls -ad /data/archive/pfiles/lxmr* | xargs -n1 basename )
_datefmt=$( date +%F )

if [ -d $_pfiles ]
   then
	for _scanner in $_directories
	do
	  set -- $_scanner
	  _hostname="$1"
		echo "Backing up pfiles on $_hostname"
		mkdir $_pfiles/$_scanner/$_datefmt
		rsync -az $_hostname:/usr/g/mrraw/P* $_pfiles/$_scanner/$_datefmt/
	done
	
   else
	exit 1
fi
