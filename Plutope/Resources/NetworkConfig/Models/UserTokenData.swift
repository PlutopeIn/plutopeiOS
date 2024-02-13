//
//  UserTokenData.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
struct UserTokenData {
    var price: String
    var balance: String
    var lastPriceChangeImpact: String
    
    private static let dataQueue = DispatchQueue(label: "com.example.dataQueue", attributes: .concurrent)
    static func update(symbol: String, price: String? = nil, balance: String? = nil, lastPriceChangeImpact: String? = nil) {
        dataQueue.async(flags: .barrier) {
            if DataStore.userTokenDataMap[symbol] != nil {
                if let price = price {
                    DataStore.userTokenDataMap[symbol]?.price = price
                 } 
                if let balance = balance {
                    DataStore.userTokenDataMap[symbol]?.balance = balance
                 } 
                if let lastPriceChangeImpact = lastPriceChangeImpact {
                    DataStore.userTokenDataMap[symbol]?.lastPriceChangeImpact = lastPriceChangeImpact
                 } 
             } else {
                DataStore.userTokenDataMap[symbol] = UserTokenData(price: price ?? "", balance: balance ?? "", lastPriceChangeImpact: lastPriceChangeImpact ?? "")
             } 
            
         } 
     } 
    
 } 
