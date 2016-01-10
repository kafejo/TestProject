//
//  Location.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Foundation
import CoreData
import JASON
import AERecord

class Location: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Location: DecodableManagedObject {
    
    /// Autoincrementing value for displaying locations in order they were inserted
    class var nextDisplayOrder: Int {
        if let lastLocation = Location.firstWithPredicate(NSPredicate(format: "displayOrder != nil"), sortDescriptors: [NSSortDescriptor(key: "displayOrder", ascending: false)], context: AERecord.backgroundContext) as? Location {
            return lastLocation.displayOrder!.integerValue + 1
        } else {
            return 0
        }
    }
    
    static func newObject(json: JSON, context: NSManagedObjectContext) -> Location {
        
        if let name = json["query"].string {
            let location = Location.firstOrCreateWithAttribute("name", value: name, context: context) as! Location
            if location.displayOrder == nil {
                location.displayOrder = Location.nextDisplayOrder
            }
            return location
        } else {
            assertionFailure("*** JSON parsing error: query value not found!")
            return Location.create()
        }
    }
    
    func decode(json: JSON, context: NSManagedObjectContext) {
        
    }
}


extension Location {
    /// Fetch request for forecast, should returns Weather objects
    var fetchRequestForForecast: NSFetchRequest {
        let predicate = NSPredicate(format: "locationForecast == %@", self)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        return Weather.createFetchRequest(predicate: predicate, sortDescriptors: [sortDescriptor])
    }
}
