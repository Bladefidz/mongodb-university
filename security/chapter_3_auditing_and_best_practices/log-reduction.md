# Log Reduction

PII (Personally Identifiable Information) is security policy that ensure all personal data should be encrypted, secured, and restricted. It also means that we need to ensure every sensitive data should not written in the log. One method to satisfy this condition is **log reduction** means all values from sensitive data will redacted before inserting into log file.


## Enable Log Reduction

**Command line**:

```
mongod --redactClientData
```

**Configuration file**:

```
storage:
	dbPath: /data/redaction
systemLog:
	destination: file
	path: /data/redaction.log
security:
	redactClientLogData: true
```

**Session**:

```
db.adminCommand({setParameter: 1, redactClientLogData: 1})
```