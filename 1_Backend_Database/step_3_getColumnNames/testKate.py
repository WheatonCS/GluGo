from dataAccess import dataAccess as DB
import datetime as DT
from random import randint

dbpath="Kate.db"
datapath="Kate.csv"

##Connect to the Database by creating an instance of dataAccess 
Katedb = DB("Kate",dbpath)
print "db connected"

dict1={0: 0}  
dict2={0: '"0"'}
#Here we create two dummy dictionaries to send to the database via addcolumn.
#This will allow dataAccess.py to know what type it should populate the column with. 

##Give the Database the path to a file to read in

Katedb.insertData(datapath)

names= Katedb.getColumnNames()
print names, " Before"

#This is before we add our colums


Katedb.addColumn("randomNums", dict1)
Katedb.addColumn("stringColumn", dict2)
# Add in our two new columns!

data = Katedb.getData()

names= Katedb.getColumnNames()
print names, " After"
# Now you should see what you added.
#Note that since the original db file had coulmns 0-7 in place, we will need to update the values of the newly
# added coulmns 8 and 9
