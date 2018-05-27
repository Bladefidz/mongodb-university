#!/bin/bash

course="M310"
exercise="HW-1.2"
workingDir="$HOME/${course}-${exercise}"
logName="mongo"

ports=(31120 31121 31122)
replSetName="TO_BE_SECURED"
keyfile="/home/vagrant/shared/mongodb-keyfile"

host=`hostname -f`
createUserStr="db.createUser({user: 'admin', pwd: 'webscale', roles: ['root']})"

# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --port ${ports[$i]} --replSet $replSetName --keyFile $keyfile --fork
done

# wait for all the mongods to exit
sleep 15

# create new user
mongo admin --port ${ports[0]} --eval "$createUserStr"
