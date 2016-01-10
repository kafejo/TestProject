//
//  AddLocationViewController.swift
//  MTTTestProject
//
//  Created by Aleš Kocur on 09/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit
import CoreData
import AERecord

class AddLocationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var containerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    private var timer: NSTimer?
    private var location: Location?
    private let temporaryContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.parentContext = AERecord.mainContext
        return context
    }()
    
    // MARK: - Public properties
    static let AddLocationVCDidAddLocationNotification = "AddLocationVCDidAddLocationNotification"
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButton.layer.cornerRadius = 4.0
        self.textField.layer.cornerRadius = 4.0
        self.textField.layer.borderColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.00).CGColor
        self.textField.layer.borderWidth = 0.5
        
        self.clearSearchResult()
        self.textField.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addLocation(sender: AnyObject) {
        
        AERecord.saveContextAndWait(self.temporaryContext)
        AERecord.saveContextAndWait(AERecord.mainContext)
        
        NSNotificationCenter.defaultCenter().postNotificationName(AddLocationViewController.AddLocationVCDidAddLocationNotification, object: nil)
        self.dismiss(sender)
    }
    
    @IBAction func textFieldValueDidChange(sender: AnyObject) {
        timer?.invalidate()
        self.timer = nil
        self.clearSearchResult()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "didStopEditing:", userInfo: nil, repeats: false)
    }
    
    // MARK: - Searching
    
    func didStopEditing(sender: AnyObject) {
        if let text = self.textField.text where text != "" {
            self.activityIndicator.startAnimating()
            LocationServices.search(locationQuery: text, numberOfDays: 5, context: temporaryContext).then {[weak self] location -> Void in
                self?.showSearchResult(location)
            }.error {[weak self] err in
                self?.clearSearchResult()
            }
        } else {
            clearSearchResult()
        }
    }
    
    func clearSearchResult() {
        self.locationLabel.text = ""
        self.location?.deleteFromContext(temporaryContext)
        self.location = nil
        self.addButton.backgroundColor = UIColor.tstGrayColor()
        self.addButton.enabled = false
        self.activityIndicator.stopAnimating()
    }
    
    func showSearchResult(location: Location) {
        self.location?.deleteFromContext(temporaryContext)
        self.addButton.enabled = true
        self.locationLabel.text = location.name
        self.location = location
        self.addButton.backgroundColor = UIColor.tstGreenColor()
        self.activityIndicator.stopAnimating()
    }

}
