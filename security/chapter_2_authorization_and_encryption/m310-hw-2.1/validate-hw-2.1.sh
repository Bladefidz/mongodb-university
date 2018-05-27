#!/bin/bash

primaryPort=31210

userAdminUsername="userAdmin"
userAdminPassword="badges"

sysAdminUsername="sysAdmin"
sysAdminPassword="cables"

usersStr="db = db.getSisterDB('admin');
          db.auth('$userAdminUsername', '$userAdminPassword');
          var users = db.system.users.find().toArray();
          var sortedUsers = users.map((user) => {
            return {
              user: user.user,
              roles: user.roles
            };
          }).sort((a, b) => (a.user > b.user));
          db.auth('$sysAdminUsername', '$sysAdminPassword');
          var numMembers = rs.status().members.length;
          var obj = {
            users: sortedUsers,
            numMembers: numMembers
          };
          print(JSON.stringify(obj));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getUsers {
  local port=$1
  echo $(mongoEval $port "$usersStr")
}

getUsers $primaryPort
