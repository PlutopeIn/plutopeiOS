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
//    let amountRestriction: String?
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

// MARK: - Routes
struct Routes: Codable {
    let outputAmount, outputAmountMin: String?
    let outputAmountUsd: Double?
    let swapper: Swappers?
    let from, to: Froms?
    let fee: [Fees]?
    let feeUsd: Double?
 //   let amountRestriction: String?
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

struct SwapQuoteParameters {
    var providerTypeChangeNow: String?
    var providerTypeOkx: String?
    var providerTypeRango: String?
    var address: String?
    var fromCurrency: String?
    var toCurrency: String?
    var fromNetwork: String?
    var toNetwork: String?
    var fromAmount: String?
    var toAmount: String?
    var chainId: String?
    var toTokenAddress: String?
    var fromTokenAddress: String?
    var slippage: String?
    var fromBlockchain: String?
    var fromTokenSymbol: String?
    var toBlockchain: String?
    var toTokenSymbol: String?
    var rangotoTokenAddress: String?
    var fromWalletAddress: String?
    var toWalletAddress: String?
    var price: String?
    var amountToPay : String?
    var mainAmount : String?
}

// MARK: - SwapMeargedData
struct SwapMeargedData: Codable {
    let status: Int?
    let data: [SwapMeargedDataList]?
}




// MARK: - SwapMeargedDataList
struct SwapMeargedDataList: Codable {
    let providerName,name, image: String?
    let quoteAmount: String?
    let response: ResponseData?
}

enum QuoteAmount: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let xValue = try? container.decode(Double.self) {
            self = .double(xValue)
            return
        }
        if let xValue = try? container.decode(String.self) {
            self = .string(xValue)
            return
        }
        throw DecodingError.typeMismatch(QuoteAmount.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for QuoteAmount"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let xValue):
            try container.encode(xValue)
        case .string(let xValue):
            try container.encode(xValue)
        }
    }
}

// MARK: - ResponseData
struct ResponseData: Codable {
    let fromAmount:Double?
    let toAmount: ToAmountUnion?
    let flow, type, payinAddress, payoutAddress: String?
    let fromCurrency, toCurrency, id, fromNetwork: String?
    let toNetwork, code: String?
    let data: [ResponseDataList]?
    let msg, requestID, resultType,message: String?
    let route: SwapRoutes?
    let error: String?
    let amount: SwapAmount?
    let pairID, payInAddress, providerOrderID,exodusStatus: String?
    enum CodingKeys: String, CodingKey {
        case fromAmount, toAmount, flow, type, payinAddress, payoutAddress, fromCurrency, toCurrency, id, fromNetwork, toNetwork, code, data, msg,amount,pairID, payInAddress, providerOrderID,message
        case requestID = "requestId"
        case exodusStatus = "status"
        case resultType, route, error
    }
}

enum ToAmountUnion: Codable {
    case double(Double)
    case toAmountClass(ToAmountClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(ToAmountClass.self) {
            self = .toAmountClass(x)
            return
        }
        throw DecodingError.typeMismatch(ToAmountUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ToAmountUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .toAmountClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - ToAmountClass
struct ToAmountClass: Codable {
    let assetID, value: String

    enum CodingKeys: String, CodingKey {
        case assetID = "assetId"
        case value
    }
}
enum PriceValue1: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        throw DecodingError.typeMismatch(PriceValue1.self, DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "PriceValue1 must be a String or Double"
        ))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}


enum ToAmountType: Codable {
    case amount(SwapAmount)
    case double(Double)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let amount = try? container.decode(SwapAmount.self) {
            self = .amount(amount)
            return
        }
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
            return
        }
        throw DecodingError.typeMismatch(ToAmountType.self, DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "toAmount must be a SwapAmount or Double"
        ))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .amount(let amount):
            try container.encode(amount)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        }
    }
}

// MARK: - SwapAmount
struct SwapAmount: Codable {
    let assetID: String?
    let value: PriceValue1?

    enum CodingKeys: String, CodingKey {
        case assetID = "assetId"
        case value
    }
}
// MARK: - ResponseDataList
struct ResponseDataList: Codable {
    let routerResult: RouterResults?
    let tx: TxData?
}

// MARK: - RouterResults
struct RouterResults: Codable {
    let chainID: String?
    let dexRouterList: [DexRouterListValue]?
    let estimateGasFee: String?
    let fromToken: FromToken?
    let fromTokenAmount: String?
    let toToken: FromToken?
    let toTokenAmount: String?

    enum CodingKeys: String, CodingKey {
        case chainID = "chainId"
        case dexRouterList, estimateGasFee, fromToken, fromTokenAmount, toToken, toTokenAmount
    }
}

// MARK: - DexRouterList
struct DexRouterListValue: Codable {
    let router, routerPercent: String?
    let subRouterList: [SubRouterListValue]?
}

// MARK: - SubRouterListValue
struct SubRouterListValue: Codable {
    let dexProtocol: [DexProtocolValue]?
    let fromToken, toToken: FromToken?
}

// MARK: - DexProtocolValue
struct DexProtocolValue: Codable {
    let dexName, percent: String?
}

// MARK: - Token
struct FromToken: Codable {
    let decimal, tokenContractAddress, tokenSymbol, tokenUnitPrice: String?
}

// MARK: - TxData
struct TxData: Codable {
    let data, from, gas, gasPrice: String?
    let maxPriorityFeePerGas, minReceiveAmount, to, value: String?
}

// MARK: - Route
struct SwapRoutes: Codable {
    let outputAmount, outputAmountMin: String?
    let outputAmountUsd: Double?
    let swapper: SwapperValue?
    let from, to: FromData?
    let fee: [FeeValue]?
    let feeUsd: Double?
//    let amountRestriction: JSONNull?
    let estimatedTimeInSeconds: Int?
    let path: [PathData]?
}

// MARK: - Fee
struct FeeValue: Codable {
    let token: FromData?
    let expenseType, amount, name: String?
}

// MARK: - From
struct FromData: Codable {
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
struct PathData: Codable {
    let swapper: SwapperValue?
    let swapperType: String?
    let from, to: From?
    let inputAmount, expectedOutput: String?
    let estimatedTimeInSeconds: Int?
}

// MARK: - SwapperValue
struct SwapperValue: Codable {
    let id, title: String?
    let logo: String?
    let swapperGroup: String?
    let types: [String]?
    let enabled: Bool?
}
// Define your data model
struct ExchangeProvider: Codable {
    let providerName: String
    let quoteAmount: String
}
// MARK: - ExodusSwapUpdateOrdersData
struct ExodusSwapUpdateOrdersData: Codable {
    let data: ExodusSwapDataList?
}

// MARK: - ExodusSwapDataList
struct ExodusSwapDataList: Codable {
    let amount: ExodusSwapAmount?
    let createdAt, fromAddress, fromTransactionID, id: String?
    let message, pairID, payInAddress, providerOrderID: String?
    let rateID, toAddress, toTransactionID, updatedAt: String?
    let status: String?
    let extraFeatures: ExtraFeatures?

    enum CodingKeys: String, CodingKey {
        case amount, createdAt, fromAddress
        case fromTransactionID = "fromTransactionId"
        case id, message
        case pairID = "pairId"
        case payInAddress
        case providerOrderID = "providerOrderId"
        case rateID = "rateId"
        case toAddress
        case toTransactionID = "toTransactionId"
        case updatedAt, status, extraFeatures
    }
}

// MARK: - ExodusSwapAmount
struct ExodusSwapAmount: Codable {
    let assetID, value: String?

    enum CodingKeys: String, CodingKey {
        case assetID = "assetId"
        case value
    }
}

// MARK: - ExtraFeatures
struct ExtraFeatures: Codable {
    let stringAmounts: String?
}
