#!/bin/bash

port=31240

membersStr="db = db.getSisterDB('admin');
           var numMembers = rs.status().members.length;
           var obj = {
             numMembers: numMembers
           };
           print(JSON.stringify(obj));"

hostname=`hostname -f`

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --host $hostname --ssl \
              --sslPEMKeyFile ~/shared/certs/client.pem \
              --sslCAFile ~/shared/certs/ca.pem --eval "$script"`
  
}

function getMembers {
  local port=$1
  echo $(mongoEval $port "$membersStr")
}

getMembers $port
