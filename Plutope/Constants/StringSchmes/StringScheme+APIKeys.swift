//
//  StringScheme+APIKeys.swift
//  Plutope
//
//  Created by Priyanka Poojara on 27/06/23.
//

import Foundation

struct APIKey {
    // MELD
    static let meldApiHeader = ["Authorization" : "BASIC WQ5G9zvsK1cKC22iGZ8KXb:2mSZKY8pSiqYckZgDvnH9UNzphpDgosDyi73m"]
    
    // ONRAMP
    static let onRampSecurityKey = "SQ1VFzoM0rhsR3c1raojzawQwU190AG3"
    static let onRampHeaderKey = "ezJrTUkLwuLOPEtQ278qYreMaRUq7n"
    
    // ONMETA
    static let onMeta = "31e2fd7c-0081-435e-ab7f-e6436e68cd52" // "500c417e-5130-4752-b5eb-e03a23c3ef23"
    static let onMetaHeader = ["x-api-key": "31e2fd7c-0081-435e-ab7f-e6436e68cd52"]
    
    // CHANGENOW
    static let changeNowAPIHeader = ["x-changenow-api-key":"53600a5f3f67bc771bef9f3b0336c740d9c10d9db83e8df1491add59a09b6ccb"]
    
    // COINMARKETCAP
    static let coinMarketAPIHeader = ["X-CMC_PRO_API_KEY":"7d6014cf-9a4e-41bf-8034-bd971c214ee7"]
    
    // MORALIS
    static let moralisAPIKey = ["x-api-key":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6IjE4YTViOTIwLThmOWUtNDlmZi1hOGE4LTMzZTEyMWJjOWNkZCIsIm9yZ0lkIjoiMzI5NDkzIiwidXNlcklkIjoiMzM4NzgzIiwidHlwZUlkIjoiZjU2YmIyYzYtMGEzZi00NWNmLTgzNDAtMGE4NjAyZjQ0NDNlIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE2ODMxODIzNjQsImV4cCI6NDgzODk0MjM2NH0.I2os4dXf1BJsQLWqpN9oGXmwEC0gSeV8mP4nfy9DY58"]
    
    // OKLINK
    static let okLinkHeader = ["OK-ACCESS-KEY" : "91db5ffb-a488-4cc6-863b-e81227f96038"]
    
    /// API Key for currency
    static let currencyAPIKey = ["X-CMC_PRO_API_KEY" : "7d00fe84-d1ea-47da-b2f6-53287366a15c"]
    
    /// ApiKeys of account
    static let polygonScanAPiKey = "2QQ6FI7RA8G8R6IBJA52UA97TD9BH3SFG8"
    static let etherScanAPiKey = "1IT9WXZ9X2AVMUFJHRBP7E8I6W6TXIMHEJ"
    static let bscScanAPiKey = "G5NXUANXH7RE8ZQXGXRVRJQDZ8RBNMJZ4S"
    
    /// OKX
    static let okxSecretKey = "98B9B815F07D1A67F243FDBF7066EE1E"
    static let okxApiKey = "f062cbc4-5228-47a8-a02c-8c9989e2244e"
    static let okxPassphrase = "Plutope@ApiKey1"
    
}
