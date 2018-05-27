#!/bin/bash

primaryPort=31260

dataStr="db = db.getSisterDB('admin');
         var opts = db.runCommand({getCmdLineOpts: 1});
         var isEnabled = opts.parsed.security.enableEncryption;
         var usingKMIP = false;
         if(opts.parsed.security.kmip) {usingKMIP = true};
         print(JSON.stringify({isEnabled: isEnabled, usingKMIP: usingKMIP}));"

function mongoEval {
  local port=$1
  local script=$2
  echo `mongo --quiet --port $port --eval "$script"`
}

function getData {
  local port=$1
  echo $(mongoEval $port "$dataStr")
}

getData $primaryPort
