# indexStats()

Return how often indexes accessed and touch. For example:

```
db.orders.aggregate( [ { $indexStats: { } } ] )
```

will output:

```
{
   "name" : "item_1_quantity_1",
   "key" : {
      "item" : 1,
      "quantity" : 1
   },
   "host" : "examplehost.local:27017",
   "accesses" : {
      "ops" : NumberLong(1),
      "since" : ISODate("2015-10-02T14:31:53.685Z")
   }
}
{
   "name" : "_id_",
   "key" : {
      "_id" : 1
   },
   "host" : "examplehost.local:27017",
   "accesses" : {
      "ops" : NumberLong(0),
      "since" : ISODate("2015-10-02T14:31:32.479Z")
   }
}
{
   "name" : "type_1_item_1",
   "key" : {
      "type" : 1,
      "item" : 1
   },
   "host" : "examplehost.local:27017",
   "accesses" : {
      "ops" : NumberLong(1),
      "since" : ISODate("2015-10-02T14:31:58.321Z")
   }
}
```

The benefit of `indexStats()` are:

- Find hot index which is extensively used to do many operations.
- Find cold index which is rarely used.

The behavior of `indexStats()` are:

- `accesses.ops` will be incremented if `find` operations triggered, including `update()` which is required to `find` matched document at first.
- Each member on replica set has its own version of `indexStats()`.

For more information please read [the documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/indexStats/index.html).