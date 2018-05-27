#!/bin/bash

primaryPort=31120

username="admin"
password="webscale"

statusStr="var status = rs.status();
           delete status.codeName;
           print(JSON.stringify(status))"
memberStr="db = db.getSisterDB('admin');
           db.auth('$username', '$password');
           var status = rs.status();
           var statuses = status.members.map((member) => (member.stateStr)).sort();
           print(JSON.stringify(statuses));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
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
