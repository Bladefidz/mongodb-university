#!/usr/bin/env bash

mkdir -p ~/rtd
mongod -f /shared/rtd.cfg
ps -ef | grep mongod
cat /shared/rtd.cfg

# This should be the londonbikes dataset; download from
# unpack, and put in /shared.
wget https://s3.amazonaws.com/university-courses/handouts/londonbikes.tgz -O /shared/londonbikes.tgz
mongorestore --drop --gzip --port 27001 -d londonbikes /shared/dump  

mongostat --port 27001
mongostat --port 27001 -o "time=T,dirty=dirty,used=used,insert=Inserts,qrw=qrw,arw=arw"

mongo admin --port 27001 --eval "db.shutdownServer()"

# vi /shared/rtd.cfg
# ^ Instead of doing this and increasing the cache size to 2 gigs, you can
#     get the same effect with the following:
cat /shared/rtd.cfg | sed 's/0.25/2/' > tmp; mv tmp /shared/rtd.cfg


mongoimport -d m312 -c norberto_friends /dataset/friends_10.json
mongo --port 27001 m312 # first connection with shell



mongoimport --port 27001 -d m312 -c norberto_friends /dataset/friends_1000.json
mongo --port 27001 m312  # second connection with shell



mongoimport --port 27001 -d m312 -c norberto_friends /dataset/friends_1000000.json
mongo --port 27001 m312 # third connection with shell

mlogvis --no-browser -o /shared/rtd.html rtd/log
mongo m312 --port 27001  # fourth connection with shell
