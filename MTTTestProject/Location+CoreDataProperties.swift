//
//  Location+CoreDataProperties.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 10/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var displayOrder: NSNumber?
    @NSManaged var name: String?
    @NSManaged var lastUpdate: NSDate?
    @NSManaged var currentCondition: Weather?
    @NSManaged var forecast: NSOrderedSet?

}
