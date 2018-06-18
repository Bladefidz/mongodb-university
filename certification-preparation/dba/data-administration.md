## Data Administration

- Users in the *admin* and *local* database can perform operations on any database.
- Fast create new user:
	- `db.addUser('root', 'abcd')` -> `{'user': 'root', 'readOnly': false, 'pwd': "1a0f1c3c3aa1d592f490a2addc559383"}`
	- `db.addUser('root', 'abcd', true) -> `{'user': 'root', 'readOnly': true, 'pwd': "1a0f1c3c3aa1d592f490a2addc559383"}`
	- `readOnly` means a user can only read to database.
- Regular way to create new user:
	- `db.createUser({user: 'kirby', pwd: 'password', roles: ['root']})`
- Enabling the security: `mongod --auth`
- Get authenticated:
	- Through mongo session: `db.auth(<user>, <pwd>)`
- Creating index in the background: `db.foo.ensureIndex({<field>: 1}, {'background': true})`
- Creating an index on a replica set:
	- If have relatively small to medium size of collection:
		1. Create index on `primary`.
		2. Wait for `secondaries` to complete replication.
	- If have big collection, may caused all secondaries unavailable for client reads and may fall behind in replication. So:
		1. Shut down a secondary.
		2. Start it up as a standalone node.
		3. Build the index on that server.
		4. Reintroduce the member into the replica set.
		5. Repeat for each secondary.
		6. Step down the primary and follow step 1 to 4.
- Creating an index on a sharded cluster:
	1. Turn off the `balancer`: `sh.stopBalancer()`.
	2. Shut down a secondary.
	3. Start it up as a standalone node.
	4. Build the index on that server.
	5. Reintroduce the member into the replica set.
	6. Repeat for each secondary.
	7. Step down the primary and follow step 2 to 6.
	8. Run `ensureIndex` through the `mongos`.
	9. Turn on the `balancer`.
- Drop indexes:
	- Drop specific index: `db.runCommand({'dropIndexes': 'foo', 'index': 'alphabet'})`
	- Drop all indexes: `db.runCommand({'dropIndexes': 'foo', 'index': '*'})`
- MongoDB may take a while to get all the right data from disk into memory. If your performance constrains require that data be in RAM, it can be disastrous to bring a new server online and then let your application hammer it while it gradually pages in the data it needs. To avoid that, we need to preheating data in one of several techniques:
	- Moving databases into RAM:
		- In UNIX:
		```
		$ for file in /data/db/<ns>.* do dd if=$file of=/dev/null done
		```
	- Moving collections into RAM:
		i. Start new `mongod` with different port or firewall.
		ii. Run `touch` command to touch a collection to load it into memory:
		```
		db.runCommand({'touch': 'logs', 'data': true, 'index': true})
		```
	- Custom-preheating:
		- Load specific index by doing a covered query: `db.users.find({}, {_id: 0, 'friends': 1}).hint({'friends': 1, 'date': 1}).explain()`
		- Load recently updated documents by query on documents limited by dates.
		- Load recently created documents, i.e loads all the documents from the last week:
		```
		> lastWeek = (new Date(year, month, day)).getTime()/1000
		> hexSecs = lastWeek.toString(16)
		> minId = ObjectId(hexSecs+"0000000000000000")
		> db.logs.find({'_id': {'$gt': minId}}).explain()
		```
		- Replay application usage:
			1. Gather read traffic using *diaglog*:
			```
			> db.adminCommand({'diagLogging': 2})
			```
			2. Let `diaglog` record operations in certain time.
			3. Reset `diaglog` to 0:
			```
			> db.adminCommand({'diagLogging': 0})
			```
			4. Startup the new server and execute:
			```
			$ nc hostname 27017 < /data/db/diaglog* | hexdump -c
			```
- Execute heavy operations, such as preheating-data in parallel:
```
> p1 = stratParallelShell('db.find({}, {x:1}).hint({x:1}).explain()' port)
> p2 = stratParallelShell('db.find({}, {y:1}).hint({y:1}).explain()' port)
> p3 = stratParallelShell('db.find({}, {z:1}).hint({z:1}).explain()' port)
```
- 