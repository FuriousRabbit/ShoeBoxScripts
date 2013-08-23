#!/bin/bash

_iptablefile="/etc/sysconfig/iptables"
_check_for_line1=$( grep -c "FORWARD 15" $_iptablefile )
_check_for_line2=$( grep -c "FORWARD 16" $_iptablefile )

OPTS=`getopt -o n:d:x: --long node:,destination:,remove: -- "$@"`
eval set -- "$OPTS"

while true
do
  case "$1" in
    -n|--node)
      node="$2"
      shift 2
      ;;
    -d|--destination)
      destination="$2"
      shift 2
      ;;
    -x|--remove)
      sed -i '/Temporary access defined below/d' $_iptablefile
      sed -i '/FORWARD 15/d' $_iptablefile
      sed -i '/FORWARD 16/d' $_iptablefile
      service iptables restart
      shift 2
      exit 1
      ;;
     --)
      shift
      break
      exit 1
      ;;
  esac
done

if [[ -z "$node" || -z "$destination" ]]
    then
	 echo -ne "\nUsage:\nAllowAccess.sh -n <node ip allowed access> -d <destination ip block> -x remove\n\n"
    elif [[ $_check_for_line1 -gt 0 && $_check_for_line2 -gt 0 ]]
	 then
	 echo -ne "\nAccess is already set. Remove the access lines in iptables lines 37-39.\n\n"
	 exit 1
   else
         sed -i "37i#Temporary access defined below, google access must be allowed" $_iptablefile
         sed -i "38i-I FORWARD 15 -o eth1 -s $node -d 74.125.0.0/16 -m state --state NEW,ESTABLISHED -j ACCEPT" $_iptablefile
         sed -i "39i-I FORWARD 16 -o eth1 -s $node -d $destination -m state --state NEW,ESTABLISHED -j ACCEPT" $_iptablefile
	 service iptables restart
fi
