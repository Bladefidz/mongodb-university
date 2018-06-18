# Server Logs

The log message has form:

```
<timestamp> <severity> <component> [<context>] <message>
```

For example:

```
2014-11-03T18:28:32.450-0500 I NETWORK [initandlisten] waiting for connections on port 27017
```

As default, MongoDB will use severity **I** which stand for *Informational* with verbosity level of 0.

More information, please read [the documentation](https://docs.mongodb.com/manual/reference/log-messages/index.html).