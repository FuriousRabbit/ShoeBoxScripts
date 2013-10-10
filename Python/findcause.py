#!/bin/env python
import yum
import rpm
import os
import sys
import subprocess
import string
import pprint
if len(sys.argv) == 1:
    print "\n\nUsage: findcause.py [logfile] [start_time] [end_time]"
    print "Example: findcause.py /var/log/sa/sa04 10:00:00 14:30:00\n"
else:
    #get the required input
    logfile_path = sys.argv[1]
    start_time = sys.argv[2]
    end_time = sys.argv[3]
    #define the packages we want to make sure are installed
    packagesrereq = ["sysstat", "atop"]
    #function to check if the requried packages are installed
    def check_pkg (pkglist):
        yb = yum.YumBase()
    	missing_packages = set()
    	for package in pkglist:
            res = yb.rpmdb.searchNevra(name=package) 
       	    if not res:
	        missing_packages.add(package)
                print "\n\n" + package, "not installed! Would you like to install it?"
                yn = raw_input("[Y] or [n]: ").lower()
                if yn == "y":
                    yb.install(name=package)
                    yb.resolveDeps()
                    yb.processTransaction()
                elif yn == "n":
                    print "All required packages %s are not installed! Exiting."% (pkglist)
		    sys.exit()
    #call the check_pkg function
    check_pkg(packagesrereq)
    #function to allow different columns from sar to be displayed
    def sar_interface(input):
        x = input
        if x == "cpuidle":
            z = "$9"
        if x == "date":
	    z = "$1"
        cpuidle = "/usr/bin/sar -f %s -s %s -e %s | awk '{ print %s }' | grep -v 'idle' | grep -v 'Average' | grep -v 'Linux'"% (logfile_path, start_time, end_time, z)
        sar = subprocess.Popen(cpuidle,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        output = sar.communicate()[0]
        idle = string.split(output[1:-1], '\n')
        return idle
    #join our date and cpuidle list information together; highlighting the lowest idle
    cpuidle = sar_interface("cpuidle")[1:-1]
    date = sar_interface("date")[1:]
    busy = min(cpuidle)
    for n,i in enumerate(cpuidle):
        if i==busy:
	    cpuidle[n]='\033[93m' + busy + '\033[0m'
    for x,y in zip(date, cpuidle):
     	print '%s      %s'% (x, y) 
