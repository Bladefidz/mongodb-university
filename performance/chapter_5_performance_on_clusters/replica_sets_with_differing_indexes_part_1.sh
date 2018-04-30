#!/usr/bin/env bash

# create directories for the different replica set members
mkdir -p /data/r{0,1,2}

# go into the configuration file directory
cd replicaset_configs

# checkout the ports our servers will be running on
grep 'port' *

# launch each member
mongod -f r0.cfg
mongod -f r1.cfg
mongod -f r2.cfg

# confirm all members are up and running
ps -ef | grep mongod

# connect to one of the members
mongo --port 27000