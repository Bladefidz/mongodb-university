# Connection Timeout

In MongoDB cluster there are a few timeouts that can occur:

1. **Timeout Errors**
	* `ServerSelectionTimeoutError`: No MongoDB server is available after connection.
	* `STimeoutError`: When application set `wtimeout` flag in `writeConcern`, and response time not comply `wtimeout` value. For example:
	```
	db.foo.insertOne( { hello: 'world' }, { writeConcern: { w: 3, wtimeout: 1 } } );
	```
	* `ExecutionTimeout`: When cursor specify parameter `$maxTimeMS`, and response result exceed `$maxTimeMS` value. For example:
	```
	var cur = db.friends.find( { email: /eh/ })._addSpecial("$maxTimeMS", 1);
	cur.forEach( function(x){ printjson(x)});
	```
	* `NetworkTimeout`: While a connection, or even an instruction takes longer than the admissible expected time.

## Diagnose

### Write concern with wtimeout

Simulate replica set with timeouts, then execute operations with timeouts:

1. Launch three replica sets with timeouts:
```mlaunch init --name TIMEOUTS --replicaet --nodes 3 --dir timeouts --port 27000```
2. Connect to `mongo`.
3. Execute `insert` command with `writeConcern` and `wtimeout`:
```db.foo.insertOne({hello: 'world'}, {writeCOncern: {w: 3, wtimeout: 1}})```
4. If previous command execution time exceed `wtimeout`, then it will return `WriteConcernError`. For example:
```
WriteConcernError({
	"code": 64,
	"codeName": "WriteConcernFailed",
	"errInfo: {
		"wtimeout": true
	},
	"errmsg": "Waiting for replication timed out"
})
```

Simulate replica set with timeouts, then execute operations with timeouts and *write concern* exceed number of nodes:

1. Launch three replica sets with timeouts:
```mlaunch init --name TIMEOUTS --replicaet --nodes 3 --dir timeouts --port 27000```
2. Connect to `mongo`.
3. Execute `insert` command with `writeConcern` and `wtimeout`:
```db.foo.insertOne({hello: 'world'}, {writeCOncern: {w: 4, wtimeout: 100}})```
4. If previous command execution time exceed `wtimeout`, then it will return `WriteConcernError`. For example:
```
WriteConcernError({
	"code": 100,
	"codeName": "CannotSatisfyWriteConcern",
	"errmsg": "Not enough data-bearing nodes"
})
```

### Query with $maxTimeMS

1. Launch replica set.
2. Execute query with `$maxTimeMS`:
```
var cur = db.friends.find( { email: /eh/ })._addSpecial("$maxTimeMS", 1);
cur.forEach( function(x){ printjson(x)});
```
3. If query execution time exceed `$maxTimeMS`, then it may return `ExceededTimeLimit` error:
```
{
	"ok": 0,
	"errmsg": "operation exceeded time limit",
	"code": 50,
	"codeName": "ExceededTimeLimit"
}
```