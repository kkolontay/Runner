//
//  Run+CoreDataProperties.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/7/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Run {

    @NSManaged var distanceFull: NSNumber?
    @NSManaged var durationExsercise: NSNumber?
    @NSManaged var maxSpeed: NSNumber?
    @NSManaged var minSpeed: NSNumber?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var location: NSSet?

}
