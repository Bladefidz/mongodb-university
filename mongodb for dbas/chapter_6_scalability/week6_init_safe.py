import pymongo
import sys
import time
import datetime
import copy

c = pymongo.MongoClient(
        host=["mongodb://localhost:27001",
              "mongodb://localhost:27002",
              "mongodb://localhost:27003"],
        replicaSet="s0",
        w=1,
        j=True)
db = c.week6

def init():
    trades = db.trades
    trades.delete_many({})   # remove all the docs in the collection

    print "db is", db.name
    if("week6" != db.name):
        print("want 'db' to be 'week6' when the shell starts. terminating.")
    else:
        data = { 
            'ticker' : 'abcd',
            'time'   : datetime.datetime(2012,2,3),
            'price'  : 110,
            'shares' : 200, 
            'details' : {
                'asks' : [ 110.07, 110.12, 110.30 ],
                'bids' : [ 109.90, 109.88, 109.70, 109.5 ], 
                'system' : 'abc',
                'lag' : 0
            }
        };

        for retry in range (3):
            try:
                d = copy.copy(data)
                trades.insert(d)
                print "Inserted Document with ticker ", d['ticker']
                time.sleep(.1)
                break
            except pymongo.errors.AutoReconnect as e:
                print "Exception ",type(e), e
                print "Retrying.."
                time.sleep(5)
            except pymongo.errors.DuplicateKeyError as e:
                print "duplicate..but it worked"
                break

        j = 100
        for i in range(1000000):
            j = j + 1
            if(j >= 500):
                j = 100;
            d = copy.copy(data)
            d['ticker'] = 'z' + str(j)
            d['time'] = datetime.datetime(2012, 2, 3, 9, i%60, (i/60)%60, (i/3600)%1000)
            for retry in range (3):
                try:
                    trades.insert(d)
                    print "Inserted document with ticker", d['ticker']
                    time.sleep(.1)
                    break
                except pymongo.errors.AutoReconnect as e:
                    print "Inserting document with ticker", d['ticker']
                    print "Exception ",type(e), e
                    print "Retrying.."
                    time.sleep(5)
                except pymongo.errors.DuplicateKeyError as e:
                    print "Document with ticker", d['ticker'], "duplicate, but it worked"
                    break
                
init()
