//
//  WeatherViewModel.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Foundation

class WeatherViewModel: ViewModel<Weather> {
    
    private(set) lazy var temperature: String = {
        if let minTempC = self.model.minTempC, let maxTempC = self.model.maxTempC {
            return "\(minTempC)-\(maxTempC)"
        } else {
            return "-"
        }
    }()
    
    private static let dayOfWeekFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEE", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter
    }()
    
    private(set) lazy var dayOfWeekAbb: String = {
        return WeatherViewModel.dayOfWeekFormatter.stringFromDate(self.model.date!)
    }()
    
    required init(_ model: Weather) {
        super.init(model)
    }
}
