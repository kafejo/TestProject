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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    var pageViewController: UIPageViewController!
    var cache: NSCache = NSCache()
    var locations: [Location] = [] {
        didSet {
            self.pageControl.numberOfPages = locations.count
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Life cycle
    
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

        self.activityIndicator.startAnimating()
        
        StackManager.fillWithInitialDataIfNeeded().always {
            self.loadLocations()
            self.activityIndicator.stopAnimating()
            self.activityLabel.hidden = true
        }.error { err in
            print("Error: \(err)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadLocations", name: AddLocationViewController.AddLocationVCDidAddLocationNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Remove all cached controller in order to free up the memory
        self.cache.removeAllObjects()
    }
    
    deinit {
        // This is not necessary for iOS 9 and higher
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Content
    
    func loadLocations() {
        // Fetch Locations sorted by displayOrder
        let fetchRequest = Location.createFetchRequest(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "displayOrder", ascending: false)])
        
        do {
            self.locations = try AERecord.mainContext.executeFetchRequest(fetchRequest) as! [Location]
        } catch {
            assertionFailure("*** Unable to fetch locations")
        }
        
        if let firstModel = self.locationForIndex(0) {
            let firstViewController = self.viewControllerForIndex(firstModel.model)
            firstViewController.location = self.locationForIndex(0)
            self.pageControl.currentPage = 0
            self.pageViewController.setViewControllers([firstViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
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

// MARK: - UIPageViewControllerDataSource

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

// MARK: - UIPageViewControllerDelegate

extension LocationsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewController
        
        if let currentViewController = pageViewController.viewControllers?.first as? LocationViewController, let index = self.locations.indexOf(currentViewController.location.model) {
            self.pageControl.currentPage = index
        }
    }
}
