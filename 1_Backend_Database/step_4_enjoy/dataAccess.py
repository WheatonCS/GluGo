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
	#This function takes the given csv file and adds any new data found in the 
	#  file to the database
	#Input: This function takes a path to a CGM's csv of recordings in the 
	#  format that we have been working with so fat this semester from the 
	#  Dexcom G4 and G5 devices
	#Output: The Function does not return anything but rather, if the algorithm
	#  successfully found new data then that will be added to the database and 
	#  then commited for storage
	def insertData(self, file):	
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
		
		if type(file) == str:	#checks to see if the file is a path of file
			with open(file) as csv:
				self.insertHelper(c,csv)
		else: self.insertHelper(c,file)
			
		conn.commit()
		c.close()
		conn.close()

	#continuation of the functionality of insert data
	def insertHelper(self,c,csv):
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

	############################################################################
	#This function is to get data from the database based on a user defined time
	#  frame
	#Input: two datetime objects (start, stop) and one boolean (desc) to 
	#  indicate order to return array in
	#Output: if desc == false, returns array in OLD to NEW order, else in NEW to
	#  OLD
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
	#PreCondition: Function needs a string column name and 
	#				dict of datetime objects and data 
	#				for the new column.
	#PostCondition: Function appends a column to the end 
	#				the database and adds the data at the 
	#				 respective time as specified in the dict
	def addColumn(self, colName, vals):
		conn = db.connect(self.__dbpath)
		c = conn.cursor()

		if type(vals[vals.keys()[0]]) is int:
			c.execute(''.join(['ALTER TABLE patient_',str(self.__pid),' ADD COLUMN ',colName,' INTEGER;']))
		elif type(vals[vals.keys()[0]]) is float:
			c.execute(''.join(['ALTER TABLE patient_',str(self.__pid),' ADD COLUMN ',colName,' REAL;']))
		elif type(vals[vals.keys()[0]]) is str:
			c.execute(''.join(['ALTER TABLE patient_',str(self.__pid),' ADD COLUMN ',colName,' TEXT;']))
		else:
			print("ERROR: You entered an invalid type. Please consult the API and try again.")

		isUTC=False

		for time in vals.keys():
			if(isUTC or (type(time) is not int)):
				uTime=self.__convertToUnix(time)
				isUTC=True
			else: 
				uTime= time
			c.execute(''.join(['UPDATE patient_',str(self.__pid),' SET ',colName,'=',
				str(vals[time]),' WHERE at=',str(uTime),';']))

		conn.commit()
		c.close()
		conn.close()
		self.__cols = self.getColumnNames()

	###########################################################################################
	#This function changes the specified column names in a single table row with at = datetime (obj or int)
	#Input: This function takes in datetime = the time object corresponding to that row in the 
	#   table and a dictionary of values to update in that row where the key of each value is
	#   column name into which it should be placed
	#   *Note, this means you can also modify the at column.
	#Ouput: This function does not return a value as output but updates the appropriate row's
	#	values based on the dictionary that is passed in with the row-date
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
	#This function returns a list of the column names of the table as per the 
	#specifications of self.getColumns
	#Input: None
	#Output: Returns a list of column names in ascending positional order, returns 
	#   a blank list if the table does not exist
	def getColumnNames(self):
		conn = db.connect(self.__dbpath)
		columns = self.__getColumns(conn)
		conn.close()
		return columns

	############################################################################
	#This function takes in a 2 dimentional array which exactly matches the size
	#	of the database and replaces the existing database contents with that of 
	#	the array
	#Input: 2D data array which is correctly formated to line up with the columns
	#	of the database
	#Output: None, stores the matrix and commits the changes
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