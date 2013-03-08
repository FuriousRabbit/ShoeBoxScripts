#!/bin/bash

#########################################################
# Script to set a nodes local hostname based on the     #
# IP address assigned to it.                            #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 01/02/2012   - Inital Release             #
#########################################################

_getip=$(ip addr | grep eth0 | tail -1 | cut -c 10-19)
_nodeip=(10.20.0.10 10.20.0.11 10.20.0.12 10.20.0.13 10.20.0.14)
_nodehn=(compute0.localdomain compute1.localdomain compute2.localdomain compute3.localdomain compute4.localdomain)

if [ "$_getip" == ${_nodeip[0]} ]
        then
                hostname ${_nodehn[0]}
        elif [ "$_getip" == ${_nodeip[1]} ]
        then
                hostname ${_nodehn[1]}
        elif [ "$_getip" == ${_nodeip[2]} ]
        then
                hostname ${_nodehn[2]}
        elif [ "$_getip" == ${_nodeip[3]} ]
        then
                hostname ${_nodehn[3]}
        elif [ "$_getip" == ${_nodeip[4]} ]
        then
                hostname ${_nodehn[4]}
fi
