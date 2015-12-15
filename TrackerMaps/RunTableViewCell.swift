//
//  RunTableViewCell.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/15/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit

class RunTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    func  displayData(name: String, item: Run) {
        nameLabel.text = String(format:"Name: %@",name)
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = NSDateFormatterStyle.MediumStyle
        dateLabel.text = dateFormater.stringFromDate(item.timeStamp!)
        averageSpeed.text = String(format:"Speed: %@ km/t", item.maxSpeed!.stringValue)
        distanceLabel.text = String(format:"Distance: %@ m", item.distanceFull!.stringValue)
    }
}
