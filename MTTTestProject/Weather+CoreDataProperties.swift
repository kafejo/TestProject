//
//  Weather+CoreDataProperties.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Weather {

    @NSManaged var temperatureC: NSNumber?
    @NSManaged var temperatureF: NSNumber?
    @NSManaged var locationCurrentCondition: Location?
    @NSManaged var locationForecast: Location?

}
