//
//  WeatherServices.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import PromiseKit
import Foundation

enum WeatherServicesError: ErrorType {
    case NotFound
    case DataError
}

class WeatherServices {
    
    /** 
     Search for location. May throw WeatherServicesError or APIClientError
     
     @param cityQuery Name of location (city)
     
     @return Promise<Location>
     */
    
    class func search(locationQuery locationQuery: String, numberOfDays: Int = 5) -> Promise<Location> {
        
        let params: [String: AnyObject] = [
            "query": locationQuery,
            "num_of_days": numberOfDays
        ]
        
        return APIClient.requestJSON(.GET, URLString: "/weather.ashx", parameters: params).then { json -> Location in
            
            if json["data"]["error"].object != nil {
                throw WeatherServicesError.DataError
            }
            
            guard let location: Location = Decoder.decode(json["data"]["request"].jsonArrayValue.first!) else {
                throw WeatherServicesError.DataError
            }
            
            if let forecast: [Weather] = json["data"]["weather"].jsonArray.flatMap(Decoder.decode) {
                location.forecast = NSOrderedSet(array: forecast)
            }
            
            if let currentCondition: Weather = json["data"]["current_condition"].jsonArray?.first.flatMap(Decoder.decode) {
                location.currentCondition = currentCondition
            }
            
            return location
        }
    }

}
