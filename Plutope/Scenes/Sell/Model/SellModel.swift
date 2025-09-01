//
//  SellModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/04/25.
//

import Foundation
// MARK: - SellProviderData
struct SellProviderData: Codable {
    let status: Int?
    let data: [SellProviderList]?
}

// MARK: - SellProviderList
struct SellProviderList: Codable {
    let name, providerName: String?
    let url: String?
    let image: String?
}
