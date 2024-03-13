//
//  ApiStringConstant.swift
//  Plutope
//
//  Created by Trupti Mistry on 03/01/24.
//
import Foundation
struct ServiceNameConstant {
    
    struct BaseUrl {
        static let baseUrl = "https://plutope.app/"
        static let clientVersion = "api/"
        static let images = "images/"
        static let user = "user/"
        static let admin = "admin/"
    }
 
    static let register = "register-user"
    static let walletActive = "set-wallet-active"
    static let btcTransfer = "btc-transfer"
    static let getAllTtokens = "get-all-tokens"
    static let marketsPrice = "markets-price"
    static let onMeta = "on-meta"
    static let unlimitQuoteBuy = "unlimit-quote-buy"
    static let rangoSwap = "rango-swap"
    static let rangoSwapQuote = "rango-swap-quote"
    static let btcBalance = "btc-balance"
    static let getAllImages = "get-all-images"
    static let domainCheck = "domain-check"
   
}
