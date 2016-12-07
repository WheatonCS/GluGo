How to get columns get the column names of your database in 3 easy steps
------------------------------------------------------------------------

####Step 0: Import the apropriate libraries and the dataAccess API
from dataAccess import dataAccess as DB

import datetime as DT

####Step 1: Connect to the Database by creating an instance of dataAccess
Katedb = DB("Kate","Kate.db")

####Step 2: Get and print the column names 
names= Katedb.getColumnNames()

print(names)
