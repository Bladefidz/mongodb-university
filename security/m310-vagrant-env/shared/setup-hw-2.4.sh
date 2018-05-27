#!/bin/bash

course='M310'
exercise='HW-2.4'
workingDir="$HOME/${course}-${exercise}"
logName="mongo"

serverKey="$HOME/shared/m310-certs/server.pem"
clientKey="$HOME/shared/m310-certs/client.pem"
caKey="$HOME/shared/m310-certs/ca.pem"

ports=(31240 31241 31242)
replSetName="TO_BE_SECURED"
configs=("")

host=`hostname -f`

echo "create working folder"
# create working folder
mkdir -p "$workingDir/"{r0,r1,r2}

echo 'launch mongod'
# launch mongod
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --bind_ip $host --port ${ports[$i]} --replSet $replSetName --sslMode requireSSL --sslPEMKeyFile $serverKey --sslCAFile $caKey --fork
done

# wait for mongod to exit
sleep 15

# Initiate replica set
mongo admin --ssl --host $host:${ports[0]} --sslPEMKeyFile $clientKey --sslCAFile $caKey --eval "rs.initiate()"

# Wait for PRIMARY
sleep 10

# Add shards
mongo admin --ssl --host $host:${ports[0]} --sslPEMKeyFile $clientKey --sslCAFile $caKey --eval "rs.add('$host:${ports[1]}')"
mongo admin --ssl --host $host:${ports[0]} --sslPEMKeyFile $clientKey --sslCAFile $caKey --eval "rs.add('$host:${ports[2]}')"