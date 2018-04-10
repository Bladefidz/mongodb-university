#!/usr/bin/env python
import pymongo

# It is not necessary to import sys

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")

# get a handle to the school database
db = connection.school
scores = db.scores


def find():

    print("find(), reporting for duty")

    query = {'type': 'exam'}

    try:
        cursor = scores.find(query)

    except Exception as e:
        print("Unexpected error:", type(e), e)

    sanity = 0
    for doc in cursor:
        print(doc)
        sanity += 1
        if (sanity > 10):
            break


def find_one():

    print("find_one(), reporting for duty")
    query = {'student_id': 10}
    
    try:
        doc = scores.find_one(query)
        
    except Exception as e:
        print("Unexpected error:", type(e), e)
    
    print(doc)


if __name__ == '__main__':
    find()  # Change this to find_one() to run that function, instead.
