//
//  PlacePOI+CoreDataProperties.swift
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

extension PlacePOI {

    @NSManaged var pathPicture: String?
    @NSManaged var comment: String?
    @NSManaged var location: Location?

}
