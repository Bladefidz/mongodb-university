#!/usr/bin/env bash

course='M310'
exercise='HW-1.4'
workingDir="$HOME/${course}-${exercise}"
dbDir="$workingDir/db"

getUserStr="db = db.getSisterDB('admin');
            alice = db.system.users.findOne({
              '_id': 'admin.alice'
            });
            Object.keys(alice.credentials)"

killall mongod --quiet --wait

mongod --dbpath $dbDir --logpath $dbDir/mongo.log --fork
mongo --quiet --eval "$getUserStr"

killall mongod --quiet
