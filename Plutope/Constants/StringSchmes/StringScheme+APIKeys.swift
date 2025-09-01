//
//  StringScheme+APIKeys.swift
//  Plutope
//
//  Created by Priyanka Poojara on 27/06/23.
//

import Foundation

struct APIKey {
    // MELD
    static let meldApiHeader = ["Authorization" : "meldApiHeader"]
    // ONRAMP
    static let onRampSecurityKey = "onRampSecurityKey"
    static let onRampHeaderKey = "onRampHeaderKey"
    
    // ONMETA
    static let onMeta = "onMeta"
    static let onMetaHeader = ["x-api-key": "onMetaHeader"]
    
    // CHANGENOW
    static let changeNowAPIHeader = ["x-changenow-api-key":"5db83e8d6ccb"]
    
    // COINMARKETCAP
    static let coinMarketAPIHeader = ["X-CMC_PRO_API_KEY":"coinMarketAPIHeader"]
    
    // MORALIS
    static let moralisAPIKey = ["x-api-key":"x-api-key"]
    
    static let moralisNewAPIKey = "moralisNewAPIKey"
    
    
    // OKLINK

    static let okLinkHeader = ["OK-ACCESS-KEY" : "OK-ACCESS-KEY"]
    
    /// API Key for currency
    static let currencyAPIKey = ["X-CMC_PRO_API_KEY" : "X-CMC_PRO_API_KEY"]
    
    /// ApiKeys of account
    static let polygonScanAPiKey = "polygonScanAPiKey"
    static let etherScanAPiKey = "etherScanAPiKey"
    static let bscScanAPiKey = "bscScanAPiKey"
    
    /// OKX
    static let okxSecretKey = "okxSecretKey"
    static let okxApiKey = "okxApiKey"
    static let okxPassphrase = "okxPassphrase"
    
}
