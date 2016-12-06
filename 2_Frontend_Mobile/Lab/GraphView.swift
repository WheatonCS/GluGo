//
//  GraphView.swift
//  Lab
//
//  Created by Alvaro Landaluce on 11/14/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    var startrange:Int   = 0
    var endrange:Int     = 0
    var graphPoints      = [Int]()
    var graphLabels      = [String]()
    var graphActivities  = [String]()
    var graphType:String = ""
    
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        var value:Int  = 0
        var dataPoints = [dataPoint]()
        
        graphPoints = []
        graphLabels = []
        
        let temp   = data()
        dataPoints = (temp?.dataPoints)!
        
        if graphType == "all" {
            var prevYear:String = ""
            var nextYear:String = ""
            for i in startrange..<endrange {
                nextYear = String(dataPoints[i].date.characters.suffix(4))
                if nextYear != prevYear {
                    prevYear = nextYear
                    graphLabels += [nextYear]
                } else {
                    graphLabels += [""]
                }
            }
        } else if graphType == "day" {
            var prevHour:String = ""
            var nextHour:String = ""
            for i in startrange..<endrange {
                nextHour = String(dataPoints[i].time.characters.prefix(2))
                if nextHour != prevHour {
                    prevHour = nextHour
                    graphLabels += [nextHour+":00"]
                } else {
                    graphLabels += [""]
                }
            }
        } else if graphType == "week" {
            var prevDay:String = ""
            var nextDay:String = ""
            let week = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            var count:Int = 0
            
            for i in startrange..<endrange {
                nextDay = dataPoints[i].date
                if nextDay != prevDay {
                    prevDay = nextDay
                    graphLabels += [week[getDayOfWeek(strDate: dataPoints[i].date)-1]]
                    count += 1
                } else {
                    graphLabels += [""]
                }
                
            }
            for i in startrange..<endrange {
                graphLabels += [dataPoints[i].date]
            }
        } else if graphType == "month" {
            var prevDay:String = ""
            var nextDay:String = ""
            var temp:String    = ""
            for i in startrange..<endrange {
                temp = String(dataPoints[i].date.characters.prefix(5))
                nextDay = String(temp.characters.suffix(2))
                if nextDay != prevDay {
                    prevDay = nextDay
                    if nextDay == "01" {
                        graphLabels += ["1st"]
                    } else if nextDay == "02" {
                        graphLabels += ["2nd"]
                    } else {
                        graphLabels += [String(Int(nextDay)!) + "th"]
                    }
                } else {
                    graphLabels += [""]
                }
            }
        } else if graphType == "year" {
            var prevMonth:String = ""
            var nextMonth:String = ""
            let year = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dic"]
            for i in startrange..<endrange {
                nextMonth = String(dataPoints[i].date.characters.prefix(2))
                if nextMonth != prevMonth {
                    prevMonth = nextMonth
                    graphLabels += [year[Int(nextMonth)! - 1]]
                } else {
                    graphLabels += [""]
                }
            }
        }
        
        var sum:Int = 0
        var i:Int   = startrange
        while i < endrange {
            value = Int(dataPoints[i].glucose)!
            graphPoints += [value]
            sum += Int(dataPoints[i].glucose)!
            i += 1
        }
        
        let average:Double = Double(sum)/Double(graphPoints.count)
        let width:CGFloat  = rect.width
        let height:CGFloat = rect.height
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.allCorners,
                                cornerRadii: CGSize(width: Double(5), height: 8.0))
        path.addClip()
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        //calculate the x point
        
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        // calculate the y point
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
        graphPath.move(to: CGPoint(x:columnXPoint(0),y:columnYPoint(graphPoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),y:columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        context!.saveGState()
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(
            x: columnXPoint(graphPoints.count),
            y:height))
        clippingPath.addLine(to: CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        context!.restoreGState()
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 1.0
        graphPath.stroke()
        
        // clear x-axis label and update average value
        for view in self.subviews as [UIView] {
            if let label = view as? UILabel {
                if label.accessibilityIdentifier == "xlabel"  || label.accessibilityIdentifier == "threshold"{
                    label.text = ""
                } else if label.accessibilityIdentifier == "average" {
                    label.text = NSString(format: "%.2f", average) as String
                }
            }
        }
        //Draw the points and the x-axis labels
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 4.0/2
            point.y -= 4.0/2
            
            
            if(graphActivities[i] == "eat") {
                UIColor.green.setFill()
            } else if(graphActivities[i] == "exercise") {
                UIColor.red.setFill()
            } else if(graphActivities[i] == "stress") {
                UIColor.orange.setFill()
            } else if(graphActivities[i] == "sleep") {
                UIColor.blue.setFill()
            } else if(graphActivities[i] == "other") {
                UIColor.black.setFill()
            } else {
                UIColor.white.setFill()
            }
            
            let circle = UIBezierPath(ovalIn:
                CGRect(origin: point,
                       size: CGSize(width: 4.0, height: 4.0)))
            circle.fill()
            
            let label = UILabel(frame: CGRect(x: point.x, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: point.x, y: height-20)
            label.textAlignment = .center
            label.font = label.font.withSize(10)
            label.textColor = UIColor.white
            label.text = graphLabels[i]
            if(graphType == "month") {
                label.transform = CGAffineTransform(rotationAngle: CGFloat(-60.0 * 3.14/180.0))
            }
            label.accessibilityIdentifier = "xlabel"
            super.addSubview(label)
        }
        
        //draw graph key
        drawKeyItem(x:165, y:8, labelText:"eat", color:UIColor.green)
        drawKeyItem(x:165, y:18, labelText:"exercise", color:UIColor.red)
        drawKeyItem(x:218, y:8, labelText:"stress", color:UIColor.orange)
        drawKeyItem(x:218, y:18, labelText:"sleep", color:UIColor.blue)
        drawKeyItem(x:260, y:8, labelText:"other", color:UIColor.black)
        
        //Draw horizontal graph lines
    
        //top line
        drawLine(fromX:margin, fromY:topBorder, toX:width - margin, toY:topBorder)
        //center line
        drawLine(fromX:margin, fromY:graphHeight/2 + topBorder, toX:width - margin, toY:graphHeight/2 + topBorder)
        //bottom line
        drawLine(fromX:margin, fromY:height - bottomBorder, toX:width - margin, toY:height - bottomBorder)
        
        
        var color = UIColor.red
        color.withAlphaComponent(0.3)
        //low threshold
        drawLine(fromX:margin, fromY:columnYPoint(70), toX:width - margin, toY:columnYPoint(70), color:color,width:0.5)
        addLabel(x: margin - 13, y: columnYPoint(70), width: 20, height: 21, text: "70", id: "threshold" , fontSize: 9, fontColor: color)
        color = UIColor.blue
        //high threshold
        drawLine(fromX:margin, fromY:columnYPoint(180), toX:width - margin, toY:columnYPoint(180), color:color,width:0.5)
        addLabel(x: margin - 13, y: columnYPoint(180), width: 20, height: 21, text: "180", id: "threshold" , fontSize: 9, fontColor: UIColor.blue)
    }
    
    func addLabel(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, text:String, id:String, fontSize:Int, fontColor:UIColor, rotationAngle:CGFloat = 0) {
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.center = CGPoint(x: x, y: y)
        label.textAlignment = .right
        label.font = label.font.withSize(CGFloat(fontSize))
        label.textColor = fontColor
        label.accessibilityIdentifier = id
        label.text = text
        if(graphType == "month") {
            label.transform = CGAffineTransform(rotationAngle: CGFloat(-60.0 * 3.14/180.0))
        }
        super.addSubview(label)
    }
    
    func drawLine(fromX:CGFloat,fromY:CGFloat,toX:CGFloat,toY:CGFloat,color:UIColor = UIColor(white: 1.0, alpha: 0.3),width:CGFloat = 1) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x:fromX, y: fromY))
        linePath.addLine(to: CGPoint(x: toX, y: toY))
        
        //let color = color
        let color = color
        color.setStroke()
        
        linePath.lineWidth = width
        linePath.stroke()
    }
    
    func drawKeyItem(x:CGFloat, y:CGFloat, labelText:String, color:UIColor) {
        
        let point = CGPoint(x: x, y: y)
        let circle = UIBezierPath(ovalIn:
            CGRect(origin: point,
                   size: CGSize(width: 5.0, height: 5.0)))
        color.setFill()
        circle.fill()
        let label = UILabel(frame: CGRect(x: point.x, y: point.y, width: 50, height: 21))
        label.center = CGPoint(x: point.x + 33, y: point.y+2)
        label.textAlignment = .left
        label.font = label.font.withSize(10)
        label.text = labelText
        label.accessibilityIdentifier = "key"
        label.textColor = UIColor.white
        super.addSubview(label)
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
}
