//
//  LocationViewModel.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

class LocationViewModel: ViewModel<Location> {
    
    private(set) lazy var currentCondition: WeatherViewModel = WeatherViewModel(self.model.currentCondition!)
    
    private(set) lazy var forecast: [WeatherViewModel] = self.model.forecast!.array.map { WeatherViewModel($0 as! Weather) }
    
    private(set) lazy var name: String = self.model.name!
    
    required init(_ model: Location) {
        super.init(model)
    }
}
