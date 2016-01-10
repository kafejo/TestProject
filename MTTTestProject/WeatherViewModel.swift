//
//  WeatherViewModel.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Foundation
import Bond

class WeatherViewModel: ViewModel<Weather> {
    
    private(set) lazy var temperature: Observable<String> = {
        let minTempObserver: Observable<Int?> = Observable(object: self.model, keyPath: "minTempC")
        let maxTempObserver: Observable<Int?> = Observable(object: self.model, keyPath: "maxTempC")
        self.observers.append([minTempObserver, maxTempObserver])
        
        let update: (NSNumber?, NSNumber?) -> String = { (minTemp, maxTemp) in
            if let minTemp = minTemp?.integerValue, let maxTemp = maxTemp?.integerValue {
                return "\(minTemp)/\(maxTemp)"
            } else if let minTemp = minTemp?.integerValue {
                return "\(minTemp)"
            } else if let maxTemp = maxTemp?.integerValue {
                return "\(maxTemp)"
            } else {
                return "-"
            }
        }
        
        let temperatureObserver: Observable<String> = Observable(update(self.model.minTempC, self.model.maxTempC))
        
        minTempObserver.observeNew { _ in update(self.model.minTempC, self.model.maxTempC) }
        maxTempObserver.observeNew { _ in update(self.model.minTempC, self.model.maxTempC) }
        
        return temperatureObserver
    }()
    
    private static let dayOfWeekFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEEE", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter
    }()
    
    private(set) lazy var dayOfWeekAbb: String = {
        return WeatherViewModel.dayOfWeekFormatter.stringFromDate(self.model.date!)
    }()
    
    // For retaining the KVO observers
    var observers: [AnyObject] = []
    
    required init(_ model: Weather) {
        super.init(model)
    }
}
