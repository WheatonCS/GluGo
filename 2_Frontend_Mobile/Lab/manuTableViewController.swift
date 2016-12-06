//
//  manuTableViewController.swift
//  Lab
//
//  Created by Alvaro Landaluce on 11/14/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

class menuTableViewController: UITableViewController {
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var segmentControl: segmentedControl!
    
    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dataPoints = [dataPoint]()
    var startrange:Int = 0
    var endrange:Int   = 0
    var graphType:String    = ""
    var currentDay:String   = ""
    var currentYear:String  = ""
    var currentMonth:String = ""
    var tempMonth:String    = ""
    var tempDay:String      = ""
    var tempYear:String     = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let temp   = data()
        dataPoints = (temp?.dataPoints)!
        graphType  = "day"
        currentDay = dataPoints[dataPoints.count-1].date
        
        tempMonth = currentMonth
        tempDay   = currentDay
        tempYear  = currentYear
        
        dateLabel.text = tempDay
        
        let range  = setDayRange(day:currentDay)
        startrange = range.startrange
        endrange   = range.endrange
        
        if startrange < endrange {
            graphType = "day"
            setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if endrange < dataPoints.count {
            if graphType == "day" {
                let newDate = changeDate(date:tempDay, day:1)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                dateLabel.text = tempDay
            
                let range  = setDayRange(day: newDate.newDay,dir:1)
                startrange = range.startrange
                endrange   = range.endrange
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else if graphType == "week" {
                let newDate = changeDate(date:tempDay, day:6)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                let range  = setWeekRange(date: tempDay,dir:1)
                startrange = range.startrange
                endrange   = range.endrange
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else if graphType == "month" {
                let newDate = changeDate(date:tempDay, month:1)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                dateLabel.text = tempMonth + "/" + tempYear
                
                let range  = setMonthRange(month: tempMonth,day: tempDay,year: tempYear,dir:1)
                startrange = range.startrange
                endrange   = range.endrange
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else if graphType == "year" {
                let newDate = changeDate(date:tempDay, year:1)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                dateLabel.text = tempYear
                
                let range  = setYearRange(year: tempYear)
                startrange = range.startrange
                endrange   = range.endrange
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            }
        }
    }
    
    @IBAction func prevButton(_ sender: Any) {
        //print(startrange)
        if startrange > 0 {
            if graphType == "day" {
                let newDate = changeDate(date:tempDay, day:-1)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                dateLabel.text = tempDay
                
                let range  = setDayRange(day: newDate.newDay,dir:-1)
                startrange = range.startrange
                endrange   = range.endrange
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else if graphType == "week" {
                let dayOfWeek:Int = getDayOfWeek(strDate: currentDay)
                var temp:Int = 0
                if dayOfWeek == 1 {
                    temp = -1
                } else if dayOfWeek == 2 {
                    temp = -2
                } else if dayOfWeek == 3 {
                    temp = -3
                } else if dayOfWeek == 4 {
                    temp = -4
                } else if dayOfWeek == 5 {
                    temp = -5
                } else if dayOfWeek == 6 {
                    temp = -6
                } else if dayOfWeek == 7 {
                    temp = -7
                }
                let newDate = changeDate(date:tempDay, day:temp)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                let range  = setWeekRange(date: tempDay,dir:-1)
                if range.startrange != 0 && range.endrange != 0 {
                    startrange = range.startrange
                    endrange   = range.endrange
                }
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else if graphType == "month" {
                let newDate = changeDate(date:tempDay, month:-1)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                let range  = setMonthRange(month: tempMonth,day: tempDay,year: tempYear,dir:-1)
                startrange = range.startrange
                endrange   = range.endrange
                
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else if graphType == "year" {
                let newDate = changeDate(date:tempDay, year:-1)
                tempMonth = newDate.newMonth
                tempDay   = newDate.newDay
                tempYear  = newDate.newYear
                
                dateLabel.text = tempYear
                
                let range  = setYearRange(year: tempYear)
                startrange = range.startrange
                endrange   = range.endrange
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            }
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        let date:String = dataPoints[dataPoints.count-1].date
        
        let temp = splitDate(date: date)
        currentMonth   = temp.month
        let dayOfMonth = temp.day
        currentYear    = temp.year
        currentDay     = currentMonth + "/" + dayOfMonth + "/" + currentYear
        
        tempMonth = currentMonth
        tempDay   = currentDay
        tempYear  = currentYear
        
        if(segmentControl.selectedSegmentIndex == 0)
        {
            let range  = setDayRange(day:currentDay)
            startrange = range.startrange
            endrange   = range.endrange
            
            dateLabel.text = tempDay
            
            if startrange < endrange {
                graphType = "day"
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else {
                segmentControl.selectedSegmentIndex = 0
            }
        }
        else if(segmentControl.selectedSegmentIndex == 1) {
            let range  = setWeekRange(date:currentDay,firstTime:1)
            startrange = range.startrange
            endrange   = range.endrange
            
            dateLabel.text = ""
        
            if startrange < endrange {
                graphType = "week"
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else {
                segmentControl.selectedSegmentIndex = 0
            }
        }
        else if(segmentControl.selectedSegmentIndex == 2) {
            let range  = setMonthRange(month:currentMonth, day:currentDay, year:currentYear)
            startrange = range.startrange
            endrange   = range.endrange
            
            dateLabel.text = tempMonth + "/" + tempYear
            
            if startrange < endrange {
                graphType = "month"
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else {
                segmentControl.selectedSegmentIndex = 0
            }
        }
        else if(segmentControl.selectedSegmentIndex == 3) {
            let range  = setYearRange(year:currentYear)
            startrange = range.startrange
            endrange   = range.endrange
            
            dateLabel.text = currentYear
            
            if startrange < endrange {
                graphType = "year"
                setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
            } else {
                segmentControl.selectedSegmentIndex = 0
            }
        } else if(segmentControl.selectedSegmentIndex == 4) {
            let startDate = splitDate(date: dataPoints[0].date)
            let endDate  = splitDate(date: dataPoints[dataPoints.count-1].date)
            let startYear:String = startDate.year
            let endYear:String   = endDate.year
            
            if startYear != endYear {
                dateLabel.text = startYear + "-" + endYear
            } else {
                dateLabel.text = startYear
            }
            startrange = 0
            endrange   = dataPoints.count
            graphType  = "all"
            setupGraphDisplay(startrange: startrange,endrange: endrange,graphType: graphType)
        }
    }
    
    func setDayRange(day:String, dir:Int = 0) ->(startrange:Int, endrange:Int) {
                   //day: mm/dd/yyyy
        var startrange:Int = 0
        var endrange:Int   = 0
        var found:Int      = 0
        var count:Int      = 0
        for point in dataPoints {
            if point.date == day && found == 0  {
                startrange = count
                found = 1
            } else if found == 1 && point.date != day {
                endrange = count
                found = 0
            }
            count += 1
        }
        if endrange < startrange {
            endrange = dataPoints.count
        } else if startrange == 0 && endrange == 0 && dir < 0 {
            let newDate = changeDate(date:day, day:-1)
            tempMonth = newDate.newMonth
            tempDay   = newDate.newDay
            tempYear  = newDate.newYear
            let result = setDayRange(day: tempDay,dir:-1)
            startrange = result.startrange
            endrange = result.endrange
        } else if startrange == 0 && endrange == 0 && dir > 0 {
            let newDate = changeDate(date:day, day:1)
            tempMonth = newDate.newMonth
            tempDay   = newDate.newDay
            tempYear  = newDate.newYear
            let result = setDayRange(day: tempDay,dir:1)
            startrange = result.startrange
            endrange = result.endrange
        }
        return (startrange, endrange)
    }
    
    func setWeekRange(date:String, dir:Int = 0,firstTime:Int = 0) ->(startrange:Int, endrange:Int) {
                    //day: mm/dd/yyyy
        if String(date.characters.suffix(4)) < String(dataPoints[0].date.characters.suffix(4)) {
            print("done")
            return (0, 0)
        }
        var startrange:Int = 0
        var endrange:Int   = 0
        var found:Int      = 0
        var count:Int      = 0
        
        var startDate:String = "" //first day of the week
        var endDate:String = ""   //last day of the week
        let dayOfWeek:Int = getDayOfWeek(strDate: date)
        if firstTime == 1 && dir <= 0 {
            if dayOfWeek == 1 {
                let temp = changeDate(date: date,day:0)
                startDate = temp.newDay
                endDate   = date
            } else if dayOfWeek == 2 {
                let temp = changeDate(date: date,day:-1)
                startDate = temp.newDay
                endDate   = date
            } else if dayOfWeek == 3 {
                let temp = changeDate(date: date,day:-2)
                startDate = temp.newDay
                endDate   = date
            } else if dayOfWeek == 4 {
                let temp = changeDate(date: date,day:-3)
                startDate = temp.newDay
                endDate   = date
            } else if dayOfWeek == 5 {
                let temp = changeDate(date: date,day:-4)
                startDate = temp.newDay
                endDate   = date
            } else if dayOfWeek == 6 {
                let temp = changeDate(date: date,day:-5)
                startDate = temp.newDay
                endDate   = date
            } else if dayOfWeek == 7 {
                let temp = changeDate(date: date,day:-6)
                startDate = temp.newDay
                endDate   = date
            }
            
        
        } else {
            if dir <= 0 {
                    let temp = changeDate(date: date,day:-6)
                    startDate = temp.newDay
                    endDate   = date
            } else if dir > 0 {
                    let temp = changeDate(date: date,day:6)
                    startDate = date
                    endDate   = temp.newDay
            }
        }
        for point in dataPoints {
            if point.date >= startDate && point.date <= endDate && found == 0  {
                startrange = count
                found = 1
            } else if found == 1 && (point.date < startDate || point.date > endDate){
                endrange = count
                found = 0
            }
            count += 1
        }
        if endrange < startrange {
            endrange = dataPoints.count
        } else if startrange == 0 && endrange == 0 && dir < 0 {
            let newDate = changeDate(date:date, day:-7)
            tempMonth = newDate.newMonth
            tempDay   = newDate.newDay
            tempYear  = newDate.newYear
            let result = setWeekRange(date: tempDay,dir:-1)
            startrange = result.startrange
            endrange = result.endrange
        } else if startrange == 0 && endrange == 0 && dir > 0 {
            let newDate = changeDate(date:date, day:7)
            tempMonth = newDate.newMonth
            tempDay   = newDate.newDay
            tempYear  = newDate.newYear
            let result = setWeekRange(date: tempDay,dir:1)
            startrange = result.startrange
            endrange   = result.endrange
        }
        return (startrange, endrange)
    }
    
    func setMonthRange(month:String, day:String, year:String,dir:Int = 0) ->(startrange:Int, endrange:Int) {
                     //month:mm, day:mm/dd/yyyy, year:yyyy
        var startrange:Int = 0
        var endrange:Int   = 0
        var found:Int      = 0
        var count:Int      = 0
       
        for point in dataPoints {
            if String(point.date.characters.suffix(4)) == year &&
               Int(String(point.date.characters.prefix(2))) == Int(month) && found == 0  {
                startrange = count
                found = 1
            } else if found == 1 && (String(point.date.characters.suffix(4)) != year ||
                                     Int(String(point.date.characters.prefix(2))) != Int(month)) {
                endrange = count
                found = 0
            }
            count += 1
        }
        
        if endrange < startrange {
            endrange = dataPoints.count
        } else if startrange == 0 && endrange == 0 && dir < 0 {
            let newDate = changeDate(date:day, month:-1)
            tempMonth = newDate.newMonth
            tempDay   = newDate.newDay
            tempYear  = newDate.newYear
            let result = setMonthRange(month: tempMonth,day: tempDay,year: tempYear,dir:-1)
            startrange = result.startrange
            endrange = result.endrange
        } else if startrange == 0 && endrange == 0 && dir > 0 {
            let newDate = changeDate(date:day, month:1)
            tempMonth = newDate.newMonth
            tempDay   = newDate.newDay
            tempYear  = newDate.newYear
            let result = setMonthRange(month: tempMonth,day: tempDay,year: tempYear,dir:1)
            startrange = result.startrange
            endrange   = result.endrange
        } else {
            if Int(tempMonth)! < 10 {
                dateLabel.text = "0" + tempMonth + "/" + tempYear
            } else {
                dateLabel.text = tempMonth + "/" + tempYear
            }
        }
        return (startrange, endrange)
    }
    
    func setYearRange(year:String) ->(startrange:Int, endrange:Int) {
                    //year: yyyy
        var startrange:Int = 0
        var endrange:Int   = 0
        var found:Int      = 0
        var count:Int      = 0
        
        for point in dataPoints {
            if String(point.date.characters.suffix(4)) == year && found == 0  {
                startrange = count
                found = 1
            } else if found == 1 && String(point.date.characters.suffix(4)) != year {
                endrange = count
                found = 0
            }
            count += 1
        }
        if found == 1 {
            endrange = dataPoints.count
        }
        if endrange < startrange {
            endrange = dataPoints.count
        }
        return (startrange, endrange)
    }
    
    // adds or subtracts months, days or years form the given date
    // usage:
    //      add/subtract n months: changeDate(date:date,month:n) / changeDate(date:date,month:-n)
    //      add/subtract n days:   changeDate(date:date,day:n)   / changeDate(date:date,day:-n)
    //      add/subtract n years:  changeDate(date:date,year:n)  / changeDate(date:date,year:-n)
    func changeDate(date:String, month:Int = 0, day:Int = 0, year:Int = 0) -> (newMonth:String, newDay:String,newYear:String){
                  //date:mm/dd/yyyy
    
        let temp = splitDate(date: date)
        let oldMonth:String = temp.month
        let oldDay:String   = temp.day
        let oldYear:String  = temp.year
        
        var newYear:Int  = Int(oldYear)! + Int(year)
        var newMonth:Int = Int(oldMonth)! + Int(month)
        var newDay:Int   = Int(oldDay)! + Int(day)
        
        if month > 0 || day > 0 || year > 0 {
            if newDay > 31 && (newMonth == 1 || newMonth == 3 || newMonth == 5  ||
                               newMonth == 7 || newMonth == 8 || newMonth == 10 || newMonth == 12){
                newMonth += 1
                newDay   -= 31
                while(newMonth > 12) {
                    newYear  += 1
                    newMonth -= 12
                }
            } else if newDay > 28 && newMonth == 2 {
                newMonth += 1
                newDay   -= 28
                while(newMonth > 12) {
                    newYear += 1
                newMonth    -= 12
                }
            } else if newDay > 30{
                newMonth += 1
                newDay   -= 30
                while(newMonth > 12) {
                    newYear  += 1
                    newMonth -= 12
                }
            }
        }
        
        while newDay < 1 {
            if newMonth == 1 || newMonth == 3 || newMonth == 5  ||
               newMonth == 7 || newMonth == 8 || newMonth == 10 || newMonth == 12 {
                newMonth -= 1
                newDay   += 31
            } else if newDay > 28 && newMonth == 2 {
                newMonth -= 1
                newDay   += 28
            } else if newMonth != 0{
                newMonth -= 1
                newDay   += 30
            }
        }
        while(newMonth > 12) {
            newYear  += 1
            newMonth -= 12
        }
        while(newMonth < 1) {
            newYear  -= 1
            newMonth += 12
        }
        
        var newDate:String = ""
        if(newDay < 10 && newMonth > 9) {
            newDate = String(newMonth) + "/0" + String(newDay) + "/" + String(newYear)
        } else if(newDay < 10 && newMonth < 10) {
            newDate = "0" + String(newMonth) + "/0" + String(newDay) + "/" + String(newYear)
        } else if(newDay > 9 && newMonth < 10) {
            newDate = "0" + String(newMonth) + "/" + String(newDay) + "/" + String(newYear)
        } else {
            newDate = String(newMonth) + "/" + String(newDay) + "/" + String(newYear)
        }
        
        return (String(newMonth),newDate,String(newYear))
    }
    
    func splitDate(date:String) -> (month:String, day:String, year:String) {
        let strMonth:String = date.substring(to: date.index(date.startIndex, offsetBy: 2))
        var temp:String = date.substring(from: date.index(date.startIndex, offsetBy: 2))
        temp = temp.substring(from: date.index(date.startIndex , offsetBy: 1))
        let strDay:String = temp.substring(to: date.index(date.startIndex , offsetBy: 2))
        temp = temp.substring(from: date.index(date.startIndex , offsetBy: 2))
        temp = temp.substring(from: date.index(date.startIndex , offsetBy: 1))
        let strYear:String = temp.substring(to: date.index(date.startIndex , offsetBy: 4))
        return(strMonth,strDay,strYear)
    }
    
    func getDayOfWeek(strDate:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let date = formatter.date(from: strDate)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: date)
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGraphDisplay(startrange:Int,endrange:Int,graphType:String) {
        var graphActivities = [String]()
        var max:Int = 0
        for i in startrange..<endrange {
            if(Int(dataPoints[i].glucose)! > max) {
                max = Int(dataPoints[i].glucose)!
            }
            graphActivities += [dataPoints[i].activity]
            
        }
        maxLabel.text        = String(max)
        graphView.endrange   = endrange
        graphView.startrange = startrange
        graphView.graphType  = graphType
        graphView.graphActivities = graphActivities
        graphView.setNeedsDisplay()
    }
}
