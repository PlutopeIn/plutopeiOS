//
//  Wallets+CoreDataProperties.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/08/23.
//
//

import Foundation
import CoreData


extension Wallets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wallets> {
        return NSFetchRequest<Wallets>(entityName: "Wallets")
    }

    @NSManaged public var fileName: String?
    @NSManaged public var isCloudBackup: Bool
    @NSManaged public var isManualBackup: Bool
    @NSManaged public var isPrimary: Bool
    @NSManaged public var mnemonic: String?
    @NSManaged public var wallet_id: UUID?
    @NSManaged public var wallet_name: String?

}

extension Wallets : Identifiable {

}
