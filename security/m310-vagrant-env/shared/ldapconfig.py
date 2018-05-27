#!/usr/bin/python

import argparse
import ldap
import ldap.modlist as modlist


ADMIN_USER = "cn=Manager,dc=mongodb,dc=com"
ADMIN_PASS = "password"

def main(args=None):
    args = arg_parser(args)

    if args.command == 'add':
        addUser(args.user, args.password)
    elif args.command == 'passwd':
        changePassword(args.user, args.old_password, args.new_password)


def arg_parser(args):
    parser = argparse.ArgumentParser(description="LDAP configuration tool")

    subparsers = parser.add_subparsers(dest='command')

    parser_add = subparsers.add_parser('add',
                                       help='Add a user to the LDAP directory.')
    parser_add.add_argument('-u', dest='user', required=True)
    parser_add.add_argument('-p', dest='password', required=True)

    parser_add = subparsers.add_parser('passwd',
                                       help='Change the password of a user in the LDAP directory.')
    parser_add.add_argument('-u', dest='user', required=True)
    parser_add.add_argument('-op', dest='old_password', required=True)
    parser_add.add_argument('-np', dest='new_password', required=True)

    return parser.parse_args(args)


def addUser(user, password):
    l = ldap.initialize("ldap://localhost")
    l.simple_bind_s(ADMIN_USER, ADMIN_PASS)

    dn = distinguished_name(user)
    ldif = configUser(user, password)
    l.add_s(dn, ldif)

    l.unbind_s()


def changePassword(user, old_password, new_password):
    l = ldap.initialize("ldap://localhost")
    l.simple_bind_s(ADMIN_USER, ADMIN_PASS)

    dn = distinguished_name(user)
    l.passwd_s(dn, old_password, new_password)

    l.unbind_s()


def distinguished_name(user):
    return 'cn={0},ou=Users,dc=mongodb,dc=com'.format(user)


def configUser(user, password):
    attrs = {}
    attrs['cn'] = [user]
    attrs['sn'] = 'TestUser'
    attrs['objectclass'] = ['person']
    attrs['userPassword'] = password
    return modlist.addModlist(attrs)


if __name__ == "__main__":
    main()
