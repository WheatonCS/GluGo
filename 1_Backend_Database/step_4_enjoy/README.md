CONTENT OF THIS FILE:
-------------------------------------------------------------------------------

-README.md - this file

-dataAccess.py

-flaskServer.py

-demo.html

-jquery.min.js


INTRODUCTION:
--------------------------------------------------------------------------------
DataAccess is a class written for python 2.7 which connects to an SQLite 
database upon instantiation and provides the user with a rudimentary API for 
creating, reading and modifying data within that database file. 

In order to use the dataAccess class, the user must first have a python 2.7.X 
interpreter installed on their system.  A fresh installation of python should 
contain, by default, all of the modules required to run the dataAccess class. 
*However, should your particular installation be missing one, they are: sqlite3,
datetime, and calendar. 

After instantiating the dataAccess class by giving it the name of a database 
file and a table name to modify by calling the constructor, there are several 
methods contained within the class which provide most of the key functionality
of an sql database. Namely, insterting data from a file, updating existing data,
retrieving the existing data from the table as a 2D array, and adding columns to
the table.  This class, however, was not implemented purely to serve as an 
abstraction, but to more concisely store data for a particular project 
implementation and thus, not all of the functionality of an sqlite engine is 
included in the implementation of this class. 


CURRENTLY IN DEVELOPMENT:
--------------------------------------------------------------------------------
The next step in our project, now that we have a database full of information
that we can access and modify quickly and concisely, is to create a web server 
to transmit our all of our data out over the web to our client-side application.

To do this we again looked to python 2.7 as our language of choice and chose
Flask, a web micro-framework to help us create our server application to receive
and respond to http requests.  To install Flask into your existing python 
interpreter along with two other assisting modules
	
	...$ pip install flask flask_cors enum

and you should then be ready to launch our server like any other python source.

	...$ python flaskServer.py
	
*provided that dataAccess.py and your DB file are also in the same directory

The server is currently configured to run on all outgoing IP addresses 
(including both public IP and loopback) on port 5000.  The goal is to eventually
make all of the functionality of our dataAccess class available over the web, 
but as of right now the only piece that is working is the getData method. To see 
this in action, run the server using your prefered method, then in a web browser
navigate to 
	
	http://localhost:5000/<desiredTableName>/getData

to view the data contained in the DB under that table name.  The web server, to 
be more useful to web development, recieves and returns data as a JSON object 
instead of a plain 2D array or raw data.
