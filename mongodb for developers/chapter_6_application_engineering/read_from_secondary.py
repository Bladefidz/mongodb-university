
import pymongo
import time

read_pref = pymongo.read_preferences.ReadPreference.SECONDARY

c = pymongo.MongoClient(host=["mongodb://localhost:27017",
                              "mongodb://localhost:27018",
                              "mongodb://localhost:27019"],
                              read_preference=read_pref)

db = c.m101
things = db.things

for i in range(1000):
    doc = things.find_one({'_id':i})
    print "Found doc ", doc
    time.sleep(.1)

                        




