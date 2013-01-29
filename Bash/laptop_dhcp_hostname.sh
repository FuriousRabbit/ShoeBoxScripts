#!/bin/bash

IP=`ip addr | grep "inet 10.0" | cut -c 1-18 | sed 's/    inet //'`
echo "$IP	mylaptop01" >> /etc/hosts

