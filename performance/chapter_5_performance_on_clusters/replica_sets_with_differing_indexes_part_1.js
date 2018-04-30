// after connecting to the first member, initiate the replica set
var conf = {
    "_id": "M201",
    "members": [
      { "_id": 0, "host": "127.0.0.1:27000" },
      { "_id": 1, "host": "127.0.0.1:27001" },
      { "_id": 2, "host": "127.0.0.1:27002", "priority": 0 },
    ]
  };
rs.initiate(conf);

// confirm that the current member is primary, and that one has priority 0
rs.isMaster()