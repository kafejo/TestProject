//
//  WeatherTableViewCell.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 10/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var separatorView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithWeather(weather: WeatherViewModel) {
        dayLabel.text = weather.dayOfWeek.uppercaseString
        temperatureLabel.text = weather.temperature.value
    }
    
}

func classNameOf(aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
}

extension UITableViewCell {
    static var nibName: String {
        return classNameOf(self)
    }
    
    static var reuseIdentifier: String {
        return classNameOf(self)
    }
}
