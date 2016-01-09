//
//  ViewModel.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

class ViewModel<T> {
    
    let model: T
    
    required init(_ model: T) {
        self.model = model
    }
}

