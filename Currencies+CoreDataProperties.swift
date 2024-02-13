//
//  Currencies+CoreDataProperties.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/07/23.
//
//

import Foundation
import CoreData


extension Currencies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currencies> {
        return NSFetchRequest<Currencies>(entityName: "Currencies")
    }

    @NSManaged public var sign: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var isPrimary: Bool
    @NSManaged public var id: UUID?

}

extension Currencies : Identifiable {

}
