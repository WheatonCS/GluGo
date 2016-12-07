from dataAccess import dataAccess as DB
import datetime as DT

#connect to the database
dbpath="lab.db"


#connect to the Database by creating an instance of dataAccess
kateDB = DB("Kate", dbpath)

#datetime would look this this
at = DT.datetime.strptime("2016-06-13 00:04:38","%Y-%m-%d %H:%M:%S")
#valueList would look like this
valueList = {"at": 2413, "carb": 204}

#call the function on the Kate table with new data for the specific row
kateDB.updateRow(at, valueList)
