//
//  LocationViewController.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var firstDayTitleLabel: UILabel!
    @IBOutlet weak var firstDayTemperatureLabel: UILabel!
    @IBOutlet weak var secondDayTitleLabel: UILabel!
    @IBOutlet weak var secondDayTemperatureLabel: UILabel!
    @IBOutlet weak var thirdDayTitleLabel: UILabel!
    @IBOutlet weak var thirdDayTemperatureLabel: UILabel!
    @IBOutlet weak var fourthDayTitleLabel: UILabel!
    @IBOutlet weak var fourthDayTemperatureLabel: UILabel!
    @IBOutlet weak var fifthDayTitleLabel: UILabel!
    @IBOutlet weak var fifthDayTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
