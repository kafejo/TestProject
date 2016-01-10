//
//  WeatherViewModelSpec.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Quick
import Nimble
import AERecord
@testable import MTTTestProject

class WeatherViewModelSpec: QuickSpec {
    override func spec() {
        
        var weatherViewModel: WeatherViewModel!
        
        beforeSuite {
            StackManager.setupStack(forTesting: true)
        }
        
        beforeEach {
            let weather = Weather.create()
            weather.minTempC = 10
            weather.maxTempC = 12
            weather.date = NSDate(timeIntervalSince1970: 1452360006) // Sat, 09 Jan 2016 17:20:06 GMT
            weatherViewModel = WeatherViewModel(weather)
        }
        
        describe("Weather view model") {
            
            it("has temperature") {
                expect(weatherViewModel.temperature.value).to(equal("10/12"))
            }
            
            // With setting language to English and locale to Ireland
            it("has week day abbreviation of it day") {
                expect(weatherViewModel.dayOfWeekAbb).to(equal("Saturday"), description: "This test depends on region and language settings of testing device")
            }
        }
    }
}
