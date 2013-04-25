#!/bin/bash
#########################################################
# This is a script to check the services on a localhost #       
# and report the results to the nagios host passively.  #       
# Cron runs this script every 5 minutes.                #       
#                                                       #       
# This script relies on nagios-plugins-all, nsca client #       
# and mpt-status being installed and configured.        #       
#                                                       #       
# Current checks performed:                             #       
# - Ping                                                #       
# - CPU                                                 #       
# - LSI Raid Status                                     #       
# - HA Cluster Status                                   #       
# - HA LVM Partition Space                              #       
# - [/] Partition Space                                 #       
#                                                       #       
# Written by: Robbie Reese                              #
# Changes:                                              # 
# v0.1      - 04/05/2013   - Inital Release             #
# v0.2      - 04/10/2013   - Added LSI RAID Check       #
#########################################################

#DEFINE PATH TO NAGIOS PLUGINS AND OUR NAGIOS/ICINGA HOST
PLUGINS="/usr/lib64/nagios/plugins"
NAGIOS=172.26.12.17
NSCA="/usr/sbin/send_nsca"

#DEFINE OUR HOSTNAME HERE - MUST MATCH ICINGA HOST DEFINITION
HOST=hanode0

#BEGIN SERVICE CHECKS - SERVICE NAMES MUST MATCH ICINGA SERVICE DESCRIPTIONS
##CHECK ROOT PARTITON
SERVICE_ROOTPART="PARTITION [/]"
CHECK_ROOTPART=$( $PLUGINS/check_disk -w 10% -c 5% -p / )
RT=$?

##CHECK PING
SERVICE_PING="PING"
CHECK_PING=$( $PLUGINS/check_ping -H $HOST -w 3000.0,80% -c 5000.0,100% -p 5 )

##CHECK LSI RAID
SERVICE_RAID="LSI RAID"
RAID_TEXT=$( $PLUGINS/lsi_raid )
CHECK_RAID=$( $PLUGINS/lsi_raid | awk -F ":" '{ print $1 }' )  
	if [[ $CHECK_RAID == "Array OK" ]]
	   then
		RAID_STAT="0"
	   else
		RAID_STAT="2"
	fi

##CHECK CPU PERFORMANCE
SERVICE_CPU="CPU"
CHECK_CPU=$( $PLUGINS/check_cpu_perf 20 10 )

##CHECK SYSTEM LOAD
SERVICE_LOAD="LOAD"
CHECK_LOAD=$( $PLUGINS/check_load -w 19.0,20.0,21.0 -c 22.0,23.0,24.0 )

##CHECK HA CLUSTER
SERVICE_HA="NFS CLUSTER SVC"
HA_TEXT=$( $PLUGINS/check_clustat )
CHECK_HA=$( $PLUGINS/check_clustat | awk -F ":" '{ print $1 }' )
	if [[ $CHECK_HA == "OK" ]]
           then
                HA_STAT="0"
        elif [[ $CHECK_HA == "Warning" ]] 
	   then
                HA_STAT="1"
	elif [[ $CHECK_HA == "Critical" ]]          
           then
                HA_STAT="2"
	else
		HA_STAT="3"
        fi

##CHECK IF HA LVM PARTITION IS MOUNTED AND WHAT HOST IT'S MOUNTED ON
SERVICE_HALVM="HA LVM [/backup]"
CHECK_MOUNT=$( /bin/grep -c "/backup" /proc/mounts )
CHECK_NODE=$( /usr/sbin/clustat | /bin/grep nfs_srv | awk -F " " '{ print $2 }' )
	if [[ $CHECK_MOUNT == 1 ]]
	   then
		HALVM_TEXT=$( $PLUGINS/check_disk -w 10% -c 5% -p /backup )
	   else
		HALVM_TEXT=$( echo -e "/backup is mounted on $CHECK_NODE" )
	fi

#INITIAL HOST UP CHECK
echo -e "$HOST\t$RT\t$CHECK_PING" | $NSCA $NAGIOS >/dev/null

#SEND SERVICE CHECKS TO ICINGA
echo -e "$HOST\t$SERVICE_ROOTPART\t$RT\t$CHECK_ROOTPART" | $NSCA $NAGIOS >/dev/null
echo -e "$HOST\t$SERVICE_PING\t$RT\t$CHECK_PING" | $NSCA $NAGIOS >/dev/null
echo -e "$HOST\t$SERVICE_CPU\t$RT\t$CHECK_CPU" | $NSCA $NAGIOS >/dev/null
echo -e "$HOST\t$SERVICE_LOAD\t$RT\t$CHECK_LOAD" | $NSCA $NAGIOS >/dev/null
echo -e "$HOST\t$SERVICE_RAID\t$RAID_STAT\t$RAID_TEXT" | $NSCA $NAGIOS >/dev/null
echo -e "$HOST\t$SERVICE_HA\t$HA_STAT\t$HA_TEXT" | $NSCA $NAGIOS >/dev/null
echo -e "$HOST\t$SERVICE_HALVM\t$RT\t$HALVM_TEXT" | $NSCA $NAGIOS >/dev/null

exit 0
