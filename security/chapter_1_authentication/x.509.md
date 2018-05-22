# x.509 Certificate
`x.509 certificate` is authorization method which securer than `SCRAM`. Note that `x.509` required `TLS` support to authenticate `certificate`.

## Enabling x.509 Certificate
1. Check that current MongoDB environment required `TLS` support by looking information provided by command `mongod --version`. If the `mongod --version` return similar to below output:
```
...
OpenSSL version: OpenSSL xxxx xx xxxx xxxx
...
```
Then, you good to go.
2. Provide some `TLS` certificates:
	- **ca.pem** is Certificate Authority (CA) file
	- **client.pem** contains public and private keys
	- **server.pem** is server certificate
3. Activate `mongod` with `x.509` support:
```
mongod --ssl --sslPEMKeyFile client.pem --sslCAFile ca.pem
```
4. To inspect issued certificate and authorization server in `client.pem`, use command below to decode `client.pem`:
```
openssl x509 -in client.pem -inform PEM -subject -nameopt RFC2253 -noout
```
5. Connect to `mongo` with `ssl` enable which also automatically enabling `x.509 certificate`:
```
mongo --ssl --sslPEMKeyFile client.pem --sslCAFile ca.pem
```
6. Create a user with credential defined in `client.pem`:
```
db.getSiblingDB("$external").runCommand({createUser: "C=US,ST=New York,L=New York City,O=MongoDB,OU=KernelUser,CN=client", roles: [{role: 'root', db: 'admin'}]})
```
*Note* that we used `$external` since all credential meta data stored in external database defined in `server.pem`
7. To be authenticated, execute this command:
```
db.getSiblingDB("$external").auth({user: "C=US,ST=New York,L=New York City,O=MongoDB,OU=KernelUser,CN=client", mechanism: "MONGODB-X509"})
```