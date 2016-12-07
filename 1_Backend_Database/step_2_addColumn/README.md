##Step 0: import the dataAccess file and dateTime
from dataAccess import dataAccess as DB

import dateTime as DT

##Step 1: specify the path to the database file that has already been created
dbpath = “Kate.db”

##Step 2: Connect to that database and create an instance of dataAccess
kateDB = DB(“Kate”, dbpath)

##Step 3: Create a dictionary that has the times and values that need to be added to the new column
values = [{\"1463134308\":666},{\"1463186140\":666},{\"1463384662\":666}]}

##Step 4: Call the function by passing a name for the column and the dictionary of values
kateDB.addcolumn('“slope”', values) 

