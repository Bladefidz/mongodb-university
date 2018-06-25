# Slow queries

To diagnose slow queries, we may use `mtools` commands, such as:

* `mloginfo`: Show quick summary of the query shape.
* `mplotqueries`: Gives a plot to show all the queries over time.
* `mlogvis`: Similar to `mplotqueries`, but will use internet browser.

## Diagnose the server logs

Lets use `mloginfo` and `mplotqueries` to diagnose the server logs. Remember, to filter the logs, we can use `mlogfilter`. 

### mloginfo

`Mloginfo` will show us tabular data.

1. execute `mloginfo`:
```mloginfo --queries --no-progressbar```
2. Look for number of **mean** and **total** execution time of each **count** of **operation**.

### mplotqueries

`Mplotqueries` will show us plot of server log data. We may use *logarihmic scale* to find the query outliers.

1. Execute `mplotqueries`:
```mplotqueries <LOG_PATH>```
2. The example of basic plot:
![molotqueries](diagnostics-and-debugging/chapter_3_slow_queries/mplotqueries.png)
3. Click the dot which you interested, then the detail of corresponding query will be showed in the command line.