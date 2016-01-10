//
//  WeatherTableView.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 10/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit

class WeatherTableView: UITableView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.registerNibForCellClass(WeatherTableViewCell)
        
        self.scrollEnabled = false
        self.separatorStyle = .None
    }
    
    override func intrinsicContentSize() -> CGSize {
        return self.contentSize
    }
    
}

extension UITableView {
    func registerNibForCellClass<T: UITableViewCell>(t: T.Type) {
        let nib = UINib(nibName: t.nibName, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: t.reuseIdentifier)
    }
}
