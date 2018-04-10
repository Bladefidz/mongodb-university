#!/usr/bin/env python
import pymongo
import sys

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")

# get a handle to the school database
db=connection.school
scores = db.scores


def find():

    print "find, reporting for duty"

    query = {'type': 'exam'}
    projection = {'student_id': 1, '_id': 0}
#    projection = {'student_id': 1}

    try:
        cursor = scores.find(query, projection)

    except Exception as e:
        print "Unexpected error:", type(e), e

    sanity = 0
    for doc in cursor:
        print doc
        sanity += 1
        if (sanity > 10):
            break


if __name__ == '__main__':
    find()
