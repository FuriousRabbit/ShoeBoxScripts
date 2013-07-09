#!/bin/env python
#########################################################
# Python script to monitor system temperature through   #
# the IPMI interface on supermicro servers. This script #
# relies on ipmitool being installed.                   #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 07/09/2013   - Inital Release             #
#########################################################


import sys
import os
import subprocess
import string

status = { 'OK' : 0 , 'WARNING' : 1, 'CRITICAL' : 2 , 'UNKNOWN' : 3}

if len(sys.argv) == 1:
    print "Useage: supermicro_temp.py <hostname> <username> <password> <warn> <crit>"
else:
    # Get the command line arguments
    host = sys.argv[1]
    user = sys.argv[2]
    password = sys.argv[3]
    warn_limit = int(sys.argv[4])
    crit_limit = int(sys.argv[5])
    # Call ipmi and get the sensor information for the host specified
    p = subprocess.Popen(['/usr/bin/ipmitool', '-H', host, '-U', user, '-P', password, 'sensor'], stdout=subprocess.PIPE)
    result = p.communicate()[0]
    # Create a list containing each line from the sensor information gathered from ipmi
    sum = string.split(result, '\n')
    systempline = sum[2]
    systemp = systempline.split();
    # Convert the temperature to a float and store as an integer
    sysfloat = float(systemp[3])
    sysvalue = 9.0/5.0 * int(sysfloat) + 32
    sysvalue = int(sysvalue)
    # Check if the system temperature is above our limits
    if sysvalue >= crit_limit :
	print 'CRITICAL: Host Temperature is %s'% (sysvalue)
	sys.exit(status['CRITICAL'])
    elif sysvalue >= warn_limit :
	print 'WARNING: Host Temperature is %s'% (sysvalue)
	sys.exit(status['WARNING'])
    else:
	print 'Host Temperature is OK'
	sys.exit(status['OK'])
