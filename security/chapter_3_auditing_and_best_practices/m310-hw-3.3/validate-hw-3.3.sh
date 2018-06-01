#!/bin/bash

primaryPort=31330

membersStr="var numMembers = rs.status().members.length;
            print(numMembers);"

insertStr="db = db.getSisterDB('production');
           db.myApplication.insert({foo: 'bar'});"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getMembers {
  local port=$1
  echo $(mongoEval $port "$membersStr")
}

function insertDoc {
  mongoEval $primaryPort "$insertStr" > /dev/null
}

function grepAuditLog {
  grep -q '"foo" : "bar"' ~/M310-HW-3.3/r0/auditLog.json
  echo $(expr $? + 1)
}

insertDoc
echo "{ numMembers: $(getMembers $primaryPort), auditLog: $(grepAuditLog) }"
