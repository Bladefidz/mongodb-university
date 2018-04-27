# For this week's homework we will start with a standalone MongoDB
# database, turn it into a sharded cluster with two shards, and
# shard one of the collections. We will create a "dev" environment
# on our local box: no replica sets, and only one config server. In
# production you would almost always use three config servers and
# replica sets as part of a sharded cluster. In the final of the
# course we'll set up a larger cluster with replica sets and three
# config servers.

# clean everything up
echo "killing mongod and mongos"
killall mongod
killall mongos
echo "removing data files"
rm -rf /var/lib/mongo/config
rm -rf /var/lib/mongo/shard*
rm -rf /var/log/mongodb/*

# Init shard 0 servers
echo "starting servers for shard 0"
mkdir -p /var/lib/mongo/shard0/{rs0,rs1,rs2}
mongod --port 27001 --replSet s0 --logpath /var/log/mongodb/s0-r0.log --dbpath /var/lib/mongo/shard0/rs0 --shardsvr --fork
mongod --port 27002 --replSet s0 --logpath /var/log/mongodb/s0-r1.log --dbpath /var/lib/mongo/shard0/rs1 --shardsvr --fork
mongod --port 27003 --replSet s0 --logpath /var/log/mongodb/s0-r2.log --dbpath /var/lib/mongo/shard0/rs2 --shardsvr --fork

sleep 5
# connect to one server and initiate the set
echo "Configuring s0 replica set"
mongo --port 27001 << 'EOF'
config = { _id: "s0", members:[
          { _id : 0, host : "localhost:27001" },
          { _id : 1, host : "localhost:27002" },
          { _id : 2, host : "localhost:27003" }]};
rs.initiate(config)
EOF

# Init shard 1 servers
echo "starting servers for shard 1"
mkdir -p /var/lib/mongo/shard1/{rs0,rs1,rs2}
mongod --port 27011 --replSet s1 --logpath /var/log/mongodb/s1-r0.log --dbpath /var/lib/mongo/shard1/rs0 --shardsvr --fork
mongod --port 27012 --replSet s1 --logpath /var/log/mongodb/s1-r1.log --dbpath /var/lib/mongo/shard1/rs1 --shardsvr --fork
mongod --port 27013 --replSet s1 --logpath /var/log/mongodb/s1-r2.log --dbpath /var/lib/mongo/shard1/rs2 --shardsvr --fork

sleep 5
echo "Configuring s1 replica set"
mongo --port 27011 << 'EOF'
config = { _id: "s1", members:[
          { _id : 0, host : "localhost:27011" },
          { _id : 1, host : "localhost:27012" },
          { _id : 2, host : "localhost:27013" }]};
rs.initiate(config)
EOF

# Init one single config server usingd default port 27019
echo "Starting config servers"
mkdir -p /var/lib/mongo/config/config-a
mongod --replSet csReplSet --logpath /var/log/mongodb/cfg-a.log --dbpath /var/lib/mongo/config/config-a --configsvr --fork

echo "Configuring configuration server replica set"
mongo --port 27019 << 'EOF'
config = {
    _id: "csReplSet",
    members:[{
        _id : 0, host : "localhost:27019"
    }]
};
rs.initiate(config)
EOF

# now start the mongos on a standard port
mongos --configdb csReplSet/localhost:27019 --logpath /var/log/mongos.log --fork
echo "Waiting 60 seconds for the replica sets to fully come online"
sleep 60
echo "Connnecting to mongos and enabling sharding"

# Connecting shard servers with mongos
mongo <<'EOF'
use admin
db.runCommand( { addshard : "s0/localhost:27001" } );
db.runCommand( { addshard : "s1/localhost:27011" } );
EOF