//
//  dataPoint.swift
//  Lab
//
//  Created by Alvaro Landaluce on 10/15/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit
class dataPoint:NSObject, NSCoding {
    var glucose:  String
    var date:     String
    var time:     String
    var activity: String
    var notes:    String
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dataPoints")
    
    struct PropertyKey {
        static let glucoseKey  = "glucose"
        static let dateKey     = "date"
        static let timeKey     = "time"
        static let activityKey = "activity"
        static let notesKey    = "notes"
    }
    
    init?(glucose: String, date: String, time: String, activity: String, notes: String) {
        self.glucose  = glucose
        self.date     = date
        self.time     = time
        self.activity = activity
        self.notes    = notes
        
        super.init()
        
        if glucose.isEmpty{
            return nil
        }
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(glucose, forKey: PropertyKey.glucoseKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
        aCoder.encode(time, forKey: PropertyKey.timeKey)
        aCoder.encode(activity, forKey: PropertyKey.activityKey)
        aCoder.encode(notes, forKey: PropertyKey.notesKey)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let glucose  = aDecoder.decodeObject(forKey: PropertyKey.glucoseKey) as! String
        let date     = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as! String
        let time     = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! String
        let activity = aDecoder.decodeObject(forKey: PropertyKey.activityKey) as? String
        let notes    = aDecoder.decodeObject(forKey: PropertyKey.notesKey) as? String
        
        // Must call designated initializer.
        self.init(glucose: glucose, date: date, time: time, activity: activity!, notes: notes!)
    }
}



