#!/bin/bash

course='M310'
exercise='HW-1.4'
workingDir="$HOME/${course}-${exercise}"
tmpDir="$workingDir/tmp"
dbDir="$workingDir/db"
logPath="$dbDir/mongo.log"

mongodbDownloadsURL='https://downloads.mongodb.com/linux'
mongodbVersion='mongodb-linux-x86_64-enterprise-ubuntu1404-2.6.11'
mongodbTarBall="$mongodbVersion.tgz"
mongodbTarBallURL="$mongodbDownloadsURL/$mongodbTarBall"

mongod="$tmpDir/$mongodbVersion/bin/mongod"

createUserStr="db = db.getSisterDB('admin');
               db.createUser({
                user: 'alice',
                pwd: 'secret',
                roles: ['root']
               })"

mkdir -p $tmpDir $dbDir

sudo apt-get install -y libgssapi-krb5-2 \
                        libsasl2-2 \
                        libssl1.0.0 \
                        libstdc++6 \
                        snmp

curl -o "$tmpDir/$mongodbTarBall" $mongodbTarBallURL
tar -xvf "$tmpDir/$mongodbTarBall" -C $tmpDir

killall mongod

$mongod --dbpath $dbDir --logpath $logPath --fork

mongo --eval "$createUserStr"

killall mongod
rm -r $tmpDir

mongod --dbpath $dbDir --logpath $logPath --fork
