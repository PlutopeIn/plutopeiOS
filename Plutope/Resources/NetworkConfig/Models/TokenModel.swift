//
//  TokenModel.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import Web3
import CoreData
//struct TokenList: Codable {
//    let name: String
//    let logoURI: String
//    let tokens: [Token]
// } 
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
    
//    enum CodingKeys: String, CodingKey {
//        case address,balance,price
//        case name, symbol
//        case decimals
//        case logoURI,lastPriceChangeImpact
//        case type,isEnabled
//     }
    
    var userTokenData: UserTokenData? {
        return DataStore.userTokenDataMap[symbol ?? ""]
     } 
    var chain: Chain? {
        DataStore.chainByTokenStandard[type ?? ""]
     } 
    
    var callFunction: BlockchainFunctions {
        
        return address != "" ? TokenFunctions(self): ChainFunctions(self)
        
    }
    
//    required convenience public init(from decoder: Decoder) throws {
//        let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext
//        guard let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext else { throw DecoderConfigurationError.missingManagedObjectContext   }
//        guard let entity = NSEntityDescription.entity(forEntityName: "Token", in: managedObjectContext) else { throw DecoderConfigurationError.missingManagedObjectContext  }
//
//        self.init(entity: entity, insertInto: managedObjectContext)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.address = try container.decodeIfPresent(String.self, forKey: .address)
//        self.name = try container.decodeIfPresent(String.self, forKey: .name)
//        self.logoURI = try container.decodeIfPresent(String.self, forKey: .logoURI)
//        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
//        self.type = try container.decodeIfPresent(String.self, forKey: .type)
//        self.decimals = try container.decodeIfPresent(Int64.self, forKey: .decimals) ?? 0
//        self.price = try container.decodeIfPresent(String.self, forKey: .price)
//        self.balance = try container.decodeIfPresent(String.self, forKey: .balance)
//        self.lastPriceChangeImpact = try container.decodeIfPresent(String.self, forKey: .lastPriceChangeImpact)
//        self.isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? false
//
//     }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(address, forKey: .address)
//        try container.encode(name, forKey: .name)
//        try container.encode(logoURI, forKey: .logoURI)
//        try container.encode(decimals, forKey: .decimals)
//        try container.encode(address, forKey: .address)
//        try container.encode(type, forKey: .type)
//        try container.encode(balance, forKey: .balance)
//        try container.encode(price, forKey: .price)
//        try container.encode(lastPriceChangeImpact, forKey: .lastPriceChangeImpact)
//        try container.encode(isEnabled, forKey: .isEnabled)
//
//     }
    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
//        return NSFetchRequest<Token>(entityName: "Token")
//     }
    
 } 

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext: CodingUserInfoKey = CodingUserInfoKey(rawValue: "managedObjectContext")!
 } 
enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
 } 
