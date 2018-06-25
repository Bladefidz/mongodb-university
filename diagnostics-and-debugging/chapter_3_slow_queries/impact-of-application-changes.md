# Impact of Application Changes

If you are the MongoDB administrator, then you need to be able to identify the potential impact of client application changes.

## Detect application changes

* Keeping historical monitoring data.
* Watching out for spikes in connections.
* Watching out for spikes in operations/second.
* Spotting long lasting, non-indexed queries.

## Diagnose The Impact of Application Changes

Use **MongoDB Atlas** to view historical monitoring data diagnose all spikes.

Connection spikes may caused by:

* Exhausting connection pools.
* Incorrect connections to production environment.
* Analytical workload and reporting tools.