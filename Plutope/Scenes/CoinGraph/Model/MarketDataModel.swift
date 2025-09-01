//
//  MarketDataModel.swift
//  Plutope
//
//  Created by Mitali Desai on 30/06/23.
//

import Foundation

enum MarketCap: Codable {
    case int(Int)
    case double(Double)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "MarketCap value is not valid")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }
}
// MARK: - MarketData
struct MarketData: Codable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice: Double?
    let marketCap: MarketCap?
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
