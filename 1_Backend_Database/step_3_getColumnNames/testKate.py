from dataAccess import dataAccess as DB
import datetime as DT
from random import randint

dbpath="Kate.db"

##Connect to the Database by creating an instance of dataAccess 
Katedb = DB("Kate",dbpath)
print "db connected"

dict1={0: 0}  
dict2={0: '"0"'}
#Here we create two dummy dictionaries to send to the database via addcolumn.
#This will allow dataAccess.py to know what type it should populate the column with. 

names= Katedb.getColumnNames()
print " Before: ", names

#This is before we add our colums


Katedb.addColumn("randomNums", dict1)
Katedb.addColumn("stringColumn", dict2)
# Add in our two new columns!

names= Katedb.getColumnNames()
print "After: ", names
# Now you should see the names of the columns you added.
