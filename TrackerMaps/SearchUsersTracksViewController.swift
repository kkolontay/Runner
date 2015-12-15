//
//  SearchUsersTracksViewController.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/14/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit

class SearchUsersTracksViewController: UIViewController {

    @IBOutlet weak var usersTextField: UITextField!
    @IBAction func searchTracks(sender: AnyObject) {
        performSegueWithIdentifier("table", sender: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "table" {
            let runTable: RunTableViewController = segue.destinationViewController as! RunTableViewController
            let data = ConnectToParse.fetchDataFromParse(usersTextField.text, tableView: runTable)
            runTable.source = data.array
            runTable.name = data.name
        }
    }
}
