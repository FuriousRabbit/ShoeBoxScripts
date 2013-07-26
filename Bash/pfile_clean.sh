#!/bin/bash

_spectrotmp="/tmp/spectrofiles.tmp"
_spectrosrt="/tmp/spectrosorted.tmp"
_pbtctmp="/tmp/pbtcfiles.tmp"
_pbtcsrt="/tmp/pbtcsorted.tmp"
_lxmr1="/data/archive/pfiles/lxmr1"
_lxmr2="/data/archive/pfiles/lxmr2"
_lxmr3="/data/archive/pfiles/lxmr3"

if [ $# = 0 ] ; then 
    echo "Syntax:";
    echo
    echo "pfile_clean.sh <spectro> or <pbtc> or <remove>"
    exit
fi;

#Verify the script is being run from one of the allowed directories
if [ $_lxmr1 != $(pwd) ]
then
   if [ $_lxmr2 != $(pwd) ]
   then
      if [ $_lxmr3 != $(pwd) ]
      then
                echo -ne "\nYou need to be in $_lxmr1, $_lxmr2, or $_lxmr3 to run this script. \n \n"
      fi
   fi
fi
#If the QA and PBTC directories dont exist create them
if [[ ! -d ./QA && ! -d ./PBTC ]]
   then
	mkdir ./QA ./PBTC
fi
#If the $_spectrotmp file exists from previous runs clear it
if [ -f $_spectrotmp ]
   then
        cat /dev/null > $_spectrotmp
fi
#If the $_pbtctmp file exists from previous runs clear it
if [ -f $_pbtctmp ]
   then
        cat /dev/null > $_pbtctmp
fi
#If the $_spectrosrt file exists from previous runs clear it
if [ -f $_pbtcsrt ]
   then
        cat /dev/null > $_pbtcsrt
fi

spectro () {
	echo -ne "\n Searching for duplicate SPECTRO QA files ...\n \n"
	#Search the local directory for the SPECTRO QA files and save the list to a tmp file
	for list in $(find . -type f -name "P*.7" -exec grep -rl "SPECTRO QA" {} +)
	   do
		echo "$list" >> $_spectrotmp
	done
	#Search the created tmp file for duplicates and create a new tmp file with only unique files
	for sortlist in $(cat $_spectrotmp | awk -F "/" '{ print $3 }' | sort -u)
	   do
		grep -m20 "$sortlist" $_spectrotmp | tail -1 >> $_spectrosrt
	done
	#Create directories in QA/ based on the dates found in the $_spectrosrt file
	for directory in $(cat $_spectrosrt | awk -F "/" '{ print $2 }')
	   do 
		mkdir QA/$directory 2>/dev/null
	done
	#Build the script to copy the spectro pfiles to the correct directory
	cd QA
	cat $_spectrosrt | sed 's/^/./' > /tmp/spectro_src.tmp
	cat $_spectrosrt | cut -c 3-13 > /tmp/spectro_dest.tmp
	pr -m -t /tmp/spectro_src.tmp /tmp/spectro_dest.tmp | sed 's/^/cp /' > /tmp/spectro_c.sh
	chmod +x /tmp/spectro_c.sh
	rm /tmp/spectro_src.tmp /tmp/spectro_dest.tmp
	#Execute the script
	/tmp/spectro_c.sh
}

pbtc () {
	echo -ne "\n Searching for duplicate PBTC files ...\n \n"
        #Search the local directory for the PBTC files and save the list to a tmp file
        for list in $(find . -type f -name "P*.7" -exec grep -rl "PBTC" {} +)
           do  
                echo "$list" >> $_pbtctmp
        done
        #Search the created tmp file for duplicates and create a new tmp file with only unique files
        for sortlist in $(cat $_pbtctmp | awk -F "/" '{ print $3 }' | sort -u)
           do  
                grep -m20 "$sortlist" $_pbtctmp | tail -1 >> $_pbtcsrt
        done
        #Create directories in PBTC/ based on the dates found in the $_pbtcsrt file
        for directory in $(cat $_pbtcsrt | awk -F "/" '{ print $2 }')
           do  
                mkdir PBTC/$directory 2>/dev/null
        done
        #Build the script to copy the pbtc pfiles to the correct directory
        cd PBTC
        cat $_pbtcsrt | sed 's/^/./' > /tmp/pbtc_src.tmp
        cat $_pbtcsrt | cut -c 3-13 > /tmp/pbtc_dest.tmp
        pr -m -t /tmp/pbtc_src.tmp /tmp/pbtc_dest.tmp | sed 's/^/cp /' > /tmp/pbtc_c.sh
        chmod +x /tmp/pbtc_c.sh
        rm /tmp/pbtc_src.tmp /tmp/pbtc_dest.tmp
        #Execute the script
        /tmp/pbtc_c.sh
}

remove () {
	echo -ne ""
	read -r -p "WARNING: All folders, except 'QA' and 'PBTC' will be removed!. Are you sure? [Y/n] " _response
	case $_response in
		[yY][eE][sS]|[yY])	 
			rm -rf "$(find . -maxdepth 1 -type d | sed 's/.\///g' | sed 's/\.//g' | grep -v "QA" | grep -v "PBTC" | sed '/^$/d')"
			echo -ne "\nAll directories removed. \n\n"
		;;
				*)
			echo -ne "\nAborted. No changes made. \n\n"
		;;
	esac
}

case "$1" in
	spectro)
		spectro
	;;
	pbtc)
                pbtc
        ;;
	remove)
                remove
        ;;
esac
