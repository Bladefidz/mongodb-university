# Kerberos
**Kerberos** is an industry standard authentication protocol for large client/server systems. Only **MongoDB Enterprise** support authentication using a Kerberos service.

Kerberos called user as principal. A **Kerberos Principal** is a unique identity to which Kerberos can assign tickets, can be `service`, `server`, or `peer`. While, **Kerberos KDC (Key Distributed Center)** is server responsible to validate tickets. Below basic step by step authentication performed by using Kerberos service:

1. Register `Service Principal` for MongoDB inside of `Kerberos KDC`. 
2. `Client` or `Driver` send a client name to `Kerberos KDC`.
3. If client name found in Kerberos record, `Kerberos KDC` will response with Ticket Granting Service (TGS) to request ticket.
4. `Client` send `server information` to TGS.
5. If `server information` found in record Kerberos record, TGS will response with valid ticket. 
6. `Client` use this ticket to authenticate with `server` or `MongoDB`.

For more information, please read [Kerberos documentation](https://docs.mongodb.com/manual/core/authentication-mechanisms-enterprise/#security-auth-kerberos) and [MIT Lecture](https://www.youtube.com/watch?v=bcWxLl8x33c)

## Enabling Kerberos
1. Let start two machines on `m310-vagrant-env` directory that are:
	- **database** is machine that have mongod instances running.
	- **infrastructure** is machine that have Kerberos KDC running.
2. Do `provision` to `infrastructure` machine with Kerberos installation and configuration.
3. Login to `infrastructure` machine.
4. Inspect Kerberos database by using `kadmin.local` to access Kerberos database directly:
```
sudo kadmin.local
```
5. To find list of principals, enter this command:
```
listprincs
```
6. Register new `Service Principal` in Kerberos Database using command `addprinc`:
```
addprinc -randkey mongodb/database.m310.mongodb.university.mongodb.com
```
7. Generate a new `secret key` or `keytab` for new `service principal`, so `service principal` and other `entities` can shared `secret key` to communicate.
```
ktadd -k mongodb.keytab mongodb/database.m310.university.mongodb.com
```
A command above will create a new `keytab` file called as `mongodb.keytab` in the current directory.
8. Close kadmin.local
9. Copy `mongodb.keytab` file from `infrastructure` to `database` machine.
10. Login to `database` machine.
11. Look for `mongodb.keytab` file and export it as variable for handy usage:
```
export KRB5_KTNAME=`pwd`/mongodb.keytab
```
12. Modify `Kerberos`configuration file to fit with system requirement. You can find the configuration file at `/etc/krb5.conf`. Then modify this fields:
```
[libdefaults]
	default_realm = MONGDB.COM
...
[realms]
	MONGDB.COM = {
		kdc = infrastructure.m310.university.mongodb.com
		admin_server = infrastructure.m310.university.mongodb.com
	}
...
```
13. Start a new `mongod` process with `Kerberos` authentication enabled:
```
mongod --auth --setParameter authenticationMechanisms=GSSAPI --dbpath /data/db --logpath /data/db/mongo.log --fork
```
14. Start new `mongo` session.
15. Create a new user to be used to authenticate with `Kerberos`:
```
use $external
db.createUser({user: "kirby@MONGDB.COM", roles: [{role: "userAdminAnyDatabase", db: "admin"}]})
```
16. Close the `mongo` shell.
17. Get authenticate with Kerberos:
```
kinit <PRINCIPAL_NAME>
Password for <PRINCIPAL_NAME>: 
```
18. Start new `mongo` session.
19. Then get to be `authenticated`:
```
use $external
db.auth({mechanism: "GSSAPI", user: "kirby@MONGDB.COM"})
```