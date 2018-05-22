# mtools

**mtools** is a collection of helper scripts to parse, filter, and visualize MongoDB log files (`mongod`, `mongos`). mtools also includes `mlaunch`, a utility to quickly set up complex MongoDB test environtments on a local machine.

**mtools** can be found at [here](https://github.com/rueckstiess/mtools). mtools can also installed directly using `pip`: `pip install mtools`.


The following tools are in the mtools collection:

- mlogfilter
slices log files by time, merges log files, filters slow queries, finds table scans, shortens log lines, filters by other attributes, convert to JSON
- mloginfo
returns info about log file, like start and end time, version, binary, special sections like restarts, connections, distinct view
- mplotqueries
visualize log files with different types of plots (requires matplotlib)
- mlogvis
creates a self-contained HTML file that shows an interactive visualization in a web browser (as an alternative to mplotqueries)
- mlaunch
a script to quickly spin up local test environments, including replica sets and sharded systems (requires pymongo)


## Launch Sharded Cluster

We used `mlaunch` to launch stand alone servers. Below an example to launch a sharded cluster with three shard server, three nodes of replica set for each shard server, and three config servers, also with authentication enabled:

```
mlaunch init --sharded 3 --replicaset --nodes 3 --config 3 --auth
```