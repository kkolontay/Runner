//
//  MyUser.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/13/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import Foundation
import Parse

 class ConnectToParse: NSObject {
   /* static func signUP(name:String?, password:String?,  email:String?, nameOfGroup: String?) {
        let user = PFUser()
        user.username = name
        user.password = password
        user.setValue(nameOfGroup, forKey: "nameOfGroup")
        if isValidEmail(email!) {
            user.email = email
            user.signUpInBackgroundWithBlock({succeeded, error in
                if(succeeded) {
                    self.performSegueWithIdentifier("mainWindow", sender: nil)
                } else {
                    let alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Wrong login or password"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
            })
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Wrong e-mail"
            alert.addButtonWithTitle("OK")
            alert.show()
        }

    }*/
    class func fetchDataFromParse(name:String?) -> NSArray {
        var user: PFUser?
        let userQuery: PFQuery?
        if name == nil {
            user = PFUser.currentUser()
        }
        else {
            userQuery = PFQuery(className: "User")
            userQuery?.whereKey("name", equalTo: name!)
            userQuery?.findObjectsInBackgroundWithBlock({
                (objects, error) ->Void in
                if error == nil {
                    user = objects?.first as? PFUser
                }
            })
        }
        var fetchedData = [Run]()
        let mainQuery = PFQuery(className: "Run")
        mainQuery.orderByAscending("timeStamp")
        mainQuery.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil {
               // array.extend(objects! as [PFObject]) {
                for object in objects! {
                    let item = Run()
                    //let fetchedItem = object as Run
                    item.timeStamp = object.valueForKey("timeStamp") as? NSDate
                    item.distanceFull = object.valueForKey( "distanceFull") as? NSNumber
                    item.durationExsercise = object.valueForKey("durationExersice") as? NSNumber
                    item.maxSpeed = object.valueForKey("maxSpeed") as? NSNumber
                    item.minSpeed = object.valueForKey("minSpeed") as? NSNumber
                    fetchedData.append(item)
                }
            }
        })
        return fetchedData;
    }
    class func loadData(run: Run?) {
        if let user = PFUser.currentUser() {
            let runNet = PFObject(className:"Run")
            runNet["distanceFull"] = run!.distanceFull
            runNet["durationExersice"] = run!.durationExsercise
            runNet["maxSpeed"] = run!.maxSpeed
            runNet["minSpeed"] = run!.minSpeed
            runNet["timeStamp"] = run!.timeStamp
            runNet["user"] = user
            runNet.saveInBackgroundWithBlock {
                (sucess, error) -> Void in
                if sucess {
                    
                    print("saving")
                }
            }

            for locatin in run!.location! {
                let locationNet = PFObject(className:"Location")
                let location = locatin as! Location
                locationNet["altitude"] = location.altitude
                locationNet["havePOI"] = location.havePOI
                locationNet["latitude"] = location.latitude
                locationNet["longitude"] = location.longitude
                locationNet["speed"] = location.speed
                locationNet["timestamp"] = location.timeshtamp
                locationNet["run"] = runNet
                locationNet.saveInBackgroundWithBlock {
                    (sucess, error) -> Void in
                    if sucess {
                        
                        print("saving")
                    }
                }

                if location.havePOI {
                    for poi in location.placePOI! {
                        let poiNet = PFObject(className:"PlacePOI")
                        let placePOI = poi as! PlacePOI
                        let pathPictureLocal = placePOI.pathPicture
                        poiNet["comments"] = placePOI.comment
                        //let imageSave = UIImage(nam: pathPictureLocal!)
                        if pathPictureLocal != nil {
                        let imageSave = UIImage(named: pathPictureLocal!)
                        let imageData: NSData = UIImageJPEGRepresentation(imageSave!, 1.0)!
                        let imageFile = PFFile(name: "image.jpg", data: imageData)!
                        do {
                         try imageFile.save()
                        }catch {
                            
                        }
                        poiNet["picture"] = imageFile
                        }
                        poiNet["location"] = locationNet
                        poiNet.saveInBackgroundWithBlock {
                            (sucess, error) -> Void in
                            if sucess {
                                
                                print("saving")
                            }
                        }
                    }
                   
                }
            }
        }
    }
    
}
