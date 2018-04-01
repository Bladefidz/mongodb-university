
# Andrew Erlichson
# MongoDB, Inc. 
# M101P - Copyright 2015, All Rights Reserved


import pymongo
import datetime
import sys

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")
        
# removes one student
def remove_student(student_id):

    # get a handle to the school database
    db = connection.school
    scores = db.scores

    try:

        result = scores.delete_many({'student_id':student_id})

        print("num removed: ", result.deleted_count)

    except Exception as e:
        print("Exception: ", type(e), e)

# Find a student by id
def find_student_data(student_id):
    # get a handle to the school database
    db = connection.school
    scores = db.scores
    
    print("Searching for student data for student with id = ", student_id)
    try: 
        docs = scores.find({'student_id':student_id})
        for doc in docs:
            print(doc)

    except Exception as e:
        print("Exception: ", type(e), e)

# Remove lowest homework score for each student
def remove_lowest_homework_score():
    db = connection.students

    print("Finding all students that have homework scores...")
    try:
        homeworkGrades = db.grades.find({'type': 'homework'},
                                        {'_id': 1, 'student_id': 1})
        homeworkGrades.sort([('student_id', pymongo.ASCENDING),
                             ('score', pymongo.ASCENDING)])
    except Exception as e:
        print("Unexpected error:", type(e), e)

    idToRemove = []
    lastStudentId = -1
    for sg in homeworkGrades:
        if sg['student_id'] != lastStudentId:
            idToRemove.append(sg['_id'])
            lastStudentId = sg['student_id']
            # print(lastStudentId)  # Sanity check

    print("Removing {} lowest homework scores...".format(len(idToRemove)))
    try:
        result = db.grades.delete_many({'_id': {'$in': idToRemove}})
        print("num removed: ", result.deleted_count)
    except Exception as e:
        print("Unexpected error:", type(e), e)


if __name__ == '__main__':
    # remove_student(1)
    # find_student_data(1)
    remove_lowest_homework_score()
