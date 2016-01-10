//
//  StackManager.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import AERecord
import CoreData
import PromiseKit

enum StackManagerError: ErrorType {
    case Testing
}

class StackManager {
    
    /// Initialize default core data stack
    class func setupStack(forTesting forTesting: Bool = false) {
        
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd"), let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
            assertionFailure("*** StackManager ERROR: Cannot find model")
            return
        }
        
        let stackOptions = [NSMigratePersistentStoresAutomaticallyOption : true]
        let myStoreURL = AERecord.storeURLForName(forTesting ? "WeatherTestStore" : "WeatherStore")
        
        do {
            try AERecord.loadCoreDataStack(managedObjectModel: model, storeType: NSSQLiteStoreType, configuration: nil, storeURL: myStoreURL, options: stackOptions)
        } catch {
            // FIXME: Only for first version
            do {
                try NSFileManager.defaultManager().removeItemAtURL(myStoreURL)
                try AERecord.loadCoreDataStack(managedObjectModel: model, storeType: NSSQLiteStoreType, configuration: nil, storeURL: myStoreURL, options: stackOptions)
                
            } catch {
                assertionFailure("*** StackManager ERROR: Cannot load core data stack! (Probably bad migration)")
            }
        }

    }
    
    class func fillWithInitialDataIfNeeded() -> Promise<Void> {
        
        return Promise {success, reject in
            let firstUsageKey = "FirstUsageKey"
            
            if NSUserDefaults.standardUserDefaults().objectForKey(firstUsageKey) == nil {
                fillWithDefaultData().then { _ -> Void in
                    success()
                }.error(reject)
                NSUserDefaults.standardUserDefaults().setObject(true, forKey: firstUsageKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                success()
            }
        }
    }
    
    private class func fillWithDefaultData() -> Promise<Void> {
        return Promise { success, reject in
            
            var promises = [Promise<Void>]()
            let locationNames = ["Brno", "Barcelona", "New York", "London", "Dublin"]
            locationNames.forEach { locationName in
                promises.append(LocationServices.search(locationQuery: locationName).then { location -> Void in
                        location.displayOrder = locationNames.indexOf(locationName)
                    })
            }
            when(promises).then { _ -> Void in
                AERecord.saveContextAndWait(AERecord.backgroundContext)
                success()
            }.error (reject)
        }
    }
}

