//
//  CoinPrices.swift
//  Plutope
//
//  Created by Priyanka Poojara on 22/06/23.
//
import Foundation
// MARK: - Welcome
struct CoinDetail: Codable {
    let status, code: Int?
    let data: CoinPrice?
}
// MARK: - DataClass
struct CoinPrice: Codable {
    let coinConfig: CoinConfig?
    let networkConfig: [String: NetworkConfig]?
    let gasFee: [String: GasFee]?
    let minimumBuyAmount: [String: Double]?
}
// MARK: - CoinConfig
struct CoinConfig: Codable {
    let coinName: String?
    let coinIcon: String?
    let balanceFloatPlaces, tradeFloatPlaces: Int?
    let networks: [Int]?
    let markets: Markets?
    enum CodingKeys: String, CodingKey {
        case coinName, coinIcon, balanceFloatPlaces, tradeFloatPlaces, networks, markets
    }
}
// MARK: - Markets
struct Markets: Codable {
    let decimals: [String: Int]?
}
// MARK: - GasFee
struct GasFee: Codable {
    let withdrawalFee, minimumWithdrawal: String?
    let nodeInSync: Int?
}
// MARK: - NetworkConfig
struct NetworkConfig: Codable {
    let chainSymbol, addressRegex, memoRegex, chainName: String?
    let hashLink: String?
    let node: Int?
    let startingWith: [String]?
    let networkID, nativeToken: Int?
    enum CodingKeys: String, CodingKey {
        case chainSymbol, addressRegex, memoRegex, chainName, hashLink, node, startingWith
        case networkID = "networkId"
        case nativeToken
    }
}
