#!/bin/bash

primaryPort=31220

username="admin"
password="webscale"

usersStr="db = db.getSisterDB('admin');
          db.auth('$username', '$password');
          var users = db.system.users.find().toArray();
          var sortedUsers = users.map((user) => {
            return {
              user: user.user,
              roles: user.roles
            };
          }).sort((a, b) => (a.user > b.user));
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
