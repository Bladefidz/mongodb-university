#!/bin/bash

primaryPort=31320

membersStr="db = db.getSisterDB('admin');
            db.auth('steve', 'secret');
            var numMembers = rs.status().members.length;
            print(numMembers);"

dbSetupStr1="db = db.getSisterDB('admin');
             db.auth('steve', 'secret');
             db.dropUser('kirby');
             db.createUser({user: 'kirby', pwd: 'mongodb', roles: ['root']});
             db = db.getSisterDB('production');
             db.myApplication.drop();
             db.createCollection('myApplication');"

dbSetupStr2="db = db.getSisterDB('admin');
             db.auth('kirby', 'mongodb');
             db = db.getSisterDB('production');
             db.myOtherApplication.drop();
             db.createCollection('myOtherApplication');"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getMembers {
  local port=$1
  echo $(mongoEval $port "$membersStr")
}

function dbSetup {
  mongoEval $primaryPort "$dbSetupStr1" > /dev/null
  mongoEval $primaryPort "$dbSetupStr2" > /dev/null
}

function grepAuditLog1 {
  grep -q 'myApplication' ~/M310-HW-3.2/r0/auditLog.json
  echo $(expr $? + 1)
}

function grepAuditLog2 {
  grep -q 'myOtherApplication' ~/M310-HW-3.2/r0/auditLog.json
  echo $(expr $? - 1)
}

dbSetup
echo "{ numMembers: $(getMembers $primaryPort), auditLog1: $(grepAuditLog1), auditLog2: $(grepAuditLog2) }"
