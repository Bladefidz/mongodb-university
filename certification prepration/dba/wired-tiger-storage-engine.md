## Wired Tiger Storage Engine

- WiredTiger uses **document-level concurrency control** for write operations. So, multiple clients can modify different documents of a collection at the same time.
- WiredTiger uses **optimistic concurrency control** for most read and write operations.
- **Instance-wide lock** for some global operations, typically short lived operations.
- **Exclusive-wide lock** for administrative operations, such as drop database or collection.


### Snapshots and Checkpoints

- WiredTiger uses **MultiVersion Concurrency Control (MVCC)**.
- A **snapshot** present a consistent view of the in-memory data.
- The now-durable data act as a **checkpoint** in the data files. The checkpoint ensures that the data files are consistent up to and including the last checkpoint; i.e. checkpoint can act as recovery points
- MongoDB can recover from the last checkpoint even without journaling.
- WiredTiger create checkpoints (i.e. write the snapshot data to disk) at intervals of 60 seconds.


### Journal

- WiredTiger uses a **write-ahead transaction log** in combination with checkpoint to ensure data durability.
- WiredTiger journal is compressed using the snappy compression library.


### Memory Use

- MongoDB utilize both the WiredTiger internal cache and the file system cache.
- Minimum memory usage of WiredTiger internal cache:
	- 50% of RAM to 1 GB, or
	- 256 MB
- WiredTiger internal cache have a different data representation to the on-disk format.
- File system cache used same data representation as the on-disk format. The file system cache us used by the operating system to reduce disk I/O.
- Via the file system cache, MongoDB automatically uses all free memory that is not used by the WiredTiger cache or by other processes.
- To adjust the size of the WiredTiger internal cache, see [storage.wiredTiger.engineConfig.cacheSizeGB](https://docs.mongodb.com/manual/reference/configuration-options/#storage.wiredTiger.engineConfig.cacheSizeGB) and [--wiredTigerCacheSizeGB](https://docs.mongodb.com/manual/reference/program/mongod/#cmdoption-mongod-wiredtigercachesizegb).