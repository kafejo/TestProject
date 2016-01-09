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
    
    static func newObject(json: JSON) -> Location {
        
        if let name = json["query"].string {
            return Location.firstOrCreateWithAttribute("name", value: name) as! Location
        } else {
            assertionFailure("*** JSON parsing error: query value not found!")
            return Location.create()
        }
    }
    
    func decode(json: JSON) {
        
    }
}

