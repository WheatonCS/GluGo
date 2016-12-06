//
//  dataPointTableViewCell.swift
//  Lab
//
//  Created by Alvaro Landaluce on 10/15/16.
//  Copyright © 2016 Alvaro Landaluce. All rights reserved.
//

import UIKit

class dataPointTableViewCell: UITableViewCell {

    @IBOutlet weak var glucoseLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
