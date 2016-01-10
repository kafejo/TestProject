//
//  LocationViewController.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit
import CoreData
import AERecord
import Bond

class LocationViewController: UIViewController {

    var location: LocationViewModel? {
        didSet {
            if let location = location {
                
                let fetchRequest = location.model.fetchRequestForForecast
                self.weatherFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AERecord.defaultContext, sectionNameKeyPath: nil, cacheName: nil)
                self.weatherFRC!.delegate = self
                
                do {
                    try weatherFRC!.performFetch()
                } catch {
                    assertionFailure("*** Fetch error!")
                }
            }
        }
    }
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var tableView: WeatherTableView!
    var weatherFRC: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        
        if let location = self.location {
            self.locationNameLabel.text = location.name
            location.currentCondition.temperature ->> self.currentTemperatureLabel.bnd_text
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        LocationServices.updateLocation(self.location!.model).error { err in
            print("error \(err)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func updateInformationForLocation(location: LocationViewModel) {
//        LocationServices.updateLocation(location.model).then { location -> Void in
//            
//        }.error { err in
//            print("Update location error \(err)")
//        }
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

extension LocationViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WeatherTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! WeatherTableViewCell
        if let object = self.weatherFRC?.objectAtIndexPath(indexPath) as? Weather {
            cell.configureWithWeather(WeatherViewModel(object))
        }
        
        cell.separatorView.hidden = indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = self.weatherFRC?.sections?[section].numberOfObjects ?? 0
        return numberOfRows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}


extension LocationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
            
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case .Update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? WeatherTableViewCell {
                    let object = controller.objectAtIndexPath(indexPath) as! Weather
                    cell.configureWithWeather(WeatherViewModel(object))
                }
            }
            
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.insertRowsAtIndexPaths([newIndexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
        self.tableView.invalidateIntrinsicContentSize()
    }
}



