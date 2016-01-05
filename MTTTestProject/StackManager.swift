//
//  StackManager.swift
//  mtt-test-project
//
//  Created by Aleš Kocur on 05/01/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import AERecord
import CoreData

class StackManager {
    
    /// Initialize default core data stack
    class func setupStack() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd"), let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
            assertionFailure("*** StackManager ERROR: Cannot find model")
            return
        }
        
        let stackOptions = [NSMigratePersistentStoresAutomaticallyOption : true]
        let myStoreURL = AERecord.storeURLForName("mtt-test-store")
        
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
}

