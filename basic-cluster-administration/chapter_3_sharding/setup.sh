# Starting the three config servers:
mongod -f csrs_1.conf
mongod -f csrs_2.conf
mongod -f csrs_3.conf

sleep 10

# Connect to one of the config servers
mongo --port 26001 << 'EOF'
// Initiating the CSRS
rs.initiate()

// Creating super user on CSRS
use admin
db.createUser({
  user: "m103-admin",
  pwd: "m103-pass",
  roles: [
    {role: "root", db: "admin"}
  ]
})

// Authenticating as the super user
db.auth("m103-admin", "m103-pass")

// Add the second and third node to the CSRS
rs.add("localhost:26002")
rs.add("localhost:26003")
EOF

# Start mongos
mongos -f mongos.conf

sleep 10

# Fire m103-repl shard servers
mongod -f node_1.conf
mongod -f node_2.conf
mongod -f node_3.conf

sleep 10
echo "Configuring s1 replica set"
mongo --port 27001 << 'EOF'
config = { _id: "m103-repl", members:[
          { _id : 0, host : "localhost:27001" },
          { _id : 1, host : "localhost:27002" },
          { _id : 2, host : "localhost:27003" }]};
rs.initiate(config)
EOF

# Create user authorization in shard server
mongo --port 27001 << 'EOF'
// Creating super user on CSRS
use admin
db.createUser({
  user: "m103-admin",
  pwd: "m103-pass",
  roles: [
    {role: "root", db: "admin"}
  ]
})
EOF

# Initialize shard servers in mongos
mongo --port 26000 -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin" << 'EOF'
// Adding new shard to cluster from mongos:
sh.addShard("m103-repl/localhost:27001")
EOF
