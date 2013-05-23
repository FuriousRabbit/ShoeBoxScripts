#!/bin/bash

#########################################################
# Script to add a new user to LDAP and create a         #
# directory on the nfs server with custom profile       #
# settings.                                             #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 05/17/2013   - Inital Release             #
#########################################################

_getlastuid=$( ldapsearch -x -b "dc=localdomain,dc=com" -ZZ | grep "uidNumber" | awk -F ":" '{ print $2 }' | sed 's/ //g' | sort -nu | tail -1 )
_getlastgid=$( ldapsearch -x -b "dc=localdomain,dc=com" -ZZ | grep "gidNumber" | awk -F ":" '{ print $2 }' | sed 's/ //g' | sort -nu | tail -1 )
_listalluid=$( ldapsearch -x -b "dc=localdomain,dc=com" -ZZ | grep "uidNumber" | awk -F ":" '{ print $2 }' | sed 's/ //g' | sort -nu )
_listallgid=$( ldapsearch -x -b "dc=localdomain,dc=com" -ZZ | grep "gidNumber" | awk -F ":" '{ print $2 }' | sed 's/ //g' | sort -nu )
_incrlastid=$(( $_getlastuid +1 ))
_checkidexist=$( echo -e "$_listallgid\n$_listalluid" | grep -c $_incrlastid )
_checkifmnt=$( mount | grep -w -c "/data/mril0" )	
	if [ $_checkidexist -eq 1 ]
	then
		echo -e "The uid/gid $_incrlastid exists!"
		exit 1
	else
		echo -n "Enter the users full name (first and last): "
		read -e _fullname
		echo -n "Enter the username: "
		read -e _username
		_checkuserexist=$( ldapsearch -x -b "dc=localdomain,dc=com" -ZZ | grep -w -c "$_username" )
	fi

	if [ $_checkuserexist -gt 0 ]
	then
		echo -e "The username: $_username exists!"
	 	exit 1
	else	
		_buildldapuser=$( echo -e "dn: uid=$_username,ou=People,dc=localdomain,dc=com \nuid: $_username\ngidNumber: $_incrlastid\ncn: $_fullname\nshadowWarning: 7\nloginShell: /bin/bash\ngecos: $_username\nshadowMax: 99999\nhomeDirectory: /home/$_username\nobjectClass: account\nobjectClass: posixAccount\nobjectClass: top\nobjectClass: shadowAccount\nshadowLastChange: 15664\nuidNumber: $_incrlastid\nshadowMin: 0")
			echo -e "$_buildldapuser"
		_buildldapgroup=$( echo -e "dn: cn=$_username,ou=Group,dc=localdomain,dc=com\ngidNumber: $_incrlastid\ncn: $_username\nobjectClass: posixGroup\nobjectClass: top")
			echo
			echo -e "$_buildldapgroup"
			echo -e "$_buildldapuser" > /tmp/$_username.ldif 
			echo -e "$_buildldapgroup" > /tmp/$_username.gldif
			ldapadd -x -D "cn=Manager,dc=localdomain,dc=com" -w password -f /tmp/$_username.ldif
			ldapadd -x -D "cn=Manager,dc=localdomain,dc=com" -w password -f /tmp/$_username.gldif
			rm /tmp/$_username.ldif /tmp/$_username.gldif
	fi

	if [ $_checkifmnt -eq 0 ]
	then
		echo -e "/data/mril0 is not mounted! Can't create home directory!"
		exit 1
	else
		mkdir /data/mril0/home/$_username
		cp /etc/skel/.bash* /data/mril0/home/$_username
		chown -R $_username:$_username /data/mril0/home/$_username
	fi
exit 0
