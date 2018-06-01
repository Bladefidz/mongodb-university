#!/bin/bash

primaryPort=31310

membersStr="var numMembers = rs.status().members.length;
            print(numMembers);"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getMembers {
  local port=$1
  echo $(mongoEval $port "$membersStr")
}

function createCollection {
  mongoEval $primaryPort "db.myTestCollection.drop()" > /dev/null
  mongoEval $primaryPort "db.createCollection('myTestCollection')" > /dev/null
}

function grepAuditLog {
  grep -q 'createCollection' ~/M310-HW-3.1/r0/auditLog.json
  echo $(expr $? + 1)
}

createCollection
echo "{ numMembers: $(getMembers $primaryPort), auditLog: $(grepAuditLog) }"
