//
//  Contacts+CoreDataProperties.swift
//  Plutope
//
//  Created by Mitali Desai on 01/08/23.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var contact_Id: String?

}

extension Contacts : Identifiable {

}
