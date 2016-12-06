//
//  rangeViewController.swift
//  Lab
//
//  Created by Alvaro Landaluce on 11/10/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

class rangeViewController: UIViewController, UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UINavigationControllerDelegate{
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePiker: UIDatePicker!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var typeLabel: UILabel!
    
    let pickerData = ["eat","exercise","stress","sleep","other"]
    var rdataPoints = [dataPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesField.delegate   = self
        pickerView.dataSource = self
        pickerView.delegate   = self
        
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        var strDate:String       = dateFormatter.string(from: fromDatePicker.date)
        fromLabel.text = strDate
        strDate        = dateFormatter.string(from: toDatePiker.date)
        toLabel.text   = strDate
        typeLabel.text = pickerData[0]
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        for point in rdataPoints {
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let date = dateFormatter.date(from: point.date+" "+point.time)
            //print(date)
            if (date?.compare(fromDatePicker.date) == .orderedDescending && date?.compare(toDatePiker.date) == .orderedAscending) || (date?.compare(fromDatePicker.date) == .orderedSame) || (date?.compare(toDatePiker.date) == .orderedSame) {
                point.activity = typeLabel.text!
                point.notes = notesField.text!
            }
            
        }
    }
    
    @IBAction func fromDatePoker(_ sender: Any) {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let strDate    = dateFormatter.string(from: fromDatePicker.date)
        fromLabel.text = strDate
    }
    
    @IBAction func toDatePicker(_ sender: Any) {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let strDate  = dateFormatter.string(from: toDatePiker.date)
        toLabel.text = strDate
    }
}
