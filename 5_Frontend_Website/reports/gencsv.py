#*****************************************************************
# Programmer: Grace Ulinski
# Purpose: 	Read in a csv file containing, among other information, glucose levels and 
#			timestamps, and then plot the glucose levels against time.
# Input: 	None, file name is hardcoded
# Output: 	A png image of the graphed glucose levels
#*****************************************************************
import csv
import datetime
import time
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

#*****************************************************************
# CONSTANTS
#*****************************************************************
DEVICE_ID = "SM43677802"
FILE_NAME = 'kb_G4_June3_July28.csv'

#*****************************************************************
# Purpose: 	Graph the given glucose and time data
# Input: 	None
# Output: 	A png image of the graphed glucose levels
#*****************************************************************

def main():

	allDates = []
	allReadings = []
	allCalDates = []
	allCalReadings = []
	high = 0
	low = 0
	
	with open(FILE_NAME) as csvfile:				#open csv file
		reader = csv.DictReader(csvfile)			
		for row in reader:							#loop through each row
			#convert timestamp to Python datetime object
			date = convertTimestamp(row['Timestamp (YYYY-MM-DD hh:mm:ss)'])	
			reading = row['Glucose Value (mg/dL)']	#get glucose reading
			if(date != None and row['Event Type']== 'EGV'): #if there is a timestamp
				allDates.append(date)				#add date to list of dates
				allReadings.append(reading)		#add glucose reading to list of readings
			else:								#if no timestamp, not graphing data
				if(row['Source Device ID']== DEVICE_ID):	#check if correct device
					if(row['Event Subtype']== "High"):		#get high glucose level	
						high = int(row['Glucose Value (mg/dL)'])
					if(row['Event Subtype']== "Low"):		#get low glucose level
						low = int(row['Glucose Value (mg/dL)'])
	#return lists of dates, readings and high/low glucose levels	
	arrayofdata=[allDates,allReadings]
	with open('mydata.csv', 'w') as mycsvfile:
		thedatawriter = csv.writer(mycsvfile)
		thedatawriter.writerow(("date", "glucose", "high", "low"))
		for i in range(0,len(allDates)):
			thedatawriter.writerow((allDates[i], allReadings[i], 180, 70))			
		
#*****************************************************************
# Purpose:	Convert the timestamp from csv file to Python datetime object
# Input: 	String containing original timestamp
# Output: 	None if there was no timestamp, otherwise a Python datetime object
#*****************************************************************

def convertTimestamp(str):
	list = str.split()		#split into date and time
	if(len(list) != 0):		#check if there was a timestamp
		dateInfo=list[0].split('-')	#split date info
		timeInfo=list[1].split(':') #split time info
		#create datetime object
		d = datetime.datetime(int(dateInfo[0]), int(dateInfo[1]), int(dateInfo[2]), 
			int(timeInfo[0]), int(timeInfo[1]), int(timeInfo[2]))
		return d
	else:
		return None
	
main()