from flask import Flask, request, session, g, redirect, url_for, \
     abort, render_template, flash, Response, jsonify
from werkzeug.utils import secure_filename
from dataAccess import dataAccess as DB
from enum import Enum
from flask_cors import CORS, cross_origin

# configuration
DATABASE = 'dat.db'
DEBUG = True

#Enumerated type for the Column names
class C(Enum):
	ID = 0
	AT = 1
	GLUC = 2
	BOLIS = 3
	CARB = 4
	NAME = 5
	MODEL = 6
	EVENT = 7

app = Flask(__name__)
app.config.from_object(__name__)
CORS(app)

#Generates json from the table matrix
def makeJsonObj(dat):
	return ''.join(['[',
				''.join([
					#currently only returns AT, GLUC, and EVENT for each row
					(''.join(['{"date": ',str(row[C.AT]),', "gluc": ',str(row[C.GLUC]),', "event": "',row[C.EVENT],'"},'])) for row in dat 
					])[:-1]
			,']'])

#returns True if filename ends in .csv, returns false otherwise
def isCSV(filename):
	return '.' in filename and (filename.rsplit('.',1)[1]).lower() == 'csv'

#Hello World
@app.route('/')
def hello () :
	return Response(response='{"Message": "Hello World"}', status=200, mimetype="application/json")

################################################################################
#PURPOSE: Allows the user to retieve an Upload File form and then if they submit
#	a csv file using said form and then insert that csv into that patient's data
#	table in the database 
#	***if the patient name does not exist in the database it will create a new 
#		table for the patient, be careful. All patient table names are their 
#		respective first names with the first name capitalized
#INPUT: 
#	GET: none
#	POST: see html sample at end of function, request needs to have a 
#		form field marked as 'multipart/form-data' and inside that form should be 
#		an input with name and type equal to 'file' that way when the form is 
#		submitted the request will contain the file 
#OUTPUT: 
#	GET: returns the HTML form to upload a file
#	POST: returns a JSON which either contains a SUCCESS message or an ERROR
################################################################################
@app.route('/<patient>/uploadCSV', methods=['GET','POST'])
def uploadCSV(patient):
	if request.method == 'POST':  #If they are sending a file
		if 'file' not in request.files:	#check to see if there are any files
			return Response(response='{"ERROR":"Missing file in request"}', status=400,mimetype="application/json")
		else:
			file = request.files['file']#get tile
			if file.filename == '':
				return Response(response='{"ERROR":"No selected file in request"}', status=400,mimetype="application/json")
			if file and isCSV(file.filename):
				db = DB(patient,DATABASE)
				db.insertData(file)
				return Response(response='{"SUCCESS":"File was uploaded to the database"}', status=400,mimetype="application/json")
	else: #send back upload form
		return '''
		    <!doctype html>
		    <title>Upload new File</title>
		    <h1>Upload new File</h1>
		    <form action="" method=post enctype=multipart/form-data>
		      <p><input type=file name=file>
		         <input type=submit value=Upload>
		    </form>
		    '''
################################################################################
#PURPOSE: Returns a list of JSON Objects for use by the reports goup. 
#INPUT: None, just make a get request to 
#	http://ADD.RESS.OF.SERV:5000/patient_first_name/getData
#	where patient_first_name is the actual name of the patient you need
#OUTPUT: returns a JSON object containing the following data from each row in 
#	patient's data table
#	FORMAT: [ {'at':----,'gluc':----,'event':----}, 
#			  {'at':----,'gluc':----,'event':----}, ... ]
################################################################################
@app.route('/<patient>/getData')
def getData(patient) :
	db = DB(patient,DATABASE)

	print patient

	try:
		data = db.getData(datetimes=False)
	except:
		return Response(response="{\"ERROR\": \"Invalid PID\"}", status=404, mimetype="application/json")

	print "got the data from DB"

	d = makeJsonObj(data)

	# return jsonify(data)
	return Response(response=d, status=200, mimetype="application/json")

############################################################################
#PURPOSE: This function calls the new column function from the dataAccess
#         class using the data inputted from the Flask server.
#INPUT: This function takes a patient name and Json file taken in from the
#       flask server indicating the name of the new column and data to 
#       populate the new column.    
#OUTPUT: This function does not return anything but rather, it appends a new
#        column to the end the database and adds the data at the respective
#        time as specified in the dict.
#NOTES: Due to the limited functionality of SQLite you can add data but you
#       can not delete data from the database. As such please be sure
#       anything you add to the database is in fact what you want to add.
#       Also be sure to always keep a copy of the origonal database incase
#       you make a mistake and want to roll back to the origonal database.
############################################################################
@app.route('/<patient>/addColumn', methods=['POST'])
def addColumn(patient) :
    db = DB(patient,'dat.db')
    inJsonData = request.json
    dictList = []

    #Sprint(type(inJsonData))

    #inJsonData = inJson.loads(inJson)
    newColName = inJsonData.keys()[0]

    for dictEntry in inJsonData[newColName]:
        key = dictEntry.keys()[0]
        listEntry = {int(key):dictEntry[key]}
        dictList.append(listEntry)

    #print(type(dictList[0]))


    db.addColumn(newColName,dictList)

    R = Response(response='{"SUCCESS":"Column added to the database"}',status=200, mimetype="application/json")
    R.headers["Access-Control-Allow-Origin"] = "http://localhost:5000"
    return R

if __name__ == '__main__':
	app.run(host='0.0.0.0')