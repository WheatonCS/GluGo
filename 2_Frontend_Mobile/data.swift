//
//  dataPoints.swift
//  Lab
//
//  Created by Alvaro Landaluce on 11/27/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

class data {
    var dataPoints = [dataPoint]()
    
    init?(save:Int = 0) {
        if let saveddataPoints = loadDataPoints() {
            
            dataPoints += saveddataPoints
        } else {
            loadSampleDataPoints()
            //loadSampleDataPointsOLD()
        }
        saveDataPoints()
    }
    func loadSampleDataPointsOLD() {
        let dataPoint1 = dataPoint(glucose: "115", date: "09/25/2015", time: "14:05", activity: "", notes: "")!
        let dataPoint2 = dataPoint(glucose: "120", date: "09/25/2015", time: "15:05", activity: "", notes: "")!
        let dataPoint3 = dataPoint(glucose: "50", date: "09/25/2015", time: "14:10", activity: "", notes: "")!
        let dataPoint4 = dataPoint(glucose: "63", date: "09/25/2015", time: "13:00", activity: "", notes: "")!
        let dataPoint5 = dataPoint(glucose: "117", date: "09/25/2015", time: "14:15", activity: "", notes: "")!
        let dataPoint6 = dataPoint(glucose: "127", date: "09/25/2015", time: "14:15", activity: "", notes: "")!
        let dataPoint7 = dataPoint(glucose: "120", date: "10/25/2015", time: "14:20", activity: "", notes: "")!
        let dataPoint8 = dataPoint(glucose: "140", date: "10/25/2015", time: "14:20", activity: "", notes: "")!
        let dataPoint9 = dataPoint(glucose: "125", date: "11/12/2015", time: "19:25", activity: "", notes: "")!
        let dataPoint10 = dataPoint(glucose: "155", date: "11/12/2015", time: "19:25", activity: "", notes: "")!
        let dataPoint11 = dataPoint(glucose: "172", date: "01/13/2016", time: "19:30", activity: "", notes: "")!
        let dataPoint12 = dataPoint(glucose: "122", date: "01/13/2016", time: "19:30", activity: "", notes: "")!
        let dataPoint13 = dataPoint(glucose: "200", date: "02/12/2016", time: "19:35", activity: "", notes: "")!
        let dataPoint14 = dataPoint(glucose: "120", date: "02/12/2016", time: "19:35", activity: "", notes: "")!
        let dataPoint15 = dataPoint(glucose: "109", date: "03/11/2016", time: "19:40", activity: "", notes: "")!
        let dataPoint16 = dataPoint(glucose: "78", date: "03/11/2016", time: "19:40", activity: "", notes: "")!
        let dataPoint17 = dataPoint(glucose: "89", date: "04/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint18 = dataPoint(glucose: "99", date: "04/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint19 = dataPoint(glucose: "100", date: "05/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint20 = dataPoint(glucose: "82", date: "05/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint21 = dataPoint(glucose: "89", date: "06/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint22 = dataPoint(glucose: "63", date: "06/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint23 = dataPoint(glucose: "100", date: "07/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint24 = dataPoint(glucose: "70", date: "07/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint25 = dataPoint(glucose: "89", date: "08/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint26 = dataPoint(glucose: "78", date: "08/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint27 = dataPoint(glucose: "100", date: "09/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint28 = dataPoint(glucose: "100", date: "09/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint29 = dataPoint(glucose: "89", date: "10/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint30 = dataPoint(glucose: "93", date: "10/12/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint31 = dataPoint(glucose: "150", date: "11/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint32 = dataPoint(glucose: "50", date: "11/12/2016", time: "19:50", activity: "", notes: "")!
        let dataPoint33 = dataPoint(glucose: "89", date: "12/01/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint34 = dataPoint(glucose: "32", date: "12/02/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint35 = dataPoint(glucose: "58", date: "12/03/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint36 = dataPoint(glucose: "76", date: "12/04/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint37 = dataPoint(glucose: "97", date: "12/05/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint38 = dataPoint(glucose: "86", date: "12/06/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint39 = dataPoint(glucose: "150", date: "12/07/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint40 = dataPoint(glucose: "133", date: "12/08/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint41 = dataPoint(glucose: "117", date: "12/09/2016", time: "19:45", activity: "", notes: "")!
        let dataPoint42 = dataPoint(glucose: "89", date: "12/10/2016", time: "8:45", activity: "", notes: "")!
        let dataPoint43 = dataPoint(glucose: "89", date: "12/10/2016", time: "12:45", activity: "", notes: "")!
        dataPoints += [dataPoint1, dataPoint2, dataPoint3, dataPoint4, dataPoint5, dataPoint6, dataPoint7, dataPoint8, dataPoint9, dataPoint10, dataPoint11, dataPoint12, dataPoint13, dataPoint14, dataPoint15, dataPoint16, dataPoint17, dataPoint18, dataPoint19, dataPoint20, dataPoint21, dataPoint22, dataPoint23, dataPoint24, dataPoint25, dataPoint26, dataPoint27, dataPoint28, dataPoint29, dataPoint30, dataPoint31, dataPoint32, dataPoint33, dataPoint34, dataPoint35, dataPoint36, dataPoint37, dataPoint38, dataPoint39, dataPoint40, dataPoint41, dataPoint42, dataPoint43]
    }
    func loadSampleDataPoints() {
        dataPoints = [dataPoint]()
        let years:Int = 2 //number of year of data starting at startYear
        let monthsPerYear:Int = 2
        
        for year in 0...(years-1) {
            for month in 1...monthsPerYear {
                if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12{
                    for day in 1...31 {
                        addDataPoint(month: month, day: day, year: year)
                    }
                } else if month == 2 {
                    for day in 1...28 {
                        addDataPoint(month: month, day: day, year: year)
                    }
                } else {
                    for day in 1...30 {
                        addDataPoint(month: month, day: day, year: year)
                    }
                }
            }
        }
    }
    
    func addDataPoint(month:Int, day:Int, year:Int) {
        let startYear:Int         = 2015
        let hoursPerDay:Int       = 2
        let dataPointsPerHour:Int = 2
        
        var strMonth:String  = ""
        var strDay:String    = ""
        let strYear:String   = String(startYear + year)
        var strHour:String   = ""
        var strMinute:String = ""
        
        if month < 10 {
            strMonth = "0" + String(month)
        } else {
            strMonth = String(month)
        }
        if day < 10 {
            strDay = "0" + String(day)
        } else {
            strDay = String(day)
        }
        for hour in 0...(hoursPerDay){
            if hour*(24/hoursPerDay) < 10 {
                strHour = "0" + String(hour*(24/hoursPerDay))
            } else {
                strHour = String(hour*(24/hoursPerDay))
            }
            for minute in 0...(dataPointsPerHour-1) {
                if minute*(60/dataPointsPerHour) < 10 {
                    strMinute = "0" + String(minute*(60/dataPointsPerHour))
                } else {
                    strMinute = String(minute*(60/dataPointsPerHour))
                }
                let randomGlucoseVal = arc4random_uniform(150) + 50;
                let date:String = strMonth + "/" + strDay + "/" + strYear
                let time:String = strHour + ":" + strMinute
                let point = dataPoint(glucose: String(randomGlucoseVal), date: date, time: time, activity: "", notes: "")!
                dataPoints += [point]
            }
        }
    }
    
    func saveDataPoints() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dataPoints, toFile: dataPoint.ArchiveURL.path)
    
        if !isSuccessfulSave {
            print("Failed to save...")
        }
    }
    
    func loadDataPoints() -> [dataPoint]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: dataPoint.ArchiveURL.path) as? [dataPoint]
    }
}
