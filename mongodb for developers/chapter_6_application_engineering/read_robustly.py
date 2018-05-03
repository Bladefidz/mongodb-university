
import pymongo
import sys
import time

c = pymongo.MongoClient(host=["mongodb://localhost:27017",
                              "mongodb://localhost:27018",
                              "mongodb://localhost:27019"],
                        replicaSet="m101")

db = c.m101

things = db.things

for i in range(0,500):
    for retry in range (3):
        try:
            things.find_one({'_id':i})
            print "read document: " + str(i)
            time.sleep(.1)
            break
        except pymongo.errors.AutoReconnect as e:
            print "Exception ",type(e), e
            print "Retrying.."
            time.sleep(5)

                


    





