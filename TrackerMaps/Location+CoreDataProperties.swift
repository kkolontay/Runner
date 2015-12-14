//
//  Location+CoreDataProperties.swift
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

extension Location {

    @NSManaged var altitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var speed: NSNumber?
    @NSManaged var timeshtamp: NSDate?
    @NSManaged var havePOI: Bool
    @NSManaged var run: Run?
    @NSManaged var placePOI: NSSet?

}
