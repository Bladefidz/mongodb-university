#!/usr/bin/env python

import json
import pymongo

# connect to mongo
connection = pymongo.MongoClient("mongodb://localhost")

# get a handle to the reddit database
db = connection.reddit
stories = db.stories

# drop existing collection
stories.drop()

# parse the json into python objects
parsed = json.load(open('reddit.json', 'r'))

# Insert all datas
stories.insert_many(parsed['data']['children'], ordered=False)