# Auditing

Auditing enable administrators and users to track user activity for deployments with multiple users and applications.

For more information, pleas read [Auditing documentation](https://docs.mongodb.com/manual/core/auditing/index.html)


## Audit Output Format

Here is the output format from auditing operation:

```
{
	atype: <String>,
	ts: {
		"$date": <timestamp>
	},
	local: {
		ip: <String>,
		port: <int>
	},
	remote: {
		ip: <String>,
		port: <int>
	},
	users: [
		{
			user: <String>,
			db: <String>
		}
	],
	roles: [
		{
			role: <String>,
			db: <String>
		}
	],
	param: <document>,
	result: <int>
}
```

The description for each keys described below:

* **atype**: Acronym of `action type` represent what kind of action currently logged.
* **ts**: Acronym of `time stamp` represent when action occurred. Saved as UTC time in ISO 8601 format.
* **local**: Represent local connection of running instance (mongos or mongod).
* **remote**: Represent remote connection from client.
* **users**: Contains session data of who executed the command. May contains more than one document, since a user can authenticate as different user when execute particular command.
* **roles**: Contains information of associated roles of current user.
* **param**: Contains details of event.
* **result**: Contains `Error Code`.

For more information, please read [Audit Message documentation](https://docs.mongodb.com/manual/reference/audit-message).


## Enable and Configure Audit

MongoDB will write audit data to one of following output type: `console`, `syslog`, `JSON`, and `BSON`. In command line, use `--auditDestination` option to specify where to output audit events. Below list of audit configuration through command line and configuration file:

### Output to syslog

**Command line**:

```
mongod --dbpath data/db --auditDestination syslog
```

**Configuration file**:

```
storage:
   dbPath: data/db
auditLog:
   destination: syslog
```


### Output to Console

**Command line**:

```
mongod --dbpath data/db --auditDestination console
```

**Configuration file**:

```
storage:
   dbPath: data/db
auditLog:
   destination: console
```


### Output to JSON file

**Command line**:

```
mongod --dbpath data/db --auditDestination file --auditFormat JSON --auditPath data/db/auditLog.json
```

**Configuration file**:

```
storage:
   dbPath: data/db
auditLog:
   destination: file
   format: JSON
   path: data/db/auditLog.json
```


### Output to BSON file

**Command line**:

```
mongod --dbpath data/db --auditDestination file --auditFormat BSON --auditPath data/db/auditLog.bson
```

**Configuration file**:

```
storage:
   dbPath: data/db
auditLog:
   destination: file
   format: BSON
   path: data/db/auditLog.bson
```

Compile BSON output into JSON format:

```
bsondump data/db/auditLog.bson
```


For more information, please read [configure auditing documentation](https://docs.mongodb.com/manual/tutorial/configure-auditing/).


## Audit Event

The auditing system can record the following operations:

* Schema (Data Definition Language - DDL): Although, MongoDB is schemaless database, it support some DDL command. Here some DDL command supported by MongoDB:

	- `createCollection`
	- `createDatabase`
	- `createIndex`
	- `renameCollection`
	- `dropCollection`
	- `dropDatabase`
	- `dropIndex`

* Replica set and sharded cluster.
* Authentication and authorization.
* CRUD operations.


## Audit Filter

Auditing may reduce performance, the CRUD operations for example, each read and write from users trigger background write for auditing purpose. This is main reason we need to `filter` which any operations need to be audit.


### Filter format

Auditing filter format takes a string representation of a query document of the form:

```
{ <field>: <expression>, ... }
```

- The `<field>` is any field defined in audit output format.
- The `<expression>` is a query condition expression.


#### Command line

Use `--auditFilter` option to set auditing actions. For example:

```
mongod --dbpath data/db --auditDestination file --auditFilter '{ atype: { $in: [ "createCollection", "dropCollection" ] } }' --auditFormat BSON --auditPath data/db/auditLog.bson
```


#### Configuration file

Use `filter` field to specify auditing actions. For example:

```
storage:
   dbPath: data/db
auditLog:
   destination: file
   format: BSON
   path: data/db/auditLog.bson
   filter: '{ atype: { $in: [ "createCollection", "dropCollection" ] } }'
```


Filter `expression` also accept `regex` as input. For example: `{atype: "createIndex", "param.ns": /^my-application\./}`.

To capture read and write operations in the audit, you must also enable the audit system to log authorization successes using the `auditAuthorizationSuccess` parameter.

For more information, please read [audit filter documentation](https://docs.mongodb.com/manual/tutorial/configure-audit-filters/#audit-filter).