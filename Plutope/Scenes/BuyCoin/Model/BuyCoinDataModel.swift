//
//  BuyCoinDataModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/04/24.
//

import Foundation
struct BuyQuoteParameters {
    var chainId: Int?
    var currency: String?
    var amount : Double?
    var walletAddress: String?
    var countryCode: String?
    var chainName: String?
    var tokenSymbol: String?
    var tokenAddress: String?
    var decimals: String?
}

// MARK: - BuyMeargedData
struct BuyMeargedData: Codable {
    let status: Int?
    let data: [BuyMeargedDataList]?
}

// MARK: - BuyMeargedDataList
struct BuyMeargedDataList: Codable {
    let providerName, name: String?
    let url: String?
    let image, amount: String?
}
// MARK: - Response
struct BuyMeargedResponse: Codable {
    let fromCurrency, toCurrency, type: String?
    let fromAmount: Int?
    let toAmount: Double?
    let processingFee, networkFee, amountOut: String?
}

