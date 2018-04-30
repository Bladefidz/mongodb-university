#!/usr/bin/env bash

# load the restaurants dataset to each member
mongoimport --host M201/localhost:27001,localhost:27002,localhost:27000 -d m201 -c restaurants restaurants.json

# connect to the replica set
mongo --host M201/localhost:27001,localhost:27002,localhost:27000