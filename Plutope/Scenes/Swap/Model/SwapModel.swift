//
//  SwapModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 09/06/23.
//
import Foundation
import UIKit
struct CurrencyData: Codable {
    let ticker, name: String?
    let image: String?
    let hasExternalID, isFiat, featured, isStable: Bool?
    let supportsFixedRate: Bool?
    let network: String?
    let tokenContract: String?
    let buy, sell: Bool?
    let legacyTicker: String?
    enum CodingKeys: String, CodingKey {
        case ticker, name, image
        case hasExternalID = "hasExternalId"
        case isFiat, featured, isStable, supportsFixedRate, network, tokenContract, buy, sell, legacyTicker
    }
}
// MARK: - TransactionCurrencies
struct TransactionCurrencies: Codable {
    let ticker, name: String?
    let image: String?
    let hasExternalID, isFiat, featured, isStable: Bool?
    let supportsFixedRate: Bool?
    let network: String?
    let tokenContract: String?
    let buy, sell: Bool?
    let legacyTicker: String?
    enum CodingKeys: String, CodingKey {
        case ticker, name, image
        case hasExternalID = "hasExternalId"
        case isFiat, featured, isStable, supportsFixedRate, network, tokenContract, buy, sell, legacyTicker
    }
}

// MARK: - ExchangePairsData
struct ExchangePairsData: Codable, Hashable {
    
    static func == (lhs: ExchangePairsData, rhs: ExchangePairsData) -> Bool {
        return lhs.fromCurrency == rhs.fromCurrency &&
        lhs.fromNetwork == rhs.fromNetwork &&
        lhs.toCurrency == rhs.toCurrency &&
        lhs.toNetwork == rhs.toNetwork
    }
    
    let fromCurrency, fromNetwork: String?
    let toCurrency: String?
    let toNetwork: String?
}

struct SwapCrypto {
    
    enum SwapCryptoDomain: Equatable {
        case okx(
            name: String? = "",
            bestPrice: String? = ""
//            countryCode: String? = "",
//            sourceAmount: String? = "",
//            sourceCurrencyCode: String? = "",
//            destinationCurrencyCode: String? = "",
//            walletAddress: String? = "",
//
//            networkType: String? = "",
//            tokenAddress: String? = ""
        )
        case changeNow(
            name: String? = "",
            bestPrice: String? = ""
//            from: String? = "",
//            toAddress: String? = "",
//            fiatMode: Bool? = false,
//            amount: String? = "",
//            recipientAddress: String? = ""
        )
      
        case rango(
            name: String? = "",
            bestPrice: String? = ""
//            apiKey: String? = "",
//            walletAddress: String? = "",
//            fiatAmount: String? = "",
//            chainId: String? = "",
//            tokenAddress: String? = "",
//            tokenSymbol: String? = ""
        )
    }
}

struct SwapProviders {
    let name: String?
    var bestPrice: String?
    var swapperFee : String?
}
// MARK: - RangoSwapData  for Get Quote
struct RangoSwapData: Codable {
    let requestID, resultType: String?
    let route: Route?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case resultType, route, error
    }
}

// MARK: - Route
struct Route: Codable {
    let outputAmount, outputAmountMin: String?
    let outputAmountUsd: Double?
    let swapper: Swapper?
    let from, to: From?
    let fee: [Fee]?
    let feeUsd: Double?
    let amountRestriction: String?
    let estimatedTimeInSeconds: Int?
    let path: [Path]?
}

// MARK: - Fee
struct Fee: Codable {
    let token: From?
    let expenseType, amount, name: String?
}

// MARK: - From
struct From: Codable {
    let blockchain, symbol: String?
    let name: String?
    let isPopular: Bool?
    let chainID: String?
    let address: String?
    let decimals: Int?
    let image: String?
    let blockchainImage: String?
    let usdPrice: Double?
    let supportedSwappers: [String]?

    enum CodingKeys: String, CodingKey {
        case blockchain, symbol, name, isPopular
        case chainID = "chainId"
        case address, decimals, image, blockchainImage, usdPrice, supportedSwappers
    }
}

// MARK: - Path
struct Path: Codable {
    let swapper: Swapper?
    let swapperType: String?
    let from, to: From?
    let inputAmount, expectedOutput: String?
    let estimatedTimeInSeconds: Int?
}

// MARK: - Swapper
struct Swapper: Codable {
    let id, title: String?
    let logo: String?
    let swapperGroup: String?
    let types: [String]?
    let enabled: Bool?
}


// MARK: - RangoSwapingData for Swap
struct RangoSwapingData: Codable {
    let requestID, resultType: String?
    let route: Routes?
    let error: String?
    let tx: TxSWap?

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case resultType, route, error, tx
    }
}

// MARK: - Route
struct Routes: Codable {
    let outputAmount, outputAmountMin: String?
    let outputAmountUsd: Double?
    let swapper: Swappers?
    let from, to: Froms?
    let fee: [Fees]?
    let feeUsd: Double?
    let amountRestriction: String?
    let estimatedTimeInSeconds: Int?
    let path: [Paths]?
}

// MARK: - Fee
struct Fees: Codable {
    let token: From?
    let expenseType, amount, name: String?
}

// MARK: - From
struct Froms: Codable {
    let blockchain, symbol: String?
    let name: String?
    let isPopular: Bool?
    let chainID: String?
    let address: String?
    let decimals: Int?
    let image: String?
    let blockchainImage: String?
    let usdPrice: Double?
    let supportedSwappers: [String]?

    enum CodingKeys: String, CodingKey {
        case blockchain, symbol, name, isPopular
        case chainID = "chainId"
        case address, decimals, image, blockchainImage, usdPrice, supportedSwappers
    }
}

// MARK: - Path
struct Paths: Codable {
    let swapper: Swappers?
    let swapperType: String?
    let from, to: Froms?
    let inputAmount, expectedOutput: String?
    let estimatedTimeInSeconds: Int?
}

// MARK: - Swapper
struct Swappers: Codable {
    let id, title: String?
    let logo: String?
    let swapperGroup: String?
    let types: [String]?
    let enabled: Bool?
}

// MARK: - Tx
struct TxSWap: Codable {
    let type: String?
    let blockChain: BlockChain?
    let from, txTo: String?
    let approveTo, approveData: String?
    let txData, value, gasLimit, gasPrice: String?
    let priorityGasPrice, maxGasPrice: String?
}

// MARK: - BlockChain
struct BlockChain: Codable {
    let name: String?
    let defaultDecimals: Int?
    let addressPatterns: [String]?
    let feeAssets: [FeeAsset]?
    let type, chainID: String?

    enum CodingKeys: String, CodingKey {
        case name, defaultDecimals, addressPatterns, feeAssets, type
        case chainID = "chainId"
    }
}

// MARK: - FeeAsset
struct FeeAsset: Codable {
    let blockchain, symbol: String?
    let address: String?
}
