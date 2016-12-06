//
//  dataPointViewController.swift
//  Lab
//
//  Created by Alvaro Landaluce on 10/15/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

class dataPointViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    //make delegate to be able to handle user input
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    let pickerData:Array = ["eat","exercise","stress","sleep","other"]
    var datapoint: dataPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesField.delegate   = self
        pickerView.dataSource = self
        pickerView.delegate   = self
        
        valueLabel.text = datapoint?.glucose
        dateLabel.text  = datapoint?.date
        timeLabel.text  = datapoint?.time
        
        if datapoint?.notes != "" {
            notesField.text  = datapoint?.notes
        } else {
            notesField.text  = ""
        }
        if datapoint?.activity != "" {
            typeLabel.text = datapoint?.activity
        } else {
            typeLabel.text = pickerData[0]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let glucose:String  = valueLabel.text!
        let date:String     = dateLabel.text!
        let time:String     = timeLabel.text!
        let activity:String = typeLabel.text!
        let notes:String    = notesField.text
        
        // Set the dataPoint to be passed to dataPointTableViewController after the unwind segue.
        datapoint = dataPoint(glucose: glucose, date: date, time: time, activity: activity, notes: notes)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeLabel.text = pickerData[row]
    }

}

