#!/bin/sh
mongo redaction --quiet --eval "db.setProfilingLevel(0, -1);" > /dev/null
mongo redaction --quiet --eval "db.sensitive.insert({'a': 'hello'})" > /dev/null
mongo redaction --quiet --eval "db.adminCommand({ 'setParameter': 1, 'redactClientLogData': 0});" > /dev/null
mongo redaction --quiet --eval "db.sensitive.find({'a': 'goodbye'})" > /dev/null
mongo redaction --quiet --eval "db.sensitive.insert({'a': 'hi'})" > /dev/null
mongo redaction --quiet --eval "db.adminCommand({ setParameter: 1, redactClientLogData: 1});" > /dev/null
mongo redaction --quiet --eval "db.sensitive.deleteMany({'a': 'hi'})" > /dev/null
a0=`cat /data/redaction/mongod.log | egrep "hello" | wc -l`
echo $(expr 1 - $a0)
