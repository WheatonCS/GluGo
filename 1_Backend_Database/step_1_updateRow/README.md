##Step 0: import the dataAccess file and dateTime
from dataAccess import dataAccess as DB

import datetime as DT

##Step 1: specify the path to the database file that has already been created
dbpath="lab.db"

##Step 2: Connect to the Database by creating an instance of dataAccess
kateDB = DB("Kate", dbpath)

##Step 3: Datetime would look this this
at = DT.datetime.strptime("2016-06-13 00:04:38","%Y-%m-%d %H:%M:%S")

##Step 4: ValueList would look like this
valueList = {"at": 2413, "carb": 204}

##Step 5: Call the function on the Kate table with new data for the specific row
kateDB.updateRow(at, valueList)
