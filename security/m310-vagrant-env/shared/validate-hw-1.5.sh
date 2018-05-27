#!/bin/bash

primaryPort=31150

username="will"
password="\$uperAdmin"

statusStr="var status = rs.status();
           delete status.codeName;
           print(JSON.stringify(status))"
memberStr="db = db.getSisterDB('admin');
           db.auth('$username', '$password');
           var status = rs.status();
           var statuses = status.members.map((member) => (member.stateStr)).sort();
           print(JSON.stringify(statuses));"
userStr="db = db.getSisterDB('\$external');
         db.auth({
           mechanism: 'MONGODB-X509',
           user: 'C=US,ST=New York,L=New York City,O=MongoDB,OU=University2,CN=M310 Client'
         });
         db = db.getSisterDB('admin');
         var users = db.system.users.find().toArray();
         var userData = users.map((user) => ({_id: user._id, roles: user.roles})).sort();
         print(JSON.stringify(userData));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --host database.m310.mongodb.university --ssl --sslPEMKeyFile /home/vagrant/shared/m310-certs/client.pem --sslCAFile /home/vagrant/shared/m310-certs/ca.pem --port $port --eval "$script"`
}

function getUnauthorizedStatus {
  local port=$1
  echo $(mongoEval $port "$statusStr")
}

function getMemberStatuses {
  local port=$1
  echo $(mongoEval $port "$memberStr")
}

function getUsers {
  local port=$1
  echo $(mongoEval $port "$userStr")
}

echo "{ unauthorizedStatus: $(getUnauthorizedStatus $primaryPort), memberStatuses: $(getMemberStatuses $primaryPort), users: $(getUsers $primaryPort) }"
