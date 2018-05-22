#!/bin/bash

primaryPort=31130

statusStr="var status = rs.status();
           delete status.codeName;
           print(JSON.stringify(status))"
memberStr="db = db.getSisterDB('\$external');
           db.auth({
             mechanism: 'MONGODB-X509',
             user: 'C=US,ST=New York,L=New York City,O=MongoDB,OU=University2,CN=M310 Client'
           });
           var status = rs.status();
           var statuses = status.members.map((member) => (member.stateStr)).sort();
           print(JSON.stringify(statuses));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --host database.m310.mongodb.university --ssl --sslPEMKeyFile ~/shared/certs/client.pem --sslCAFile ~/shared/certs/ca.pem --port $port --eval "$script"`
}

function getUnauthorizedStatus {
  local port=$1
  echo $(mongoEval $port "$statusStr")
}

function getMemberStatuses {
  local port=$1
  echo $(mongoEval $port "$memberStr")
}

echo "{ unauthorizedStatus: $(getUnauthorizedStatus $primaryPort), memberStatuses: $(getMemberStatuses $primaryPort) }"
