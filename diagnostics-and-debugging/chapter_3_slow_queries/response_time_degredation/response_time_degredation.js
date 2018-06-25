// connect to the mongo shell with `mongo m312 --port 27001`
show collections;
db.norberto_friends.find({ city: "Barcelona" });
db.setProfilingLevel( 2, 0 );  // All queries go to profiler, and logs capture them, too.
db.norberto_friends.find({ city: "Barcelona" });
db.system.profile.find().pretty();
exit


// Second connection with shell
db.setProfilingLevel( 2 );
db.norberto_friends.find({ city: "Barcelona" });
db.system.profile.find().pretty();
exit

// third connection with shell
db.setProfilingLevel( 2 );
db.norberto_friends.find({city:"Barcelona"})
db.system.profile.find().pretty();
db.setProfilingLevel( 0, 100 );  // Clean up after ourselves.
db.system.profile.drop();
exit


// fourth connection
db.norberto_friends.find({city:"Barcelona"}).explain();
db.norberto_friends.createIndex( { city : 1 } );
db.norberto_friends.find({city:"Barcelona"}).explain('executionStats');

// covered query
db.norberto_friends.createIndex({city: 1, name:1});
db.norberto_friends.find({city:"Barcelona"}, {_id:0, name:1}).explain('executionStats');


// paginate results
db.norberto_friends.find({city:"Barcelona"}, {_id:0, name:1}).skip(0).limit(20).explain('executionStats');
