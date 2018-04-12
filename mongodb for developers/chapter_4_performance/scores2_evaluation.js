evaluations = {}

var db = db.getSiblingDB("school");

evaluations.examMoreThan90 = function() {
    execMilisMean = 0;
    for (let i = 0; i < 5; i++) {
        var exp = db.students.explain('executionStats').find(
            {'scores.type': 'exam', 'scores.score': {$gte: 90}}
        );
        var expRes = exp.finish()
        execMilisMean += expRes.executionStats.executionTimeMillis;
    }
    return execMilisMean / 5;
}