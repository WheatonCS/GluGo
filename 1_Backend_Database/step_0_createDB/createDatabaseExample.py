from dataAccess import dataAccess as DB
import datetime as dt
import glob
import os.path
import sys

dbpath = "Kate.db"

pidKate = "Kate"
db = DB(pidKate, dbpath)
datapath2= "Kate_G5_Aug8_Aug24_2016.csv"
db.insertData(datapath2)

db = DB(pidKate, dbpath)
datapath3 = "Kate_G5_July_6_Oct_3_2016.csv"
db.insertData(datapath3)

db = DB(pidKate, dbpath)
datapath4 = "Kate_G5_Oct_8_Oct_14.csv"
db.insertData(datapath4)


print("inserted data")
