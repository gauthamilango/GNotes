//
//  Folder+CoreDataClass.swift
//  
//
//  Created by Gautham Ilango on 11/04/17.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {

  override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
    createdDate = Date() as NSDate
  }
}
