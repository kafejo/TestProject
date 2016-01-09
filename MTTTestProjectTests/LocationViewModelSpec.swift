//
//  LocationViewModelSpec.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Quick
import Nimble
import AERecord
@testable import MTTTestProject

class LocationViewModelSpec: QuickSpec {
    override func spec() {
        
        var locationViewModel: LocationViewModel!
        
        beforeSuite {
            StackManager.setupStack()
        }
        
        beforeEach {
            let location = Location.create()
            location.name = "Dublin"
            let weather = Weather.create()
            location.currentCondition = weather
            location.forecast = NSOrderedSet(objects: weather)
            locationViewModel = LocationViewModel(location)
        }
        
        describe("Location view model") {
            
            it("has a name") {
                expect(locationViewModel.name).to(equal("Dublin"))
            }
            
            it("has a forecast") {
                expect(locationViewModel.forecast.count).to(equal(1))
            }
        }
    }
}
