#!/bin/bash
# info collecting script
# show managers and operators
#########################################################                                                                                                   
# This script gathers information about the SGE         #                                                                                                   
# environment and outputs the information.              #                                                                                                   
#    							#                                                                                                   
#   							#                                                                                                   
#                                                       #                                                                                                   
# 			                                #                                                                                                   
#########################################################

# SHOW A LIST OF ALL MANAGERS
qconf -sm
# SHOW A LIST OF ALL OPERATORS
qconf -so
# SHOW THE QUEUE STATUS
qstat -f
# SHOW EXEC SERVERS AND STATUS
for h in $(qconf -sel); do echo "=== $h"; qconf -se $h; done
# SHOW CONFIGS FOR ALL QUEUES
for q in $(qconf -sql); do echo "=== $q"; qconf -sq $q; done
# SHOW ALL SUBMIT HOSTS
qconf -ss
# SHOW COMPLEX ATTRIBUTES
qconf -sc
# SHOW SCHEDULER STATE, CONFIG AND EVENT CLIENT LIST
qconf -sss
qconf -ssconf
qconf -secl
# SHOW USER LISTS AND CONFIGS
for ul in $(qconf -sul); do echo "=== $ul"; qconf -su $ul; done
# SHOW PARALLEL ENVIRONMENTS AND CONFIGS
for pe in $(qconf -spl); do echo "=== $pe"; qconf -sp $pe; done
# SHOW HOSTS LISTS AND MEMBERS
for hl in $(qconf -shgrpl); do echo "=== $hl"; qconf -shgrpl $hl; done 
# SHOW QUOTAS
for q in $(qconf -srqsl); do echo "=== $q"; qconf -srqs $q; done
# SHOW RUNNING JOBS
qstat -u '*'
