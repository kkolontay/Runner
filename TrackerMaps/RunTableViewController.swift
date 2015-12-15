//
//  RunTableViewController.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/15/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit

class RunTableViewController: UITableViewController {
    var source: [Run]?
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (source?.count)!
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RunTableViewCell {
        let cell: RunTableViewCell = (tableView.dequeueReusableCellWithIdentifier("cellTracker", forIndexPath: indexPath) as? RunTableViewCell)!
        cell.displayData(name!, item: source![indexPath.row] as Run)
        return cell
        
    }
    @IBAction func pressMainScreen(sender: AnyObject) {
        performSegueWithIdentifier("main", sender: nil)
    }
}
