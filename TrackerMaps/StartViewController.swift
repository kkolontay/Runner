//
//  StartViewController.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 10/30/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit
import HealthKit
import CoreData
import GoogleMaps
import Parse

class StartViewController: UIViewController {
    var seconds = 0.0
    var distance = 0.0
    var minimalSpeed = 10010.0
    var maximumSpeed = 0.0
    var averageSpeed = 0.0
    var run: Run?
    var isPaused = false
    var savedLocations: [Location]?
    let healthManager = HealthManager()
    var managedObjectContext: NSManagedObjectContext!
    var locationsPoints = [CLLocation]()
    lazy var timer = NSTimer()
    lazy var locationManager: CLLocationManager = {
        var _locationMananger = CLLocationManager()
        _locationMananger.delegate = self
        _locationMananger.distanceFilter =  10 //kCLDistanceFilterNone
        _locationMananger.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        _locationMananger.activityType = .Fitness
        _locationMananger.requestWhenInUseAuthorization()
        return _locationMananger
    }()

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var Vmin: UILabel!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var Vaverage: UILabel!
    @IBOutlet weak var Vmax: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorization recieved")
            }
            else
            {
                print("HealthKit authorization denied")
                if (error != nil) {
                    print("\(error)")
                }
            }
            
        }
        locationManager.requestAlwaysAuthorization()
        stop.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.managedObjectContext = appDelegate?.managedObjectContext
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
               timer.invalidate()
    }

    @IBAction func pressStart(sender: AnyObject) {
        stop.hidden = false
        isPaused = false
        run = NSEntityDescription.insertNewObjectForEntityForName(
            "Run", inManagedObjectContext: self.managedObjectContext) as? Run
        savedLocations = [Location]()
        run!.timeStamp = NSDate()
        seconds = 0.0
        distance = 0.0
        maximumSpeed = 0.0
        minimalSpeed = 1000.0
        averageSpeed = 0.0
        timer.invalidate()
        locationsPoints.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }
    

    @IBAction func pressStop(sender: AnyObject) {
        timer.invalidate()
        self.saveRun()
        let player = PFObject(className: "Player")
        player.setObject("Vasia", forKey: "Name")
        player.setObject(666, forKey: "Score")
        player.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        stop.hidden = true
    }

    func eachSecond(timer:NSTimer) {
        if (seconds % 10) == 0 {
        locationManager.startUpdatingLocation()
        }
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue:  seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = "Pace: " + paceQuantity.description
        let speedUnit = HKUnit.meterUnitWithMetricPrefix(.Kilo).unitDividedByUnit(HKUnit.hourUnit())
        let minSpeedQuantity = HKQuantity(unit: speedUnit, doubleValue: minimalSpeed)
        Vmin.text = "V-min: " + minSpeedQuantity.description
        let averageSpeedQuantity = HKQuantity(unit: speedUnit, doubleValue: averageSpeed)
        Vaverage.text = "V: " + averageSpeedQuantity.description
        let maximumSpeedQuantity = HKQuantity(unit: speedUnit, doubleValue: maximumSpeed)
        Vmax.text = "V-max: " + maximumSpeedQuantity.description
        
    }
    
   /* override func viewDidAppear(animated: Bool) {
        healthManager.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorization recieved")
            }
            else
            {
                print("HealthKit authorization denied")
                if (error != nil) {
                    print("\(error)")
                }
            }
            
        }
        locationManager.requestAlwaysAuthorization()
        stop.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.managedObjectContext = appDelegate?.managedObjectContext
    }*/
  /*override func viewWillAppear(animated: Bool) {
        healthManager.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorization recieved")
            }
            else
            {
                print("HealthKit authorization denied")
                if (error != nil) {
                    print("\(error)")
                }
            }
            
        }
        //locationManager.requestAlwaysAuthorization()
        stop.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.managedObjectContext = appDelegate?.managedObjectContext
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "resultTracking" {
            let resultViewController = segue.destinationViewController as! ResultViewController
            resultViewController.run = run
        }
    }*/
}
extension StartViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
            if location!.horizontalAccuracy  > 0 {
                if self.locationsPoints.count > 0 {
                    distance += location!.distanceFromLocation(locationsPoints.last!)
                }
                self.locationsPoints.append(location!)
                let speed = location!.speed * 3.6
                if maximumSpeed < speed {
                    maximumSpeed = speed
                }
                if minimalSpeed > speed {
                    minimalSpeed = speed
                }
                averageSpeed = speed
            }
        let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: self.managedObjectContext) as! Location
        savedLocation.timeshtamp = location!.timestamp
        savedLocation.latitude = location!.coordinate.latitude
        savedLocation.longitude = location!.coordinate.longitude
        savedLocation.altitude = location!.altitude
        savedLocation.speed = location!.speed * 3.6
        savedLocation.havePOI = false
        savedLocations!.append(savedLocation)
       // locationManager.stopUpdatingLocation()
    }
    func saveRun() {
        
        run!.maxSpeed = maximumSpeed
        run!.minSpeed = minimalSpeed
        run!.durationExsercise = seconds
        run!.distanceFull = distance
        run!.location = NSSet(array: savedLocations!)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        let user = PFUser.currentUser()
        if user == nil {
            let alert = UIAlertController(title: "Warning", message: "You don't have authrisation", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
        }
            else {
                ConnectToParse.loadData(self.run)
            }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "makePOI" {
            let viewController: PhotoPOIMakeViewController = segue.destinationViewController as! PhotoPOIMakeViewController
            viewController.locations = savedLocations
            viewController.delegate = self
            if isPaused {
                timer.fire()
                isPaused = false
            } else {
                timer.invalidate()
                isPaused = true
            }
            
        }
    }
}

extension StartViewController: StartTimerFromPause {
    func startTimer() {
        //timer.fire()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        isPaused = false
    }
}
protocol StartTimerFromPause {
    func startTimer()
}
/*extension StartViewController: UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 2 {
            let result = ResultViewController()
           // result.run = self.run
            presentViewController( result , animated: true, completion: nil)
        }
    }
}*/