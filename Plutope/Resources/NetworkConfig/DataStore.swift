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
        Chain.bitcoin,
        Chain.opMainnet,
        Chain.arbitrum,
        Chain.avalanche,
        Chain.base
//        Chain.tron,
//        Chain.solana
        
    ]
    
    static var chainByTokenStandard: [String: Chain] = [
        "BEP20": Chain.binanceSmartChain,
        "ERC20": Chain.ethereum,
        "POLYGON": Chain.polygon,
        "KIP20": Chain.oKC,
        "BTC": Chain.bitcoin,
        "OP Mainnet":Chain.opMainnet,
        "Arbitrum" : Chain.arbitrum,
        "Avalanche" : Chain.avalanche,
        "Base" : Chain.base
//        "TRC20" : Chain.tron,
//        "SPL": Chain.solana
            
    ]
    
    static var userTokenDataMap: [String: UserTokenData] = [:]
 } 
