import pymongo
import datetime
import sys

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")

# Remove lowest homework score for each student
def remove_lowest_homework_score():
    db = connection.school

    print("Finding all students that have homework scores...")
    try:
        students = db.students.find({})
    except Exception as e:
        print("Unexpected error:", type(e), e)

    # # Inspect the data structure
    # print("\nOriginal data")
    # i = 0
    # for student in students:
    #     print(student)
    #     i += 1
    #     if i > 5:
    #         break

    # # Get to know about homework score
    # numberofStudent = 0
    # minHomeworkTypeScore = 100
    # maxHomeworkTypeScore = 0
    # numberofHomeworkNotExist = 0
    # for student in students:
    #     n = 0
    #     for score in student['scores']:
    #         if score['type'] == 'homework':
    #             n += 1
    #     if minHomeworkTypeScore != 0 and n < minHomeworkTypeScore:
    #         minHomeworkTypeScore = n
    #     if n > 0:
    #         if n > maxHomeworkTypeScore:
    #             maxHomeworkTypeScore = n
    #     else:
    #         numberofHomeworkNotExist += 1
    #     numberofStudent += 1
    # print("Number of students", numberofStudent)
    # print("Minimum number of homework score", minHomeworkTypeScore)
    # print("Maximum number of homework score", maxHomeworkTypeScore)
    # print("Number of homework exist", numberofStudent - numberofHomeworkNotExist)
    # print("Number of homework not exist", numberofHomeworkNotExist)
    # # Current output
    # # ('Number of students', 200)
    # # ('Minimum number of homework score', 2)
    # # ('Maximum number of homework score', 2)
    # # ('Number of homework exist', 200)
    # # ('Number of homework not exist', 0)

    # Prune lowest homework score
    print("Pruning lowest homework score...")
    newStudentData = []  # Making container for student's cursor since it is a generator
    for student in students:
        newScores = []
        homeworkScores = []
        for score in student['scores']:
            if score['type'] != 'homework':
                newScores.append(score)
            else:
                homeworkScores.append(score)
        # Since in this case only two homework scores in the scores list, so we only need if else to prune lowest homework score
        if homeworkScores[0]['score'] > homeworkScores[1]['score']:
            newScores.append(homeworkScores[0])
        else:
            newScores.append(homeworkScores[1])
        # Replace the scores list
        student['scores'] = newScores
        newStudentData.append(student)

    # # Inspect the data structure
    # print("\nNew data")
    # i = 0
    # for student in newStudentData:
    #     print(student)
    #     i += 1
    #     if i > 5:
    #         break

    # Reset the collection
    db.students.drop()
    db.students.insert_many(newStudentData)
    print('Done')


if __name__ == '__main__':
    remove_lowest_homework_score()