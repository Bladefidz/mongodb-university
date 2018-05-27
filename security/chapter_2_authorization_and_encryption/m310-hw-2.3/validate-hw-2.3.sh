#!/bin/bash

port=31230

rolesStr="db = db.getSisterDB('admin');
          var roles = db.getRoles({showPrivileges: true});
          var sortedRoles = roles.map((role) => {
            return {
              role: role.role,
              inheritedRoles: role.inheritedRoles,
              privileges: role.privileges.map((privilege) => {
                return {
                  resource: privilege.resource,
                  actions: privilege.actions.sort()
                };
              }).sort((a, b) => (a.actions[0] > b.actions[0]))
            };
          }).sort((a, b) => (a.role > b.role));
          print(JSON.stringify(sortedRoles));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getRoles {
  local port=$1
  echo $(mongoEval $port "$rolesStr")
}

getRoles $port
