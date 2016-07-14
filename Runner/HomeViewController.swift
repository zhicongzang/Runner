//
//  ViewController.swift
//  Runner
//
//  Created by Zhicong Zang on 7/7/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(NewRunViewController) {
            if let newRunViewController = segue.destinationViewController as? NewRunViewController {
                newRunViewController.managedObjectContext = managedObjectContext
            }
        } else if segue.destinationViewController.isKindOfClass(BadgesTableViewController) {
            let fetchRequest = NSFetchRequest(entityName: "Run")
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let runs = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [Run]
                
                let badgesTableViewController = segue.destinationViewController as! BadgesTableViewController
                badgesTableViewController.badgeEarnStatusesArray = BadgeController.sharedController.badgeEarnStatusesForRuns(runs)
                
            } catch {}
            
        }
    }
}
