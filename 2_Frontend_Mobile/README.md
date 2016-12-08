# GluGo iOS App

This is an app meant for working with the GluGo system, which functions on standard iOS devices. This directory contains the following:

#### GluGo.xcodeproj
This is the XCode project file for the entire app, which can be used to access all of the other files in a simplified manner.

#### Data.swift
This file loads in the data points for use in the app demo, as well as generates x-values for how they are displayed on the graph portion of the program.

#### Datapoint.swift
This file declares the class which is used for storing the datapoints, which is used throughout the app.

#### LabTests
A directory used by XCode for app testing, but will appear empty otherwise.

#### LabUITests
Another directory used by XCode for app testing, but will also appear empty otherwise.

## Lab
A directory which contains many of the swift files. These files include:

#### AppDelegate.swift
One of the source code files for XCode projects.

#### Assets.xcassets
Directory containing various images and icons for rendering the app with logos.

#### Base.lproj
Directory containing two storyboard files for use with the XCode file, a main storyboard(for the majority of the app) and one for the launch screen.

#### dataPointTableViewCell.swift
Sets values and text for datapoints in the "Add Activity" menu.

#### dataPointTableViewController.swift
Shows cells in the "Add Activity" menu, as well as sets the text color for each cell to accurately show the marked event associated with that datapoint. Also handles some of the transitions to the event assignment page.

#### dataPointViewController.swift
View Controller for the activity addition screen.

#### GraphView.swift
Renders the actual graph as it appears in the main screen of the app. Finds datapoints and timeframe, then proceeds to draw points and lines to match everything up.

#### Info.plist
Settings file for the XCode rendering of the app.

#### loginViewController.swift
View Controller for the login screen.

#### manuTableViewController.swift
View Controller for the main screen of the app.

#### rangeViewController.swift
View Controller for timerange selector.

#### segmentedControl.swift
segmented control class, no code added yet.


