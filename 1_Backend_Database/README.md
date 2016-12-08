#DataAccess 
This text is documenting how we implemented our own locally hosted database. DataAccess is a class written for python 2.7 which connects to an SQLite database upon instantiation and provides the user with a rudimentary API for creating, reading and modifying data within that database file.

##Our Goals
Our goals are two fold. (1) Facilitate inter-group collaboration through efficient documentation (2) Allow other individuals and companies to use our documentation and contact us about further development opportunities.

##Workflow of steps
This workflow outsides the subfolders in our backend database documentation

###step_0:
This folder explains how to update data through specifying rows using datetime objects

###step_1:
This folder explains how to update data through specifying rows using datetime objects

###step_2:
This folder explains how to update data through adding columns in a dictionary format. 

###step_3:
This folder explains how to import the DataAccess API and print the existing column names. 

###step_4:
The user must have a python 2.7.X interpreter installed on their system. A fresh installation of python should contain, by default, all of the modules required to run the dataAccess class. *However, should your particular installation be missing one, they are: sqlite3, datetime, and calendar.

There are several methods contained within the class which provide most of the key functionality of an sql database. Namely, insterting data from a file, updating existing data, retrieving the existing data from the table as a 2D array, and adding columns to the table. 

This class, however, was not implemented purely to serve as an abstraction, but to more concisely store data for a particular project implementation and thus, not all of the functionality of an sqlite engine is included in the implementation of this class.


##Notes
The next step in our project, now that we have a database full of information that we can access and modify quickly and concisely, is to create a web server to transmit our all of our data out over the web to our client-side application.

(Updated: Dec. 8, 2016)
