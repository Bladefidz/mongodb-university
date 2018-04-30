# This lab assumes that the m103.products collection is sharded on sku.
# If you sharded on name instead, you must reimport the dataset and shard it on
# sku. Here are the instructions to do this:

# Drop the collection m103.products and reimport the dataset:
mongoimport --drop products.json --port 26000 -u "m103-admin" \
-p "m103-pass" --authenticationDatabase "admin" \
--db m103 --collection products

mongo --port 26000 -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin" << 'EOF'
// Create an index on sku:
use m103
db.products.createIndex({"sku":1})
// Shard the collection on sku:
use admin
db.adminCommand({shardCollection: "m103.products", key: {sku: 1}})
EOF