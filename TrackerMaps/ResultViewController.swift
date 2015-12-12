//
//  ResultViewcontroller.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 11/2/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit
import HealthKit
import GoogleMaps
import CoreData

class ResultViewController: UIViewController {
    var run: Run?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    var runers = [NSManagedObject]()
    override func viewDidLoad() {
        fetchData()
        run = runers.last as? Run
        let location = run!.location?.allObjects.last as! Location
        let camera = GMSCameraPosition.cameraWithLatitude((location.latitude?.doubleValue)!, longitude: (location.longitude?.doubleValue)!, zoom: 15)
        mapView.camera =  camera
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        configureView()
        pathPolyline()
        super.viewDidLoad()
    }
    func configureView() {
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: (run?.distanceFull!.doubleValue)! )
        distanceLabel.text = "Distance: " + distanceQuantity.description
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateLabel.text = dateFormatter.stringFromDate((run?.timeStamp)!)
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: (run?.durationExsercise!.doubleValue)!)
        durationLabel.text = "Time: " + secondsQuantity.description
    }
    func pathPolyline() {
        let locations = run?.location?.allObjects as! [Location]
        let path = GMSMutablePath()
        for location in locations {
           path.addCoordinate(CLLocationCoordinate2D(latitude: (location.latitude?.doubleValue)!, longitude: location.longitude!.doubleValue))
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        polyline.map = mapView
        polyline.strokeColor = UIColor.blueColor()
    }
    func fetchData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Run")
        let sorted = NSSortDescriptor(key: "timeStamp", ascending: true)
        fetchRequest.sortDescriptors = [sorted]
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest)
            runers = results as! [NSManagedObject]
        } catch let error as NSError {
             print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
}
