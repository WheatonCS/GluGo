###################################################################################
#Name: dataAccess
#
#Purpose: This class provides provides an abstraction of SQLite for accessing the 
#         databased being used in the COMP-298 class Startup v1.0 Machine Learning.
#
#Algorithm: Using python and the sqlite3 library this class attempts to provide
#           functions to operate on a database object that mimic what can be done 
#           directly with SQLite.
#
#Python version: 2.7.11
#SQLite version: 3.15.1
#Operating Systems tested: Ubuntu Linux 14.04
###################################################################################

import calendar as cal
import sqlite3 as db
import datetime as dt

class dataAccess():

################################################################################
#								USER METHODS								   #
#					Functions called from outside of class					   #
################################################################################
	def __init__(self, ident, path):
		self.__pid=ident	#patient ID suffix
		self.__dbpath=path	#database location
		
		conn = db.connect(self.__dbpath) #get a connection to the DB
		self.__cols = self.__getColumns(conn) #get column names
		self.__getNextID(conn)	#get last ID used
		conn.close()

	def __repr__(self):
		return ''.join(["patient_",self.__pid])

	############################################################################
	#PURPOSE: This function takes the given csv file and adds any new data found  
	#         in the file to the database
	#
	#INPUT: This function takes a path to a CGM's csv of recordings in the 
	#       format that we have been working with so far this semester from the 
	#       Dexcom G4 and G5 devices
	#
	#OUTPUT: The Function does not return anything but rather, if the algorithm
	#        successfully found new data then that will be added to the database 
	#        then commited for storage
	#
	#NOTES: Becuse of the limited functionality of SQLite you can add data but
	#       you can not delete data from the database. As such please be sure 
	#       anything you add to the database is in fact what you want to add.
	#       Also be sure to always keep a copy of the origonal database incase
	#       you make a mistake and want to roll back to the origonal database.
	############################################################################
	def insertData(self, path):	
		conn = db.connect(self.__dbpath)
		c = conn.cursor()

		c.execute('''CREATE TABLE IF NOT EXISTS patient_'''+str(self.__pid)+''' (
			id INTEGER NOT NULL,
			at INTEGER PRIMARY KEY NOT NULL,
			gluc INTEGER NOT NULL,
			bolis INTEGER,
			carb INTEGER,
			name TEXT,
			model TEXT,
			evnt TEXT
		);''')

		with open(path) as csv:
			devs={}
			text = csv.read()
			for line in text.splitlines():	
				line=line.split(',')
				if not line[1]:
						if len(devs) == 0:
							devs[line[6]] = line[5];
						else:
							if line[6] not in devs.keys():
								devs[line[6]] = line[5];
				if line[0] != "Index" and line[1] != "":
					try:
						at=dt.datetime.strptime(line[1],"%Y-%m-%d %H:%M:%S")
					except:
						slash = line[1].find('/')
						month = line[1][:slash]
						rest = line[1][slash+1:]
						slash = rest.find('/')
						day = rest[:slash]
						rest = rest[slash+1:]
						slash = rest.find(' ')
						year = rest[:slash]
						rest = rest[slash+1:]
						slash = rest.find(':')
						hour = rest[:slash]
						minute = rest[slash+1:]
						at = dt.datetime(2000+int(year),int(month),int(day),int(hour),int(minute))
					at=self.__convertToUnix(at)
					evnt=line[2]
					model=line[6]
					name=devs[model]
					gluc=int(line[7])
					try:
						c.execute('''INSERT INTO patient_'''+str(self.__pid)+
							''' (id, at, gluc, name, model, evnt) VALUES 
							(?, ?, ?, ?, ?, ?)''',
							(self.__nextID,at,gluc,name,model,evnt))
						self.__nextID+=1
					except db.IntegrityError: 
						pass
		conn.commit()
		c.close()
		conn.close()

	############################################################################
	#PURPOSE: This function gets data from the database based on a user defined 
	#         time frame.
	#
	#INPUT: This function takes two datetime objects; 'start' a datetime object 
	#       indicating the start of the timeframe and 'stop' a datetime object 
	#       indicating the end of the timeframe. This function also takes one 
	#       boolean 'desc' to indicate the order in which to return the data in
	#       the array and two
	#
	#Output: This function returns an array of the data in the time frame
	#        specified by the values of 'start' and 'stop' in the order
	#        specified by the boolean 'desc'.
	#
	#NOTES: If try to use this function on a PID that doesn't have a table yet
	#       this function will throw an SQLite error.
	#		If no value if given for 'start', 'stop', or 'desc' this function
	#       will return all data from the database in ascending order.
	#       If only 'start' is not specified this function will return all
	#       relivant data up to the stop date in ascending order.
	#       If only 'stop' is not specified this function will return all
	#       relivant data starting from the specified start date in ascending
	#       order.
	#       If 'desc' is given the value 'True' this function will return all
	#       relivant data(based on the values of 'start' and 'stop') in
	#       descending order.
	############################################################################
	def getData(self, start = None, stop = None, desc = False, datetimes = True):
		conn = db.connect(self.__dbpath)
		c = conn.cursor()        
		if start == None and stop == None:
			array = c.execute('''SELECT * FROM patient_'''+str(self.__pid)+''' ORDER BY at ASC;''').fetchall()
		elif start == None:
			stop_time = self.__convertToUnix(stop)
			array = c.execute('''SELECT * FROM patient_'''+str(self.__pid)+''' WHERE at < ?
				ORDER BY at ASC;''',(stop_time,)).fetchall()
		elif stop == None:
			start_time = self.__convertToUnix(start)
			array = c.execute('''SELECT * FROM patient_'''+str(self.__pid)+''' WHERE at > ?
				ORDER BY at ASC;''',(start_time,)).fetchall()
		else:
			start_time = self.__convertToUnix(start)
			stop_time = self.__convertToUnix(stop)
			array = c.execute('''SELECT * FROM patient_'''+str(self.__pid)+''' WHERE at
				BETWEEN ? AND ? ORDER BY at ASC;''',(start_time,stop_time)).fetchall()
				#this returns in ascending order, OLD to NEW
		noTup = [ [ self.__convertToDateTime(array[i][j]) if (datetimes and j==1) 
			else array[i][j] for j in range(len(array[i]))] for i in range(len(array))]
		return noTup[::-1] if desc else noTup



	############################################################################
	#PURPOSE: This function adds a new column to the end of the database and
	#         populates it based on a user defined dictionary.
	#
	#INPUT: This function takes a string indicating the name of the new column 
	#       and a dict of datetime objects and data to populate the new column.    
	#
	#OUTPUT: This function does not return anything but rather, it appends a new
	#        column to the end the database and adds the data at the respective
	#		 time as specified in the dict.
	#
	#NOTES: Do to the way this function is written if the new column is to be 
	#       populated with strings each string must contain quotes in it.
	#       For example if your string is "Hello World" you must send it to this 
	#       function in the form ""Hello World"".
	#       Also because of the limited functionality of SQLite you can add data
	#       but you can not delete data from the database. As such please be  
	#       sure anything you add to the database is in fact what you want to
	#       add. Also be sure to always keep a copy of the origonal database 
	#       incase you make a mistake and want to roll back to the origonal 
	#       database.
	############################################################################
	def addColumn(self, colName, vals):
		conn = db.connect(self.__dbpath)
		c = conn.cursor()

		if type(vals[0][vals[0].keys()[0]]) is int:
			c.execute(''.join(['ALTER TABLE patient_',str(self.__pid),' ADD COLUMN ',colName,' INTEGER;']))
		elif type(vals[0][vals[0].keys()[0]]) is float:
			c.execute(''.join(['ALTER TABLE patient_',str(self.__pid),' ADD COLUMN ',colName,' REAL;']))
		elif type(vals[0][vals[0].keys()[0]]) is str:
			c.execute(''.join(['ALTER TABLE patient_',str(self.__pid),' ADD COLUMN ',colName,' TEXT;']))
		else:
			print("ERROR: You entered an invalid type. Please consult the API and try again.")

		for i in range(len(vals)):
			time = vals[i].keys()[0]
			#uTime=self.__convertToUnix(time)
			c.execute(''.join(['UPDATE patient_',str(self.__pid),' SET ',colName,'=',
				str(vals[i][time]),' WHERE at=',str(time),';']))

		conn.commit()
		c.close()
		conn.close()
		self.__cols = self.getColumnNames()

	###########################################################################################
	#PURPOSE: This function updates a cell or cells of a row in the database specified by the
	#         column names and a date and time that corresponds with a date and time in the
	#         'at' column in the database.
	#
	#INPUT: This function takes in one date and time, in the form of a datetime obj or a int, 
	#       that corresponds to the row in the database that is to be updated and one
	#       dictionary of values to update in that row where the key of each value is a column
	#       name into which each value should be placed.
	#
	#OUTPUT: This function does not return a value as output but updates the appropriate row's
	#	     values based on the dictionary that is passed in with the row-date
	#
	#NOTES: If try to use this function on a PID that doesn't have a table yet this function 
	#       will throw an SQLite error.
	#       Also because of the way this function is coded you can also modify the 'at' column.
	###########################################################################################
	def updateRow(self, datetime, valuelist):
		conn = db.connect(self.__dbpath)
		columns = self.__getColumns(conn)
		c = conn.cursor()
		tup = ""
		tuplist = []
		if type(datetime) != int:
			datetime = self.__convertToUnix(datetime)
		if "at" in valuelist:
			if valuelist["at"] is not int:
				valuelist["at"] = self.__convertToUnix(valuelist["at"])
		tup = ''.join([ key+"='"+str(valuelist[key])+"', " if key in valuelist
						 else "" for key in self.__cols ])[:-2]
		#"UPDATE patient_## SET id=## at=##... WHERE at=##;"
		c.execute(''.join(["UPDATE patient_",str(self.__pid)," SET ",tup,
			"WHERE at = ",str(datetime)," ;"]))

		conn.commit()
		c.close()
		conn.close()

    ############################################################################
	#PURPOSE: This function is a getter function that uses the private function
	#         to return the list of the column names in the database for the
	#         user
	#
	#INPUT: None
	#
	#OUTPUT: Returns a list of column names in ascending positional order
	#
	#NOTES: returns a blank list if the table does not exist
	############################################################################
	def getColumnNames(self):
		conn = db.connect(self.__dbpath)
		columns = self.__getColumns(conn)
		conn.close()
		return columns

	############################################################################
	#PURPOSE: This function takes in a 2 dimentional array which exactly matches 
	#	      the size of the database and replaces the existing database  
	#	      contents with that of the array.
	#
	#INPUT: 2D data array which is correctly formated to line up with the 
	#	    columns of the database.
	#
	#OUTPUT: None, stores the matrix and commits the changes.
	#
	#NOTES: If try to use this function on a PID that doesn't have a table yet 
	#       this function will throw an SQLite error.
	############################################################################
	def storeData(self, data):
		if len(data) != self.__nextID-1:
			print("ERROR: dataAccess cannot store matrix: Improper matrix length")
		elif len(data[0]) != len(self.__cols):
			print("ERROR: dataAccess cannot store matrix: Incorrect number of columns")
		else:
			conn = db.connect(self.__dbpath)
			c = conn.cursor()
			noDT = False if type(data[0][1]) is int else True
			#"UPDATE patient_## SET id=## at=##... WHERE at=##;"
			for row in data:
				c.execute(
					''.join(
						[
						"UPDATE patient_",str(self.__pid)," SET ",	

						''.join([self.__cols[i]+"='"+str(row[i])+"', " if i!=1 and noDT 
						else self.__cols[i]+"='"+str(self.__convertToUnix(row[i]))+"', " 
						for i in range(len(self.__cols))])[:-2],

						" WHERE at='", str(row[1]),"'"
						]
					)
				)
		conn.commit()
		c.close()
		conn.close()		


################################################################################
#								PRIVATE METHODS								   #
#				Internal helper functions for class abstraction				   #
################################################################################

	#Returns an integer representing the number of seconds since 1/1/70 @12am
	def __convertToUnix(self,time):
		return cal.timegm(time.utctimetuple())

	#Takes an integer Unix/Posix time and returns an appropriate datetime obj
	def __convertToDateTime(self,time):
		return dt.datetime.utcfromtimestamp(time)

	#takes a connection to the database, returns true if the tablename
	#for self.__pid exists, else returns false
	def __tableExists(self,conn):
		c = conn.cursor()
		c.execute('''SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name=? ;'''
			,("patient_"+str(self.__pid),))

		exists = True if c.fetchone()[0] == 1 else False
		c.close()
		return exists 

	#takes a connection to the database,
	#returns the column names in ascending order (0 to len(row)-1)
	#if the table does not exist returns an empty list
	def __getColumns(self,conn):
		if self.__tableExists(conn):
			c=conn.cursor()
			c.execute('SELECT * FROM patient_'+str(self.__pid)+';')
			cols=[desc[0] for desc in c.description]
			c.close()
			return cols
		else: 
			return []

	#Finds the highest ID currently 
	def __getNextID(self,conn):
		if self.__tableExists(conn):
			c=conn.cursor()
			c.execute('''SELECT id FROM patient_'''+str(self.__pid)+''' ORDER BY id DESC''')

			last = c.fetchall()[0]
			c.close()
			# print "last id found at " + str(last[0])
			self.__nextID = last[0]+1
		else: self.__nextID = 1