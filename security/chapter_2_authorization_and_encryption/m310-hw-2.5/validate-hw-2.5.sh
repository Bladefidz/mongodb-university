#!/bin/bash

secondaryPort=31250

getPrimaryStr="var status = rs.status();
               status.members.filter((member) => {
                 return member.stateStr === 'PRIMARY';
               })[0].name.split(':')[1]"

dataStr="db = db.getSisterDB('admin');
         var opts = db.runCommand({getCmdLineOpts: 1});
         var isEnabled = opts.parsed.security.enableEncryption;
         db = db.getSisterDB('beforeEncryption');
         doc = db.coll.findOne({},{_id:0});
         print(JSON.stringify({doc: doc, isEnabled: isEnabled}));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getData {
  local port=$(mongoEval $secondaryPort "$getPrimaryStr")
  echo $(mongoEval $port "$dataStr")
}

getData
