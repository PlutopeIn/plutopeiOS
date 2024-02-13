//
//  DataStore.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import CoreData
struct DataStore {
    
    private init() { } 
    
    static let networkEnv: NetworkType = .mainnet
    
    static let supportedChains: [Chain] = [
        Chain.ethereum,
        Chain.binanceSmartChain,
        Chain.oKC,
        Chain.polygon,
        Chain.bitcoin
    ]
    
    static var chainByTokenStandard: [String: Chain] = [
        "BEP20": Chain.binanceSmartChain,
        "ERC20": Chain.ethereum,
        "POLYGON": Chain.polygon,
        "KIP20": Chain.oKC,
        "BTC": Chain.bitcoin
    ]
    
    static var userTokenDataMap: [String: UserTokenData] = [:]
    
//    static func getAllTokens() -> [Token] {
//        var allTokens: [Token] =  Chain.ethereum.tokens + Chain.polygon.tokens + Chain.oKC.tokens + Chain.binanceSmartChain.tokens
//
//        allTokens = allTokens.sorted { token1, token2 in
//            return token1.symbol ?? "" < token2.symbol ?? ""
//         }
//
//        return allTokens
//
//     }
    
//    static func enabledTokens() -> [Token] {
//        
//        var coins: [Token] = []
//        supportedChains.forEach { chain in
//            let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
//            let tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
//            tokenEntity.address = ""
//            tokenEntity.name = chain.name
//            tokenEntity.symbol = chain.symbol
//            tokenEntity.decimals = Int64(chain.decimals)
//            tokenEntity.logoURI = chain.icon
//            tokenEntity.type = chain.tokenStandard
//            tokenEntity.balance = "0"
//            tokenEntity.price = "0"
//            tokenEntity.lastPriceChangeImpact = "0"
//            tokenEntity.isEnabled = true
//            tokenEntity.tokenId = UUID()
//            
//            DatabaseHelper.shared.saveData(tokenEntity, completion: {_ in
//                coins.append(tokenEntity)
//             })
//         } 
//        return coins
//     } 
    
 } 
