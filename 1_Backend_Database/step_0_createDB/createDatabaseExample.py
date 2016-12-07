from dataAccess import dataAccess as DB
import datetime as dt
import glob
import os.path
import sys

dbpath = "Kate.db"

pidKate = "Kate"
db = DB(pidKate, dbpath)
datapath2= "Kate.csv"
db.insertData(datapath2)

db = DB(pidKate, dbpath)
datapath3 = "Kate2.csv"
db.insertData(datapath3)

print("inserted data")
