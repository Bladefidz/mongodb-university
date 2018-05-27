#!/bin/bash

course="M310"
exercise="HW-2.5"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31250 31251 31252)
replSetName="UNENCRYPTED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:${ports[0]}' },
                  { _id: 2, host: '$host:${ports[1]}' },
                  { _id: 3, host: '$host:${ports[2]}' }
                 ]
                })"
insertStr="db = db.getSisterDB('beforeEncryption');
           db.coll.insert({str: 'The quick brown fox jumps over the lazy dog'}, {writeConcern: { w: 'majority' , wtimeout: 5000}})"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --port ${ports[$i]} --replSet $replSetName --fork
done

# wait for all the mongods to exit
sleep 3

# initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"

sleep 15

# load some data
mongo --port ${ports[0]} --eval "$insertStr"
