# Connectivity

By default, MongoDB allowed 65536 max incoming connections.

Connectivity include closing and dropping connections. There are several type of connectivity.


## Greedy Connection Application

Like its name, this connectivity type use greedy technique which allow each node to perform connection with all available servers.
![](picture/greedy-connection.png)
As in the image above, the implications this greedy technique is memory allocation.

### Diagnose

Simulate greedy connectivity using `multiprocessing` and:

1. Run MongoDB server using [connections_singlenode.cfg](connections_singlenode.cfg) configuration file:
```mongod -f connections_singlenode.cfg```
2. Execute `lsof` command to get know current state of `mongod` process:
```lsof -i:27000```
3. Run `mongostat` to monitor connectivity:
```mongostat --port 27000 -o "command,dirty,used,vsize,res,conn,time"```
4. simulate greedy connections with 100 connections:
```python make_lots_of_connections_to_servers.py --port 27000 -n 100```
5. Back to `mongostat` and look for big allocation in `vsize` and `res`. The big allocation on virtual and residence size memory due to facilitate all incoming connections.

### Solutions

* If ratio between expected connections number and real connection numbers that seen in `mongostat` too small. For example, 6000/200, then it may caused by bad configuration. Please look for `net.maxIncomingConnections` value in configuration file.
* If allocated memory being used to facilitate all incoming connections is not reasonable, then we need to inspect system requirements:
	1. Watch memory allocation every 2 seconds:
	```watch -n 2 free -h```
	2. Simulate **mongod** with all reasonable `net.maxIncomingConnections` values.
	3. Figure it out which the best `net.maxIncomingConnections` value regard to the memory allocation.
* Check max *open files* limitation allowed by operating system: ```ulimit -a```. This limitation is the upper bound for all applications to work with files. Increase it if it required, for example increase to 2048 max opened files: `ulimit -n 2048`.
* Check the upper bound of connections allowed by MongoDB: ```db.serverStatus().connections```.


## Election of new primary

When a primary node goes down, then there are times required to allow election process for new primary.

### Diagnose

1. Use `mongostat` with `--discover` option to discover all member in replica set:
```mongostat --discover --port 27000 -o "command,dirty,used,vsize,res,conn,time,repl"```
2. Simulate multi connections:
```python make_lots_of_connections_to_servers.py --port 27000 -n 600 repl CONNS```
3. Get know which primary node:
```mongo --port 27000 --eval 'rs.isMaster().primary'```
4. Step down the primary:
```mongo --port 27000 --eval 'rs.stepDown()'```
5. There were errors occurred that said `NotMasterError: not master and slaveOk=false` exception in python.

### Solutions

* Making client application aware with `NotMasterError` exception by implement `try and catch`.


## Write concerns and timeouts

There are potential concerns with *Write Concern*:
* Impossible for writes to be acknowledged.
* Impossible for writes to be acknowledged *in time*.

### Diagnose

Remember how *majority* vote work. This table maybe useful (arbiter and delayed node are not counted):
Num. of data-bearing | majority |
------------------|----------|
1 | 1 |
2 | 2 |
3 | 2 |
4 | 3 |
5 | 3 |
6 | 4 |
7 | 4 |

Simulate write concern on replica set:

1. Get average of write execution time. For example, execute [time_w_majority_writes.py](time_w_majority_writes.py) with 100 connections and majority write concern:
```python time_w_majority_writes.py -n 100 -w majority```
2. Shutdown a node in replica set.
3. Try to execute operation with write concern. For example, we have one server down and two server up:
```python time_w_majority_writes.py -n 100 -w 3```
or, with `wTimeOut` parameter:
```python time_w_majority_writes.py -n 100 -w 3 --wTimeOut 1000```

### Solutions

* Use *majority* write concern to avoid hang up connections and timeouts.
* Avoid even number replica set members.
* Add an **arbiter** to help voting when network partition occurred.


## Hostnames and cluster configurations

### Diagnose

1. Initiate replica set with different member names:
```
rs.initiate({
    "_id": "M312",
    "members": [
      {"_id": 0, "host": "192.168.15.101"},
      {"_id": 1, "host": "m2.university.mongodb"},
      {"_id": 2, "host": "m3"},
    ]
})
```
2. Connect to unregistered hostname:
```
mongo --host M312/m2
```

### Solutions

* Use DNS names instead of IP address to avoid IP address renew resolution conflicts.
* Register new hostnames in `/etc/hosts`:
```
192.168.15.102 m2 m2.university.mongodb
```
* Using URI patterns to connect from client:
```mongodb://m1,m2/?replicaSet=M312```
So, if `m1` not available, client may still connected through `m2`.