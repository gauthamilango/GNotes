//
//  Folder+CoreDataProperties.swift
//  Gnotes
//
//  Created by Gautham Ilango on 10/04/17.
//  Copyright © 2017 Gautham Ilango. All rights reserved.
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var title: String?

}
