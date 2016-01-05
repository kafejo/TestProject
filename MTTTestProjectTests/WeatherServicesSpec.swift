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
            
            it("can find Dublin") {
                
            }
        }
    }
}
