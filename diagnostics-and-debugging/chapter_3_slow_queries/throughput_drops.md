# Throughput Drops

If we have very long-running operations, then may we have drop in throughput.

## Possible causes for a drop in throughput

* Long-running queries
	- Collection scans
	- Poorly anchored regex
	- Inefficient index usage
* Index builds
* Write contention

## Diagnose and solve drop in throughput

### Long-running queries

* Read server logs to inspect whatever some useful indexes has been dropped.
* Show the current operation to inspect whatever there is long-running operation: `db.currentOp()`.
* Turn on the profiler in analytic server.
* Use `explain()` query.

### Index builds

* It depends on planning. We can do **rolling index building** if it possible. But, if data freshness is not priority, then we may prefer **background index building**.

### Write contention

WiredTiger uses **copy-on-write approach**, also called as **multiversion concurrency control**:

1. A new version of the document is prepared.
2. During this process only the original document is visible to any applications.
3. Then the update committed by switching a pointer in a single CPU operation.
4. New version of the document will be available.

**Problem**: *Optimistic concurrency protocols* may caused no-lock on write. Or in other words, multiple writers trying to update the same document at the same time, caused the writers don't realize that the other writes are updating the document. The result is, all writers create their own version, then CPU choose arbitrary version caused any other versions will be removed and repeat any other uncommitted writes.

**Diagnose**: Simulate multiple writers 

1. Get the information about current server status:
```var servStat0 = db.serverStatus();```
2. Optional, Execute `mongostat` to show connection statistics:
```mongostat --port 3000 -o "insert,update,delete,command,dirty,used,conn"```
3. Execute [`python write_to_the_same_document.py --port 3000`](write_to_the_same_document.py) to simulate multiple writers run as parallel processes that try to write on the same document.
4. Get the information about new server status:
```var servStat1 = db.serverStatus();```
5. Get number of updates attempted:
```servStat1.opcounters.update - servStat0.opcounters.update```
6. Get number of inserts attempted:
```servStat1.opcounters.insert - servStat0.opcounters.insert```
7. get number of inserts succeeded:
```servStat1.opcounters.inserted - servStat0.opcounters.inserted```
8. Show log information:
```mlogfilter <LOG_PATH> | less```
9. Look for severity level of `WRITE`, then check value of `writeConflicts` and `numYields`.

**Solution**:

1. If there are lot of write conflicts, then try revise the schema. Try to execute `python write_to_the_same_document.py --docPerProcess --port 3000`