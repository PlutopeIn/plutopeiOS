//
//  MarketDataModel.swift
//  Plutope
//
//  Created by Mitali Desai on 30/06/23.
//

import Foundation
// MARK: - MarketData
struct MarketData: Codable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice: Double?
    let marketCap: Int?
    let totalVolume: Double?
    let priceChangePercentage24H: Double?
 
    let circulatingSupply, totalSupply, maxSupply: Double?
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
    }
}

// MARK: - MarketDatum
struct CoingechoCoinList: Codable {
    let id, symbol, name: String?
    let platforms: [String: String?]?
}
