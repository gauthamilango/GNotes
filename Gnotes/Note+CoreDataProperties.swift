//
//  Note+CoreDataProperties.swift
//  
//
//  Created by Gautham Ilango on 21/04/17.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var createdDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedDate: NSDate?
    @NSManaged public var folder: Folder?

}
