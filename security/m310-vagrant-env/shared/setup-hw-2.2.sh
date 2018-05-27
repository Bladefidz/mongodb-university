#!/bin/bash

course='M310'
exercise='HW-2.2'
workingDir="$HOME/${course}-${exercise}"
logName="mongo"

ports=(31220 31221 31222)
replSetName="TO_BE_SECURED"
keyfile="/home/vagrant/shared/mongodb-keyfile"

host=`hostname -f`

echo "create working folder"
# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

echo 'launch mongods'
# launch mongod's
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --bind_ip $host --port ${ports[$i]} --replSet $replSetName --keyFile $keyfile --fork
done

# wait for mongo to exit
sleep 10

echo "Initiate replica set"
mongo admin --port ${ports[0]} --eval "rs.initiate()"

# wait for PRIMARY
sleep 15

echo "Create user admin"
# Create new user:
# 	User 	: admin
# 	Pass	: webscale
createUserAdmin="db.createUser({
	user: 'admin',
	pwd: 'webscale',
	roles: [{
		role: 'root', db: 'admin'
	}]
})"
mongo admin --port ${ports[0]} --eval "$createUserAdmin"

echo "Create user reader"
# Create new user:
# 	User 	: reader
# 	Pass	: books
createUserReader="db.createUser({
	user: 'reader',
	pwd: 'books',
	roles: [{
		role: 'read', db: 'acme'
	}]
})"
mongo admin -u "admin" -p "webscale" --port ${ports[0]} --authenticationDatabase "admin" --eval "$createUserReader"

echo "Add shards"
# Configure replica set and add shards
mongo admin -u "admin" -p "webscale" --port ${ports[0]} --authenticationDatabase "admin" --eval "rs.add('$host:${ports[1]}');rs.add('$host:${ports[2]}')"

echo "Create user admin"
# Create new user:
# 	User 	: admin
# 	Pass	: webscale
createWriter="db.createUser({
	user: 'writer',
	pwd: 'typewriter',
	roles: [{
		role: 'readWrite', db: 'acme'
	}]
})"
mongo admin -u "admin" -p "webscale" --port ${ports[0]} --authenticationDatabase "admin" --eval "$createWriter"