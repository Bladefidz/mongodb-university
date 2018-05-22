# Internal Authentication
**Internal Authentication** is a way to authenticate each members of replica sets and sharded clusters. For the **Internal Authentication** of the members, MongoDB can use either keyfile of x.509 certificates. For more information, please read [documentation](https://docs.mongodb.com/manual/core/security-internal-authentication/index.html)


## Enabling Internal Authentication using keyFile
1. Create a new `keyfile`:
```
openssl rand -base64 755 > mongodb-keyfile
```
2. Set the `keyfile` to be read-only:
```
chmod 400 mongodb-keyfile
```
3. Start all replica set members with `--keyFile`  option:
```
mongod --replSet myReplSet --dbpath ./rs1/db --logpath ./rs1/mongod.log --port 27017 --fork --keyF
ile ./mongodb-keyfile
...
```
4. Start a new `mongo` session.
5. Initiate replica set:
```
rs.initiate()
```
6. Create a new user to be authenticated:
```
use admin
db.createUser({user: 'kirby', pwd: 'password', roles: ['root']})
```
7. Authenticate the user:
```
db.auth('Kirby', 'password')
```
8. Add all replica set members
9. Check replica set status by running `rs.status()`


## Enabling Internal Authentication using X.509
1. Check that current MongoDB environment required `TLS` support by looking information provided by command `mongod --version`. If the `mongod --version` return similar to below output:
```
...
OpenSSL version: OpenSSL xxxx xx xxxx xxxx
...
```
Then, you good to go.
2. Prepare all hashed certificates:
```
ca.pem
client.pem
server.pem
3. Inspect issued certificate and authorization server in `client.pem`, use command below to decode `client.pem`:
```
openssl x509 -in client.pem -inform PEM -subject -nameopt RFC2253 -noout
```
4. Start all **preconfigured replica set members**.
5. Connect to `primary` member through `mongo`.
6. Create a user with credential defined in `client.pem`:
```
db.getSiblingDB("$external").runCommand({createUser: "C=US,ST=New York,L=New York City,O=MongoDB,OU=KernelUser,CN=client", roles: [{role: 'root', db: 'admin'}]})
```
*Note* that we used `$external` since all credential meta data stored in external database defined in `server.pem`
7. Kill all `mongod` processes.
8. Start all **preconfigured replica set members** with `ssl` option:
```
mongod --replSet myReplSet --dbpath ./rs1/db --logpath ./rs1/mongod.log --port 27017 --fork --sslMode requireSSL --clusterAuthMode x509 --sslPEMKeyFile client.pem --sslCAFile ca.pem
...
```
9. Connect to `mongo` with `ssl` enable which also automatically enabling `x.509 certificate`:
```
mongo --host database.m310.mongodb.university:27017 --ssl --sslPEMKeyFile m310-certs/client.pem --sslCAFile m310-certs/ca.pem
```
10. To be authenticated, execute this command:
```
db.getSiblingDB("$external").auth({user: "C=US,ST=New York,L=New York City,O=MongoDB,OU=KernelUser,CN=client", mechanism: "MONGODB-X509"})
```