# Introduction
This folder contains all the code to produce the 6 different types of charts for visualizing glucose data along with a log in and profile screen.
# Contents of this file
- README.md - this file
- box.js - used to produce the boxplots
- data.csv - parsed data
- data.tsv
- default_avatar.png - image to hold the default usar avatar for the users profile
- gencal.py - this file produces the mycaldata.csv file from kb_G4_June3_July28.csv file with the necessary columns for making the graphs and with the timestamp in a python datetime object
- gencsv.py - this file produces the mydata.csv file from kb_G4_June3_July28.csv file with the necessary columns for making the graphs and with the timestamp in a python datetime object
- kb_G4_June3_July28.csv - a sample csv file with all the data used to produce the graphs
- login.html - webpage that produce a login screen to access an account
- logo5.png - GluGo official logo
- mycaldata.csv - produced from the gencal.py script, contains columns of date (in datetime object form), glucose value, high, and low values
- mydata.csv - only the columns from the kb_G4_June3_July28.csv file that are needed to produce these graphs, ie the date, glucose value, high, and low value, produced from the gencsv.py script.
- newaccount.html - webpage to produce a page to make a new account
- profile.html - webpage to produce a profile page where the user can edit their account info
- report.html - webpage to produce the graphs
- reportstyle.css - style definitions for webpages
- testdata.csv
