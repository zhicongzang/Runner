//
//  NewRunViewController.swift
//  Runner
//
//  Created by Zhicong Zang on 7/7/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import HealthKit

let DetailSegueName = "RunDetails"

class NewRunViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext?
    
    var run: Run!
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var seconds = 0.0
    var distance = 0.0
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    lazy var locations: [CLLocation] = []
    lazy var timer = NSTimer()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startButton.hidden = false
        promptLabel.hidden = false
        
        timeLabel.hidden = true
        distanceLabel.hidden = true
        paceLabel.hidden = true
        stopButton.hidden = true
        
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func eachSecond(timer: NSTimer) {
        seconds += 1
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds/distance)
        paceLabel.text = "Pace: " + paceQuantity.description
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func saveRun() {
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedObjectContext!) as! Run
        savedRun.distance = distance
        savedRun.duration = seconds
        savedRun.timestamp = NSDate()
        
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext!) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        
        savedRun.locations = NSOrderedSet(array: savedLocations)
        run = savedRun
        
        do {
            try managedObjectContext?.save()
            print("Run saved!")
        } catch {
            print("Could not save the run!")
        }
        
    }
    
    
    
    @IBAction func startPressed(sender: AnyObject) {
        startButton.hidden = true
        promptLabel.hidden = true
        
        timeLabel.hidden = false
        distanceLabel.hidden = false
        paceLabel.hidden = false
        stopButton.hidden = false
        
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NewRunViewController.eachSecond(_:)), userInfo: nil, repeats: true)
        startLocationUpdates()
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Run Stopped", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Discard")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController {
            detailViewController.run = run
        }
    }
}

// MARK: UIActionSheetDelegate
extension NewRunViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //save
        if buttonIndex == 1 {
            saveRun()
            performSegueWithIdentifier(DetailSegueName, sender: nil)
        }
            //discard
        else if buttonIndex == 2 {
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}

extension NewRunViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 && self.locations.count > 0 {
                distance += location.distanceFromLocation(self.locations.last!)
            }
            self.locations.append(location)
        }
    }
}
