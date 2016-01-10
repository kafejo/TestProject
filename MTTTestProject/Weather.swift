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
import AERecord

class Weather: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Weather: DecodableManagedObject {
    
    @nonobjc static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static func newObject(json: JSON, context: NSManagedObjectContext) -> Weather {
        return Weather.create(context: context)
    }
    
    func decode(json: JSON, context: NSManagedObjectContext) {
        self.date = json["date"].string.flatMap { Weather.dateFormatter.dateFromString($0) }
        self.maxTempC = Int(json["maxtempC"].stringValue)
        self.minTempC = Int(json["mintempC"].stringValue)
        
        if let currentTemp = Int(json["temp_C"].stringValue) {
            self.maxTempC = currentTemp
        }
    }
}

