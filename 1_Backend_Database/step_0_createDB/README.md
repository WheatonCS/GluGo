##Step 0: import appropriate libraries
from dataAccess import dataAccess as DB

import datetime as dt

import glob

import os.path

import sys

##Step 1: create database file (if '.db' file does not exist, 'dbpath=' will create one)
dbpath = "Kate.db"

datapath = "Kate_G5_June13_Sept10_2016.csv"

pid = "Kate"

##Step 2: Connect to the Database by creating an instance of dataAccess
db = DB(pid, dbpath)

##Step 3: Insert data into database
db.insertData(datapath)
