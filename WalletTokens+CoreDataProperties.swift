//
//  WalletTokens+CoreDataProperties.swift
//  Plutope
//
//  Created by Mitali Desai on 20/06/23.
//
//
import Foundation
import CoreData

extension WalletTokens {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletTokens> {
        return NSFetchRequest<WalletTokens>(entityName: "WalletTokens")
     } 
    @NSManaged public var id: UUID?
    @NSManaged public var wallet_id: UUID?
    @NSManaged public var tokens: Token?
 } 
extension WalletTokens: Identifiable {
 } 
