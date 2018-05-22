# SCRAM-SHA-1
`SCRAM-SHA-1` is a default authentication method in MongoDB.

## Enabling SCRAM-SHA-1
1. Let create a new user for authentication purpose:
```
mongo
use admin
db.createuser({user: 'kirby', pwd: 'password', roles: ['root']})
exit
```
2. Kill any `mongod` processes if necessary.
3. Create a new mongod configuration file with `authorization` enabled:
```
...
security
	authorization: 'enabled'
...
```
4. Start new `mongod` processes with `authorization` enabled:
```
mongod --config <CONFIG_FILE>
```
5. To be authorized while connecting through `mongo`, we should stored `authorization` data:
```
mongo -u <USERNAME> -p <PASSWORD> --authenticationDatabase <DATABASE_NAME>
```