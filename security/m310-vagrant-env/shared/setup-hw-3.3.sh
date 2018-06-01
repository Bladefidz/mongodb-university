#!/bin/bash

course="M310"
exercise="HW-3.3"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongo.log"
auditLogName="auditLog.json"

ports=(31330 31331 31332)
replSetName="auditing-repl"

host=`hostname -f`
initiateStr="rs.initiate({
 	_id: '$replSetName',
 		members: [
  			{ _id: 1, host: '$host:${ports[0]}' },
  			{ _id: 2, host: '$host:${ports[1]}' },
  			{ _id: 3, host: '$host:${ports[2]}' }
 	]
})"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --setParameter auditAuthorizationSuccess=true --auditDestination file --auditFormat JSON --auditPath "$workingDir/r$i/$auditLogName" --fork
done

# wait for all the mongods to exit
sleep 3

# initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"

# Wait for the PRIMARY
sleep 15