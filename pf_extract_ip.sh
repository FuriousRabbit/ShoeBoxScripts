#!/bin/sh
#Script to extract IP's from a pfctl table 
#Created by: Robbie Reese 10/24/06

#SPECIFY THE PF TABLE NAME
TABLE=kiddies
#SPECIFY THE BLACKLIST DIRECTORY [NO TRAILING "/"]
LOCATION=/var/www/blacklist

#RUN THE SCRIPT
BLACKLIST=$LOCATION/blacklisted
SNAPSHOT=$LOCATION/list.tmp
COMPARE=$LOCATION/tmp.tmp
DIF=$LOCATION/dif.tmp

if [ -f $SNAPSHOT ]; then
	pfctl -t $TABLE -vTshow | awk '{print $1}' | sed 's/Cleared://' | sed 's/In\/Block://' | sed 's/In\/Pass://' | sed 's/Out\/Block://' | sed 's/Out\/Pass://' | sed '/./!d' > $COMPARE
	diff -n $SNAPSHOT $COMPARE | sed -e '/a/d' | sed -e '/d/d' > $DIF
	cat $DIF >> $SNAPSHOT
	sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P' $SNAPSHOT > $BLACKLIST
	rm $COMPARE
	rm $DIF
	cat /dev/null > $SNAPSHOT
else    
	pfctl -t $TABLE -vTshow | awk '{print $1}' | sed 's/Cleared://' | sed 's/In\/Block://' | sed 's/In\/Pass://' | sed 's/Out\/Block://' | sed 's/Out\/Pass://' | sed '/./!d' > $SNAPSHOT
fi
