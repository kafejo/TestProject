//
//  WeatherServicesSpec.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import Quick
import Nimble
import AERecord
@testable import MTTTestProject

class WeatherServicesSpec: QuickSpec {
    override func spec() {
        
        beforeSuite {
            StackManager.setupStack()
        }
        
        describe("Weather services") {
            
            it("can find forecast for Dublin") {
                waitUntil(timeout: 10) { done in
                    WeatherServices.search(locationQuery: "Dublin").then { location -> Void in
                        expect(location.name).to(contain("Dublin"))
                        expect(location.currentCondition).toNot(beNil())
                        expect(location.forecast).notTo(beNil())
                        expect(location.forecast?.count).to(equal(5))
                        done()
                    }.error { err in
                        expect(true).to(beFalse(), description: "This should not be called at all. (\(err))")
                        done()
                    }
                }
            }
        }
    }
}
