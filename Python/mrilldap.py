#!/usr/bin/env python

import ldap,ldif
import sys
import re
import os
import ldap.modlist
import subprocess

# Specify our LDAP information here
_ldapsrv = "ldap://scyld.localdomain"
_ldapcrd = "cn=Manager,dc=localdomain,dc=com"
_ldapsec = "c@tl!m"
_basedn  = "ou=People,dc=localdomain,dc=com"

# Connect to the LDAP server
_conldap = ldap.initialize(_ldapsrv)

# Bind to the LDAP server
_ldapbind = _conldap.simple_bind_s(_ldapcrd, _ldapsec)

# If we connect to the LDAP server print the server and username
if _ldapbind == (97, []):
    print "\nConnected to %s as user %s" % (_ldapsrv, _ldapcrd) 

# Create the MRI Lab User Management Menu
    print (35 * '-')
    print ("   MRILAB USER MANAGEMENT - M E N U")
    print (35 * '-')
    print ("1. Search User")
    print ("2. Create User")
    print (35 * '-')

# Prompt for the user to make a choice 
    _choice = raw_input("Enter your choice [1-2] : ")
    _choice = int(_choice)

# [1]Search - prompt for userinput and setup the filter based on the input
if _choice == 1:
    _searchuser = raw_input("Enter the username: ")
    _searchuser = str(_searchuser)
    _filter = "uid=" + _searchuser 
# Search for the specified username and display the results
    _people = _conldap.search_s(_basedn,ldap.SCOPE_SUBTREE,_filter) 
    _ldif_writer = ldif.LDIFWriter(sys.stdout)
    for dn,entry in _people:
        dn = str(dn)
    for dn,entry in _people:
        _ldif_writer.unparse(dn,entry)
# Disconnect from the ldap server
    _conldap.unbind_s()

# [2]Create a new user
elif _choice == 2:
    subprocess.call([ "/home/robbie/newuser/ldapadd.sh" ])
