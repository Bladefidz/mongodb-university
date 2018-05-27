# Encryption At Rest
There are two ways how to to implement encryption at rest:
	1. Application level encryption: The way you create your own encryption algorithm and stored the encrypted data into MongoDB.
	2. Storage level encryption: Used MongoDB enterprise native encryption option for the WiredTiger storage engine.
For more information, read [Encryption at rest documentation](https://docs.mongodb.com/manual/core/security-encryption-at-rest/index.html)

## Key management via keyfile
1. Create a `keyfile` to be used as `master key`:
```
openssl rand -base64 32 > mongodb-keyfile
```
2. Modify `keyfile` permission:
```
chmod 600 mongodb-keyfile
```
3. Enable MongoDB to used native encryption with keyfile:
```
mongod --enableEncryption --encryptionKeyFile mongodb-keyfile
```

## Key management via KMIP
1. Start and log in to `infrastructure` machine.
2. Install `PyKMIP`:
```
sudo pip install PyKMIP
```
3. Execute `PyKMIP` server code:
```
python pykmip_server.py
```
4. Start and log in to `database` machine.
5. Start `mongod` with encryption turn on using `KMIP`:
```
```
mongod --enableEncryption --kmipServerName localhost --kmipServerCAFile ca.pem --kmipClientCertificateFile client.pem
```
