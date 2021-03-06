//
//  Weather+CoreDataProperties.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Weather {

    @NSManaged var date: NSDate?
    @NSManaged var maxTempC: NSNumber?
    @NSManaged var minTempC: NSNumber?
    @NSManaged var locationCurrentCondition: Location?
    @NSManaged var locationForecast: Location?

}
