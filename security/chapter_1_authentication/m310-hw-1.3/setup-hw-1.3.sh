#!/bin/bash

course="M310"
exercise="HW-1.3"
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"
logName="mongodb.log"

ports=(31130 31131 31132)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                 _id: '$replSetName',
                 members: [
                  { _id: 1, host: '$host:31130' },
                  { _id: 2, host: '$host:31131' },
                  { _id: 3, host: '$host:31132' }
                 ]
                })"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --port ${ports[$i]} --replSet $replSetName --fork
done

# wait for all the mongods to exit
sleep 10

# initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"

# register service principle
