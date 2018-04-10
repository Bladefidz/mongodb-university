#!/usr/bin/env python
import pymongo
import datetime

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")


# add a review date to a single record using update_one
def add_review_date_using_update_one(student_id):

    print("updating record using update_one and $set")
    # get a handle to the school database
    db = connection.school
    scores = db.scores

    try:
        # get the doc
        score = scores.find_one({'student_id': student_id, 'type': 'homework'})
        print("before: ", score)

        # update using set
        record_id = score['_id']
        result = scores.update_one({'_id': record_id},
                          {'$set': {'review_date': datetime.datetime.utcnow()}})
        print("num matched: ", result.matched_count)

        score = scores.find_one({'_id': record_id})
        print("after: ", score)

    except Exception:
        raise


# add a review date to all records
def add_review_dates_for_all():

    print("updating record using update_many and $set")
    # get a handle to the school database
    db = connection.school
    scores = db.scores

    try:
        # update all the docs
        result = scores.update_many(
            {}, {'$set': {'review_date': datetime.datetime.utcnow()}})
        print("num matched: ", result.matched_count)

    except Exception:
        raise


if __name__ == '__main__':
    add_review_date_using_update_one(1)
    #add_review_dates_for_all()
