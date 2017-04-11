//
//  Folder+CoreDataProperties.swift
//  
//
//  Created by Gautham Ilango on 11/04/17.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdDate: NSDate?

}
