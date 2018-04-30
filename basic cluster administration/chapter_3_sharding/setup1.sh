# Adding secondary shard

# Create secondary shard directories
mkdir -p /var/mongodb/db/{4,5,6}

sleep 3

# Start secondary shard servers
mongod -f node_4.conf
mongod -f node_5.conf
mongod -f node_6.conf

sleep 10

echo "Configuring s1 replica set"
mongo --port 27004 << 'EOF'
config = { _id: "m103-repl-2", members:[
          { _id : 0, host : "localhost:27004" },
          { _id : 1, host : "localhost:27005" },
          { _id : 2, host : "localhost:27006" }]};
rs.initiate(config)
EOF

# Create user authorization in shard server
mongo --port 27004 << 'EOF'
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

sleep 10

# Add second shard
mongo --port 26000 -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin" << 'EOF'
sh.addShard("m103-repl-2/localhost:27004")
EOF
