# Importing dataset
mongoimport --drop products.part2.json --port 26000 -u "m103-admin" \
-p "m103-pass" --authenticationDatabase "admin" \
--db m103 --collection products

# Enable sharding
mongo --port 26000 -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin" << 'EOF'
sh.enableSharding("m103")
db.products.createIndex({"regularPrice": 1})
use admin
db.adminCommand( { shardCollection: "m103.products", key: { "regularPrice": 1 } } )
EOF
