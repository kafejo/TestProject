//
//  Location+CoreDataProperties.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var name: String?
    @NSManaged var currentCondition: Weather?
    @NSManaged var forecast: NSSet?

}
