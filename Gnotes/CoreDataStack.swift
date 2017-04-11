//
//  CoreDataStack.swift
//  Gnotes
//
//  Created by Gautham Ilango on 11/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
  // MARK: - Core Data stack
  static let shared = CoreDataStack()
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "Gnotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  lazy var mainContext: NSManagedObjectContext = {
    self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    return self.persistentContainer.viewContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
