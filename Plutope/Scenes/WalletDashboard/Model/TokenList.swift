//
//  TokenList.swift
//  PlutoPe
//
//  Created by Mitali Desai on 05/05/23.
//
import Foundation
//import WalletCore
// MARK: - AssetsData
struct AssetsData: Codable {
    let status: Status?
    let data: [String: AssetsList]?
 }
// MARK: - AssetsList
struct AssetsList: Codable {
    let id: Int?
    let name, symbol, category, description: String?
    let slug: String?
    let logo: String?
    let quote: [String: Quote]?
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, category, description, slug, logo,quote
       
     } 
 } 

// MARK: - Usd
struct Quote: Codable {
    let price, volume24H, volumeChange24H, percentChange1H: Double?
    let percentChange24H, percentChange7D, percentChange30D, percentChange60D: Double?
    let percentChange90D, marketCap, marketCapDominance, fullyDilutedMarketCap: Double?

    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume24h"
        case volumeChange24H = "volume_change_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
     } 
 } 
// MARK: - Status
struct Status: Codable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    let elapsed, creditCount: Int
    let notice: String?
    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
        case notice
     } 
 }
// MARK: - BackendTokenList
struct BackendTokenList: Codable {
    let id: Int?
    let coinID, name, symbol: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case coinID = "coin_id"
        case name, symbol, image
    }
}
// MARK: - WalletData
struct BitcoinWalletData: Codable {
    let balance: Double?
}
// MARK: - WelcomeElement
struct ActiveTokens: Codable {
    let tokenAddress, symbol, name: String?
    let logo: String?
    let decimals: Int?
    let balance: String?
    //let possibleSpam, verifiedContract: Bool?

    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case symbol, name, logo, decimals, balance
      //  case possibleSpam = "possible_spam"
       // case verifiedContract = "verified_contract"
    }
}
