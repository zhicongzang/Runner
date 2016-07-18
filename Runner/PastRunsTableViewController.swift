//
//  PastRunsTableViewController.swift
//  Runner
//
//  Created by Zhicong Zang on 7/18/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import HealthKit

class PastRunsTableViewController: UITableViewController {
    
    var pastRuns: [Run] = []
    
    let dateFormatter: NSDateFormatter = {
        let _dateFormatter = NSDateFormatter()
        _dateFormatter.dateStyle = .MediumStyle
        return _dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pastRuns.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PastRunsCell", forIndexPath: indexPath) as! PastRunsCell
        let run = pastRuns[indexPath.row]
        cell.dateLabel.text = dateFormatter.stringFromDate(run.timestamp!)
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: (run.distance?.doubleValue)!)
        cell.distanceLabel.text = distanceQuantity.description
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController {
            detailViewController.run = pastRuns[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
