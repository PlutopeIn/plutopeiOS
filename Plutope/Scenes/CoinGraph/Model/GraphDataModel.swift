//
//  GraphDataModel.swift
//  Plutope
//
//  Created by Mitali Desai on 29/06/23.
//

import Foundation
// MARK: - GraphData
struct GraphData: Codable {
    let prices, marketCaps, totalVolumes: [[Double?]]?

    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
}

// MARK: - CoinInfo Data
struct CoinInfoData: Codable {
    let id, symbol, name, hashingAlgorithm: String?
    let categories: [String]?
    let description: CoinDescription?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case hashingAlgorithm = "hashing_algorithm"
        case categories, description
    }
}

// MARK: - Description
struct CoinDescription: Codable {
    let en: String?
}
