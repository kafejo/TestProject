//
//  WeatherServices.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import PromiseKit
import Foundation
import AERecord
import CoreData

enum LocationServicesError: ErrorType {
    case NotFound
    case DataError
}

class LocationServices {
    
    static let updateInterval: NSTimeInterval = 15 * 60 // 15 minutes
    
    /// Update location if lastUpdate timestamp exceed the update interval  
    class func updateLocation(location: Location) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            if let timestamp = location.lastUpdate where NSDate().compare(timestamp) == NSComparisonResult.OrderedAscending {
                fulfill()
                return
            }

            search(locationQuery: location.name!).then { loc -> Void in
                loc.lastUpdate = NSDate(timeIntervalSinceNow: updateInterval)
                AERecord.saveContext(loc.managedObjectContext!)
                fulfill()
            }.error(reject)
        }
        
    }
    
    /** 
     Search for location. May throw WeatherServicesError or APIClientError
     
     @param cityQuery Name of location (city)
     
     @return Promise<Location>
     */
    
    class func search(locationQuery locationQuery: String, numberOfDays: Int = 5, context: NSManagedObjectContext = AERecord.backgroundContext) -> Promise<Location> {
        
        return Promise { fulfill, reject in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                let params: [String: AnyObject] = [
                    "query": locationQuery,
                    "num_of_days": numberOfDays
                ]
                
                APIClient.requestJSON(.GET, URLString: "/weather.ashx", parameters: params).then { json -> Void in
                    
                    if json["data"]["error"].object != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            reject(LocationServicesError.DataError)
                        }
                        return
                    }
                    
                    
                    guard let location: Location = Decoder.decode(json["data"]["request"].jsonArrayValue.first!, context: context) else {
                        dispatch_async(dispatch_get_main_queue()) {
                            reject(LocationServicesError.DataError)
                        }
                        return
                    }
                    
                    if let forecast: [Weather] = Decoder.decode(json["data"]["weather"].jsonArrayValue, context: context) {
                        location.forecast = NSOrderedSet(array: forecast)
                    }
                    
                    if let json = json["data"]["current_condition"].jsonArrayValue.first, let currentCondition: Weather = Decoder.decode(json, context: context) {
                        location.currentCondition = currentCondition
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        fulfill(location)
                    }
                }.error { err in
                    dispatch_async(dispatch_get_main_queue()) {
                        reject(err)
                    }
                }
            }
        }
    }

}
