//
//  Weather.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Foundation
import CoreData
import JASON

class Weather: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Weather: DecodableManagedObject {
    
    @nonobjc static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static func newObject(json: JSON) -> Weather {
        return Weather.create()
    }
    
    func decode(json: JSON) {
        self.date = json["date"].string.flatMap { Weather.dateFormatter.dateFromString($0) }
        self.maxTempC <? json["maxtempC"]
        self.minTempC <? json["mintempC"]
    }
}

