# Server Status

To view server status, execute this command:

```
db.runCommand( { serverStatus: 1 } )
```
or
```
db.serverStatus()
```

The output of serverStatus() command will be huge. To filter out which data keys should be showed, execute serverStatus() command with filter, for example only show statistical information about `repl`, `metrics`, and `locks`:

```
db.runCommand( { serverStatus: 1, repl: 0, metrics: 0, locks: 0 } )
```

For more information, please read [the documentation](https://docs.mongodb.com/manual/reference/command/serverStatus/index.html).