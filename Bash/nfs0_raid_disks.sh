#!/bin/bash

# Get the disks in md3 - md7. These disks are SAS, there are 9 disks per md in a raid 5.
SAS=`for i in {3..7}; do mdadm --detail /dev/md$i | tail -9 | sed -e 's/^.*\(....\)$/\1/'; done`
# Run iostat on the raid 50 
iostat -x -k $SAS 1 
