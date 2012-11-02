#!/bin/bash
#########################################################
# Script to verify the backup and transfer of a tar.gz  #
# file.				                        #
#                                                       #
# Written by: Robbie Reese                              #
# Changes:                                              #
# v0.1      - 07/02/2004   - Inital Release             #
#########################################################

#Script to verify the backup and 
#transfer of a tar.gz file.

#Check the md5sum of the remote file.
ssh 8.8.8.8 'md5sum < /backup/informix-bkups/informix-db.tar.gz' > ~/REMOTE_INFX_CHECK/remote-infx-md5suma
#Check the md5sum of the local file.
md5sum < /backup/informix-upload/informix-db.tar.gz > ~/REMOTE_INFX_CHECK/local-infx-md5sum
#Compare the two md5sums.
diff --brief <(sort /root/REMOTE_INFX_CHECK/local-infx-md5sum) <(sort /root/REMOTE_INFX_CHECK/remote-infx-md5sum) >/dev/null
comp_value=$?

#If the two md5sums do not match notify the sysadmin via email.
if [ $comp_value -eq 1 ]
then
    echo "The local and remote informix backups are not identical!" > /root/REMOTE_INFX_CHECK/informix.error.chck
    echo "" >> /root/REMOTE_INFX_CHECK/informix.error.chck
    echo "The local MD5SUM is:" >> /root/REMOTE_INFX_CHECK/informix.error.chck
    cat /root/REMOTE_INFX_CHECK/local-infx-md5sum >> /root/REMOTE_INFX_CHECK/informix.error.chck
    echo "" >> /root/REMOTE_INFX_CHECK/informix.error.chck
    echo "The remote MD5SUM is:" >> /root/REMOTE_INFX_CHECK/informix.error.chck
    cat /root/REMOTE_INFX_CHECK/remote-infx-md5sum >> /root/REMOTE_INFX_CHECK/informix.error.chck
    echo "" >> /root/REMOTE_INFX_CHECK/informix.error.chck
    echo "An error log can be viewed on the backup server (192.168.4.10) /root/REMOTE_INFX_CHECK/informix.checksums" >> /root/REMOTE_INFX_CHECK/informix.error.chck
    echo `date` "- The Local & Remote MD5SUMS DO NOT Match. - FAIL" >> /root/REMOTE_INFX_CHECK/informix.checksums
    /bin/mailx -s "!!REMOTE INFORMIX DOESN'T MATCH LOCAL INFORMIX!!" me@mail.com < /root/REMOTE_INFX_CHECK/informix.error.chck
#If the two md5sums match log the date of the match.
else
    echo `date` "- The Local & Remote MD5SUMS Match." >> /root/REMOTE_INFX_CHECK/informix.checksums
fi

