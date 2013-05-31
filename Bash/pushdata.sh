#!/bin/bash
#########################################################
# This script simplifies the process of pushing data    #       
# back to our subversion server. This script unlocks    #       
# the files and removes the local copy once the user    #       
# verifies the files have been transferred successfully #       
#                                                       #       
# Written by: Robbie Reese                              #
# Changes:                                              # 
# v0.1      - 05/31/2013   - Inital Release             #
#########################################################

_lockeduser=$(svnadmin lslocks /data/mril/users/common/share | grep "Owner:" | awk -F ": " '{ print $2 }')
_lockedpath=$(svnadmin lslocks /data/mril/users/common/share | grep "Path:")
_currentsvn=$(svn list https://subversion/repos/share | sed 's/\///g')
_subverpath="https://subversion/repos/share"

echo -e
echo -ne "\e[1;37;40mEnter the mrilid to push the data (ex. subject01)\e[0m: "
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
	if [[ $_currentsvn != $_subjectid ]]
        then
                echo -e
                echo -ne "\e[1;31;40mThe mrilid $_subjectid is not valid!\e[0m \n\n"
                exit 1
        elif [ `pwd` != $HOME ]
        then
                echo -e 
                echo -ne "\e[1;31;40mYou must be in your home directory to push data!\e[0m \n"
                echo -ne "\e[0;32;47mType: cd $HOME to move back to your home directory.\e[0m \n\n"
                exit 1
	elif [ ! -d $HOME/$_subjectid ]
	then
		echo -e
                echo -ne "\e[1;31;40m$HOME/$_subjectid doesn't exist!\e[0m \n\n"
		exit 1
        else
		cd $HOME/$_subjectid
	 	_checkdelete=$(svn st | sed '/^!/!d' | wc -l)
			if [ $_checkdelete -gt 0 ]
			then
			svn rm $(svn st | sed '/^!/!d' | awk '{ print $3 }')
			fi
                svn add * 2> /dev/null
		_suretoadd=$(svn st | grep '?' | wc -l)
			if [ $_suretoadd -gt 0 ]
			then
			svn add $(svn st | grep '?' | awk '{ print $2 }')
			fi	
                svn unlock * 2> /dev/null
		svn commit -m "`whoami` submitted changes to $_subjectid on `date +%F`"
                echo -e 
		echo "Please visit: https://subversion/websvn/wsvn/share/$_subjectid" to verify data upload.
                echo -e 
		read -r -p "Verify data transfer, press Y to delete your local copy [Y/n] " _response
		case $_response in
    		[yY][eE][sS]|[yY]) 
		rm -rf $HOME/$_subjectid
        	echo -ne "Local directory $_subjectid removed. \n\n"
        		       	  ;;
    		*)
        	echo -ne "Local directory $_subjectid kept. \n\n"
        			  ;;
			esac
        fi
exit 0
