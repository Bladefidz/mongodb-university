#!/bin/bash

course="M310"
exercise="HW-3.2"
workingDir="$HOME/${course}-${exercise}"

ports=(31320 31321 31322)
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
createUser="db = db.getSisterDB('admin');
db.createUser({user: 'steve', pwd: 'secret', roles: ['root']})"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=1; i < 4; i++))
do
  mongod -f "$HOME/shared/hw-3.2-member$i.cnf"
done

# wait for all the mongods to exit
sleep 3

# initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"

# Wait for the PRIMARY
sleep 15

# Create a user
mongo --port ${ports[0]} --eval "$createUser"