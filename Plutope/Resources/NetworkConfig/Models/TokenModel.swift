//
//  TokenModel.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import Web3
import CoreData

@objc(Token)
public class Token: NSManagedObject {
    
    @NSManaged var address: String?
    @NSManaged var name, symbol: String?
    @NSManaged var decimals: Int64
    @NSManaged var logoURI: String?
    @NSManaged var type: String?
    @NSManaged var balance: String?
    @NSManaged var price: String?
    @NSManaged var lastPriceChangeImpact: String?
    @NSManaged var isEnabled: Bool
    @NSManaged var isUserAdded: Bool
    @NSManaged var tokenId: String?

    var userTokenData: UserTokenData? {
        return DataStore.userTokenDataMap[symbol ?? ""]
     } 
    var chain: Chain? {
        DataStore.chainByTokenStandard[type ?? ""]
     } 
    
    var callFunction: BlockchainFunctions {
        
        return address != "" ? TokenFunctions(self): ChainFunctions(self)
        
    }
 }

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext: CodingUserInfoKey = CodingUserInfoKey(rawValue: "managedObjectContext")!
 } 
enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
 } 
extension Token {
    func toDictionary() -> [String: Any] {
        return [
            "address": address ?? "",
            "name": name ?? "",
            "symbol": symbol ?? "",
            "decimals": decimals,
            "logoURI": logoURI ?? "",
            "type": type ?? "",
            "balance": balance ?? "",
            "price": price ?? "",
            "lastPriceChangeImpact": lastPriceChangeImpact ?? "",
            "isEnabled": isEnabled,
            "isUserAdded": isUserAdded,
            "tokenId": tokenId ?? ""
        ]
    }
}
extension Token {
    static func fromDictionary(_ dict: [String: Any], context: NSManagedObjectContext) -> Token {
        let token = Token(context: context)
        token.address = dict["address"] as? String
        token.name = dict["name"] as? String
        token.symbol = dict["symbol"] as? String
        token.decimals = dict["decimals"] as? Int64 ?? 0
        token.logoURI = dict["logoURI"] as? String
        token.type = dict["type"] as? String
        token.balance = dict["balance"] as? String
        token.price = dict["price"] as? String
        token.lastPriceChangeImpact = dict["lastPriceChangeImpact"] as? String
        token.isEnabled = dict["isEnabled"] as? Bool ?? false
        token.isUserAdded = dict["isUserAdded"] as? Bool ?? false
        token.tokenId = dict["tokenId"] as? String
        return token
    }
}
