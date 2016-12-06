//
//  dataPointTableViewController.swift
//  Lab
//
//  Created by Alvaro Landaluce on 10/15/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

class dataPointTableViewController: UITableViewController {

    var dataPoints = [dataPoint]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let temp = data()
        dataPoints = (temp?.dataPoints)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoints.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "dataPointTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! dataPointTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let dataPoint = dataPoints[indexPath.row]
        
        cell.glucoseLabel.text = dataPoint.glucose
        cell.dateLabel.text = dataPoint.date
        cell.timeLabel.text = dataPoint.time
        
        if(dataPoint.activity == "eat") {
            cell.glucoseLabel.textColor = UIColor.green
            cell.dateLabel.textColor = UIColor.green
            cell.timeLabel.textColor = UIColor.green
        } else if(dataPoint.activity == "exercise") {
            cell.glucoseLabel.textColor = UIColor.red
            cell.dateLabel.textColor = UIColor.red
            cell.timeLabel.textColor = UIColor.red
        } else if(dataPoint.activity == "stress") {
            cell.glucoseLabel.textColor = UIColor.orange
            cell.dateLabel.textColor = UIColor.orange
            cell.timeLabel.textColor = UIColor.orange
        } else if(dataPoint.activity == "sleep") {
            cell.glucoseLabel.textColor = UIColor.blue
            cell.dateLabel.textColor = UIColor.blue
            cell.timeLabel.textColor = UIColor.blue
        } else if(dataPoint.activity == "other") {
            cell.glucoseLabel.textColor = UIColor.black
            cell.dateLabel.textColor = UIColor.black
            cell.timeLabel.textColor = UIColor.black
        } else {
            cell.glucoseLabel.textColor = UIColor.gray
            cell.dateLabel.textColor = UIColor.gray
            cell.timeLabel.textColor = UIColor.gray
        }
        
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let dataPointlDetailViewController = segue.destination as! dataPointViewController
            
            // Get the cell that generated this segue.
            if let selecteddataPointCell = sender as? dataPointTableViewCell {
                let indexPath = tableView.indexPath(for: selecteddataPointCell)!
                let selecteddataPoint = dataPoints[indexPath.row]
                dataPointlDetailViewController.datapoint = selecteddataPoint
            }
        } else if segue.identifier == "EditRange" {
            let editRangeViewController = segue.destination as! rangeViewController
            editRangeViewController.rdataPoints = dataPoints
        }
    }
    
    func saveDataPoints() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dataPoints, toFile: dataPoint.ArchiveURL.path)
        
        if !isSuccessfulSave {
            print("Failed to save...")
        }
    }
    
    @IBAction func unwindToDataPoints(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? dataPointViewController, let datapoint = sourceViewController.datapoint {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an datapoint
                dataPoints[selectedIndexPath.row] = datapoint
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
        saveDataPoints()
    }

}
