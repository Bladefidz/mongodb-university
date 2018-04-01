#!/usr/bin/env python
import pymongo

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")


def insert_two():

    # get a handle to the school database
    db = connection.school
    people = db.people

    print("insert, reporting for duty")

    richard = {"name": "Richard Kreuter", "company": "MongoDB",
               "interests": ['horses', 'skydiving', 'fencing']}
    andrew = {"_id": "erlichson", "name": "Andrew Erlichson",
              "company": "MongoDB", "interests": ['running', 'cycling',
                                                  'photography']}

    try:
        people.insert_one(richard)
        people.insert_one(andrew)

    except Exception as e:
        print("Unexpected error:", type(e), e)

    print(richard)
    print(andrew)


if __name__ == '__main__':
    insert_two()
