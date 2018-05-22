#!/usr/bin/env bash

sudo service slapd start

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ~/shared/ldap/pw.ldif
sudo ldapadd -x -D "cn=Manager,dc=mongodb,dc=com" -w password -f ~/shared/ldap/Domain.ldif
sudo ldapadd -x -D "cn=Manager,dc=mongodb,dc=com" -w password -f ~/shared/ldap/Users.ldif

python ~/shared/ldapconfig.py add -u adam -p password
