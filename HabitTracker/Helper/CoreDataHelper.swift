//
//  CoreDataHelper.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 12/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static let shared = CoreDataHelper()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HabitTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                FirebaseHelper.shared.error(theClass: self.typeName, onCoreDataHelper: "persistentContainer")
                print("Core data error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                FirebaseHelper.shared.error(theClass: self.typeName, onCoreDataHelper: "saveContext")
                print("Core data error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataHelper: NameDescribable {}
