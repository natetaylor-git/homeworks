//
//  CoreDataStack.swift
//  FlickrAndCoreData
//
//  Created by nate.taylor_macbook on 21/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation
import CoreData

internal final class CoreDataStack {
    static let shared: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        return coreDataStack
    }()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        let group = DispatchGroup()
        
        persistentContainer = NSPersistentContainer(name: "FlickrModel")
        group.enter()
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
}
