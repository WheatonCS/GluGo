from dataAccess import dataAccess as DB
import dateTime as DT

#path to filled out Database that has already been created with patient information from the provided CSVs
dbpath = “Kate.db”

#connect to the Database by creating an instance of dataAccess
kateDB = DB(“Kate”, dbpath)

#values dictionary would look like this
values = [{\"1463134308\":666},{\"1463186140\":666},{\"1463384662\":666}]}

#call the function on the Melissa table to create a new column
kateDB.addcolumn(““slope””, values) 
