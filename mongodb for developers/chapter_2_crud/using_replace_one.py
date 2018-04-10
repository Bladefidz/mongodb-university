
import pymongo
import datetime
import sys

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")

# removes all review dates
def remove_all_review_dates():
    print "\n\nremoving all review dates"

    # get a handle to the school database
    db=connection.school
    scores = db.scores
    try:
        result = scores.update_many({'review_date':{'$exists':True}},
                                    {'$unset':{'review_date':1}})
        print "Matched this number of docs: ", result.matched_count

    except Exception as e:
        print "Unexpected error:", type(e), e
        raise


        

# add a review date to single record using replace_one
def add_review_date_using_replace_one(student_id):

    # get a handle to the school database
    db=connection.school
    scores = db.scores

    print "updating record using replace_one"

    try:
        # get the doc
        score = scores.find_one({'student_id':student_id, 'type':'homework'})
        print "before: ", score

        # add a review_date
        score['review_date'] = datetime.datetime.utcnow()

        # update the record with replace_one
        record_id = score['_id']
        scores.replace_one({'_id': record_id}, score)
        score = scores.find_one({'_id': record_id})
        print "after: ", score

    except Exception as e:
        print "Unexpected error:", type(e), e
        raise


remove_all_review_dates()
add_review_date_using_replace_one(1)

