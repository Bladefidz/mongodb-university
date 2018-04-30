// on the primary, create an index
db.restaurants.createIndex({"name": 1})

// on the primary, confirm that the query uses the index
db.restaurants.find({name: "Perry Street Brasserie"}).explain()

// connect to the secondary with priority 0
db = connect("127.0.0.1:27002/m201")

// enable secondary reads
db.setSlaveOk()

// confirm that the same winning plan (using the index) happens on the secondary
db.restaurants.find({name: "Perry Street Brasserie"}).explain()