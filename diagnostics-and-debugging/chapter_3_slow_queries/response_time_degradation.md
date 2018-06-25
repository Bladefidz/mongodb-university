# Response Time Degradation

If we plot time as *y* and data size as *x*, then we can easily measure response time. If our plot has linear or polynomial line, then we may have response time degradation.


## The culprits

The causes of response time degradation are:

* Working set exceeding RAM.
* Queries taking longer as the data set grows.
* Growing pool of clients.
* Unbounded array growth.
* Excessive number of indexes.


## Diagnose and solve the culprits


### Working set exceeding RAM

**Diagnose**: Use `mongstat` to show data coming along.For example, execute following command to show *time*, *dirty amount of memory*, *used amount of memory*, *number of insert*, *queue read and write*, and *active read and write*:
```mongostat --port 27001 -o "time=T,dirty=dirty,used=used,insert=Inserts,qrw=qrw,arw=arw"```

**Solve**:

1. Increase cache size by set `cacheSizeGB` in configuration file to higher value.
2. Or, adding more RAM.


### Queries taking longer as the data set grows

**Diagnose**:

1. Set profiling level to debug anything and set threshold:
```db.setProfilingLevel(2, <THRESHOLD>)```
2. Show the all slow operations:
```db.system.profile.find().pretty()```
3. Generate plot:
```mlogvis <LOG_PATH> --no-browser --out <HTML_FILE>```
4. Show the plot:
```open <HTML_FILE>```

**Solve**:

1. Create appropriate indexes to support queries.