import pymongo

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")

# get a handle to the test database
db=connection.school
foo = db.students


for j in range(1,10):
    for i in range(400000,500000):
        doc = foo.find_one({'student_id':i})
        # print "first score for student ", doc['student_id'], "is ", doc['scores'][0]['score']
        if (i % 1000 == 0):
	    print "Did 1000 Searches"