#!/bin/bash
#########################################################
# This script simplifies the process of checking files  #       
# out of our share folder on subversion. Once the data  #       
# is pulled from subversion an exclusive lock is        #       
# applied to the data.                                  #       
#                                                       #       
# Written by: Robbie Reese                              #
# Changes:                                              # 
# v0.1      - 05/31/2013   - Inital Release             #
#########################################################

_lockeduser=$(svnadmin lslocks /data/mril/users/common/share | tail -10 | grep "Owner:" | awk -F ": " '{ print $2 }')
_lockedpath=$(svnadmin lslocks /data/mril/users/common/share | grep "Path:")
_currentsvn=$(svn list https://subversion/repos/share | sed 's/\///g')
_subverpath="https://subversion/repos/share"

echo -e
echo -ne "\e[1;37;40mEnter the mrilid to retrieve the data (ex. subject01)\e[0m: "
	read _subjectid
	if [ -z "$_subjectid" ]
	then
		echo -e
	 	echo -ne "\e[1;31;40mPlease enter a mrilid.\e[0m \n\n"		
		exit 1
	else
		_checklocks=$(svnadmin lslocks /data/mril/users/common/share | grep "Path:" | grep -c $_subjectid)
		_currentsvn=$(svn list https://subversion/repos/share | sed 's/\///g' | grep -w $_subjectid)
	fi
	if [ $_checklocks -gt 0 ]
	then
		echo -e 
		echo -e "The mrilid requested ( $_subjectid ) is currently locked and in use by: $_lockeduser"
		echo -e
		exit 1
	elif [[ $_currentsvn != $_subjectid ]]
	then
		echo -e
		echo -ne "\e[1;31;40mThe mrilid $_subjectid is not valid!\e[0m \n\n"
		exit 1
	elif [ `pwd` != $HOME ]
	then
		echo -e 
		echo -ne "\e[1;31;40mYou must be in your home directory to pull data!\e[0m \n"
		echo -ne "\e[0;32;47mType: cd $HOME to move back to your home directory.\e[0m \n\n"
		exit 1
	else
		svn co $_subverpath/$_subjectid
		svn lock $_subjectid/*
	fi
exit 0
