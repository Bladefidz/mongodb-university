REM  Andrew Erlichson - Original author
REM  Jai Hirsch       - Translated original .sh file to .bat
REM  Nathan Leniz     - Updated for MongoDB 3.4
REM  10gen
REM  script to start a sharded environment on localhost

echo "del data files for a clean start"

del /Q c:\data\shard0
del /Q c:\data\shard1
del /Q c:\data\shard2
del /Q c:\data\config

mongo -eval "sleep(5000)" --nodb

REM  start a replica set and tell it that it will be a shard0

mkdir c:\data\shard0\rs0
mkdir c:\data\shard0\rs1
mkdir c:\data\shard0\rs2
start mongod --replSet s0 --dbpath c:\data\shard0\rs0 --port 37017  --shardsvr --oplogSize 100
start mongod --replSet s0 --dbpath c:\data\shard0\rs1 --port 37018  --shardsvr --oplogSize 100
start mongod --replSet s0 --dbpath c:\data\shard0\rs2 --port 37019  --shardsvr --oplogSize 100

mongo --eval "sleep(5000)" --nodb

REM  connect to one server and initiate the set
mongo --port 37017 --eval "config = { _id: 's0', members:[{ _id : 0, host : 'localhost:37017' },{ _id : 1, host : 'localhost:37018' },{ _id : 2, host : 'localhost:37019' }]};rs.initiate(config)"

REM  start a replicate set and tell it that it will be a shard1
mkdir c:\data\shard1\rs0
mkdir c:\data\shard1\rs1
mkdir c:\data\shard1\rs2

start mongod --replSet s1 --dbpath c:\data\shard1\rs0 --port 47017  --shardsvr --oplogSize 100
start mongod --replSet s1 --dbpath c:\data\shard1\rs1 --port 47018  --shardsvr --oplogSize 100
start mongod --replSet s1 --dbpath c:\data\shard1\rs2 --port 47019  --shardsvr --oplogSize 100

mongo --eval "sleep(5000)" --nodb

mongo --port 47017 --eval "config = { _id: 's1', members:[{ _id : 0, host : 'localhost:47017' },{ _id : 1, host : 'localhost:47018' },{ _id : 2, host : 'localhost:47019' }]};rs.initiate(config);"

REM  start a replicate set and tell it that it will be a shard2
mkdir c:\data\shard2\rs0
mkdir c:\data\shard2\rs1
mkdir c:\data\shard2\rs2
start mongod --replSet s2 --dbpath c:\data\shard2\rs0 --port 57017  --shardsvr --oplogSize 100
start mongod --replSet s2 --dbpath c:\data\shard2\rs1 --port 57018  --shardsvr --oplogSize 100
start mongod --replSet s2 --dbpath c:\data\shard2\rs2 --port 57019  --shardsvr --oplogSize 100

mongo --eval "sleep(5000)" --nodb

mongo --port 57017 --eval "config = { _id: 's2', members:[{ _id : 0, host : 'localhost:57017' },{ _id : 1, host : 'localhost:57018' },{ _id : 2, host : 'localhost:57019' }]};rs.initiate(config)"

REM  now start 3 config servers

mkdir c:\data\config\config-a
mkdir c:\data\config\config-b
mkdir c:\data\config\config-c
start mongod --replSet csReplSet --dbpath c:\data\config\config-a --port 57040 --configsvr --oplogSize 100
start mongod --replSet csReplSet --dbpath c:\data\config\config-b --port 57041 --configsvr --oplogSize 100
start mongod --replSet csReplSet --dbpath c:\data\config\config-c --port 57042 --configsvr --oplogSize 100

mongo --eval "sleep(5000)" --nodb

mongo --port 57040 --eval "config = { _id: 'csReplSet', members:[{ _id : 0, host : 'localhost:57040' },{ _id : 1, host : 'localhost:57041' },{ _id : 2, host : 'localhost:57042' }]};rs.initiate(config)"

echo "now start the mongos on a standard port"
start mongos  --configdb csReplSet/localhost:57040,localhost:57041,localhost:57042

echo "Wait 30 seconds for the replica sets to fully come online"
mongo --eval "sleep(30000)" --nodb

echo "Connnecting to mongos and enabling sharding"

REM  add shards and enable sharding on the test db
mongo --eval "db=db.getSisterDB('admin');db.runCommand( { addshard : 's0/'+'localhost:37017' } );db.runCommand( { addshard : 's1/'+'localhost:47017' } );db.runCommand( { addshard : 's2/'+'localhost:57017' } )"
mongo --eval "db=db.getSisterDB('admin');db.runCommand({enableSharding: 'school'});db.runCommand({shardCollection: 'school.students', key: {student_id:1}})"
