#!/bin/bash

course='M310'
exercise='HW-2.1'
workingDir="$HOME/${course}-${exercise}"
logName="mongo"

ports=(31210 31211 31212)
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
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --bind_ip "$host" --port ${ports[$i]} --replSet $replSetName --keyFile $keyfile --fork
done

# wait for mongo to exit
sleep 10

echo "Initiate replica set"
mongo admin --port ${ports[0]} --eval "rs.initiate()"

# wait for PRIMARY
sleep 15

echo "Create user userAdmin"
# Create new user:
# 	User 	: userAdmin
# 	Pass	: badges 
# 	Can 	: Create users on any database
# 	Cannot	: run dbhash
createUserAdmin="db.createUser({
	user: 'userAdmin',
	pwd: 'badges',
	roles: [{
		role: 'userAdminAnyDatabase', db: 'admin'
	}]
})"
mongo admin --port ${ports[0]} --eval "$createUserAdmin"

echo "Create user sysAdmin"
# Create new user:
# 	User 	: sysAdmin
# 	Pass	: cables
# 	Can 	: configure a replica set and add shards
# 	Cannot 	: run hostInfo
createSysAdmin="db.createUser({
	user: 'sysAdmin',
	pwd: 'cables',
	roles: [{
		role: 'clusterManager', db: 'admin'
	}]
})"
mongo admin -u "userAdmin" -p "badges" --port ${ports[0]} --eval "$createSysAdmin"

echo "Add shards"
# Configure replica set and add shards
mongo admin -u "sysAdmin" -p "cables" --port ${ports[0]} --eval "rs.add('$host:31211');rs.add('$host:31212')"

echo "Create user dbAdmin"
# Create new user:
# 	User 	: dbAdmin
# 	Pass	: collections
# 	Can 	: create a collection on any database
# 	Cannot 	: run insert
createDbAdmin="db.createUser({
	user: 'dbAdmin',
	pwd: 'collections',
	roles: [{
		role: 'dbAdminAnyDatabase', db: 'admin'
	}]
})"
mongo admin -u "userAdmin" -p "badges" --port ${ports[0]} --eval "$createDbAdmin"

echo "Create user dataLoader"
# Create new user:
# 	User 	: dataLoader
# 	Pass	: dumpin
# 	Can 	: insert data on any database
# 	Cannot 	: run validate
createDataLoader="db.createUser({
	user: 'dataLoader',
	pwd: 'dumpin',
	roles: [{
		role: 'readWriteAnyDatabase', db: 'admin'
	}]
})"
mongo admin -u "userAdmin" -p "badges" --port ${ports[0]} --eval "$createDataLoader"