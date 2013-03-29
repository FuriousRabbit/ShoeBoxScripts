#!/bin/bash
#########################################################
# This program watches a specified directory for        #
# changes and executes commands when things change.     #       
#							#
# This script relies on inotify-tools.			#
# yum install inotify-tools				#
#							#
# Written by: Robbie Reese                              #
# Changes:                                              # 
# v0.1      - 11/06/2010   - Inital Release             #
#########################################################

_dirwatched="./watchme/"

	while inotifywait -e CREATE,MODIFY,DELETE,MOVED_TO $_dirwatched 
		do
 			echo "Do Stuff Here"
		done
exit 0
