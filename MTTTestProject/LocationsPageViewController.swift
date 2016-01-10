//
//  LocationsPageViewController.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit
import CoreData
import AERecord

class LocationsPageViewController: UIViewController {

    var pageViewController: UIPageViewController!
    var cache: NSCache = NSCache()
    var locations: [Location] = [] {
        didSet {
            self.pageControl.numberOfPages = locations.count
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.sendSubviewToBack(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageControl.currentPage = 0
        
        StackManager.fillWithInitialDataIfNeeded().always {
            self.loadLocations()
        }
    }

    func loadLocations() {
        // Fetch Locations sorted by displayOrder
        let fetchRequest = Location.createFetchRequest(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "displayOrder", ascending: true)])
        
        do {
            self.locations = try AERecord.defaultContext.executeFetchRequest(fetchRequest) as! [Location]
        } catch {
            assertionFailure("*** Unable to fetch locations")
        }
        
        if let firstModel = self.locationForIndex(0) {
            let firstViewController = self.viewControllerForIndex(firstModel.model)
            firstViewController.location = self.locationForIndex(0)
            self.pageViewController.setViewControllers([firstViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    /// Returns view controller for given index
    func viewControllerForIndex(model: Location) -> LocationViewController {
        
        if let viewController = self.cache.objectForKey(model) as? LocationViewController {
            return viewController
        }
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationViewControllerID") as! LocationViewController
        
        self.cache.setObject(viewController, forKey: model)
        
        return viewController
    }
    
    func locationForIndex(index: Int) -> LocationViewModel? {
        if index >= self.locations.count || index < 0 {
            return nil
        }
        return LocationViewModel(self.locations[index])
    }
}

extension LocationsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let controller = viewController as! LocationViewController

        if let model = controller.location?.model, let index = self.locations.indexOf(model), let nextModel = self.locationForIndex(index + 1) {
            let viewController = self.viewControllerForIndex(nextModel.model)
            
            if viewController.location == nil {
                viewController.location = nextModel
            }
            
            return viewController
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let controller = viewController as! LocationViewController
        if let model = controller.location?.model, let index = self.locations.indexOf(model), let previousModel = self.locationForIndex(index - 1) {
            
            let viewController = self.viewControllerForIndex(previousModel.model)
            
            if viewController.location == nil {
                viewController.location = self.locationForIndex(index - 1)
            }
            
            return viewController
        } else {
            
            return nil
        }
    }
}

extension LocationsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewController
        
        if let currentViewController = pageViewController.viewControllers?.first as? LocationViewController, let index = self.locations.indexOf(currentViewController.location.model) {
            self.pageControl.currentPage = index
        }
    }
}
