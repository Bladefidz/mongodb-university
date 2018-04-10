#!/usr/bin/env python

import pymongo

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")


def insert_many():
    # get a handle to the school database
    db = connection.school
    people = db.people

    print("insert_many, reporting for duty")
    andrew = {"_id": "erlichson", "name": "Andrew Erlichson",
              "company": "MongoDB",
              "interests": ['running', 'cycling', 'photography']}
    richard = {"name": "Richard Kreuter", "company": "MongoDB",
               "interests": ['horses', 'skydiving', 'fencing']}
    people_to_insert = [andrew, richard]
    try:
        people.insert_many(people_to_insert, ordered=False)
    except Exception as e:
        print("Unexpected error:", type(e), e)


def print_people():
    # get a handle to the school database
    db = connection.school
    people = db.people
    cur = people.find({}, {'name': 1})
    for doc in cur:
        print(doc)

if __name__ == '__main__':
    print("Before the insert_many, here are the people")
    print_people()
    insert_many()
    print("\n\nAfter the insert_many, here are the people")
    print_people()
