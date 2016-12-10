#accurate
#add in outofrange count + 4 hr limit
# 5 min

from dataAccess import dataAccess as DB
import datetime as DT
import csv

#path to filled out DB
dbpath = "lab.db"
##Connect to the Database by creating an instance of dataAccess 

katDB = DB("Kate",dbpath)

for patient in [katDB]:
	dat = patient.getData()

gluPredict = []

i = 0
while i < len(dat):

	# if dat[i][3] == None:

	# 	gluPredict.append()
	if dat[i][9] == "INRANGE":
		if dat[i][3] != None:

			bolis = dat[i][3]
			carb = dat[i][4]
			carbRate = dat[i][15]
			basalRate = dat[i][16]
			sens = dat[i][17]
			gluPredict.append(dat[i-1][2])
			
			currentTime = dat[i][1]
			# print z
			# print bolis
			# print carb
			# print carbRate
			# print basalRate
			# print sens


			upwardSlope = ((sens/carbRate) * carb) / (4*60.0) 
			downwardSlope = (- bolis * sens - basalRate * 4 * sens) / (4*60.0)
			i  = i+1

			if dat[i][3] == None:

				upValue1 = round(dat[i-1][2] + ((dat[i][1] - dat[i-1][1]).total_seconds() / 60.0) * upwardSlope)
				upValue2 = round(upValue1 + ((dat[i+1][1] - dat[i][1]).total_seconds() / 60.0) * upwardSlope)
				upValue3 = round(upValue2 + ((dat[i+2][1] - dat[i+1][1]).total_seconds() / 60.0) * upwardSlope)
				i = i+3
				gluPredict.append(upValue1)
				gluPredict.append(upValue2)
				gluPredict.append(upValue3)


				while dat[i][3] == None and i < len(dat) -4 and dat[i+1][9] == "INRANGE" and (dat[i][1] - currentTime).total_seconds() < 15300 :
					newValue = round(dat[i-1][2] + ((dat[i][1] - dat[i-1][1]).total_seconds() / 60.0) * downwardSlope)
					gluPredict.append(newValue)
					i = i+1

		else: 

			newValue = round(dat[i-1][2] - ((dat[i][1] - dat[i-1][1]).total_seconds() / 60.0) * (dat[i][16] * dat[i][17])/60.0 )
			gluPredict.append(newValue)
			i = i+1 
	else:
		gluPredict.append(dat[i][2])
		i = i+1 

print len(gluPredict)
print len(dat)

with open('gluPredict.csv' , 'wb') as csvfile:
	spam = csv.writer(csvfile, delimiter = ',')

	for i in range(0, len(dat)):
		spam.writerow([dat[i][1], gluPredict[i],  dat[i][2]])



