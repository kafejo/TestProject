//
//  WeatherServices.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import PromiseKit

enum WeatherServicesError: ErrorType {

}

class WeatherServices {
    
    /** 
     Search for location. May throw WeatherServicesError
     
     @param cityQuery Name of location (city)
     
     @return Promise<Location>
     */
    
    class func search(cityQuery cityQuery: String) -> Promise<Location> {
        return Promise { fulfill, reject in
            
        }
    }

}
