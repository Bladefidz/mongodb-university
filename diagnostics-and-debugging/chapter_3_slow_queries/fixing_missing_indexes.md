# Fixing Missing Indexes

Building indexes means MongoDB will execute collection scans to collect all data to be indexed. We may want to minimize time required in building indexes.

## Building indexes options

* Build the index on the Primary from the shell.
* Build the index in the background on the Primary from the shell.
* Build the index with **Compass**.
* Build the index on each member of the replica set. Also called as **Rolling Upgrade**.
* Use **Cloud/Ops Manager** to build the index. This is painless and recommended way because we can create automation scripts to automate index building.

## Diagnose

1. Launch three members of replica set:
```mlauch init --replicaset --name m312RS --wiredTigerCacheSizeGB 0.3 --port 3000 --host localhost```
2. Import the sample dataset.
3. Create the indexes in *foreground* or *background*.
4. Use `mlogfilter` to filter the server logs and find index building command.
5. If we prefer trade-off between write and execution time, then we may choose *background* index creation.

## Rolling upgrade

Rolling upgrade is great option if we plan to do system upgrade and also fixing missing indexes. Look for [`rolling_upgrade.js`](rolling_upgrade.js) to show step by step process of shutting down and re-added each replica set members. Then, look for [`rolling_upgrade.sh`](rolling_upgrade.sh) to do rolling upgrades.

We may prefer to use **Cloud/Ops Manager** to do rolling upgrades automatically.