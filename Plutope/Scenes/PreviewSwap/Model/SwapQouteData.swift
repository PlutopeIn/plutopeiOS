//
//  SwapQouteData.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import Foundation

// MARK: - SwapData
struct SwapData: Codable {
    let code: String?
    let data: [Routers]?
    let msg: String?
}

// MARK: - Datum
struct Routers: Codable {
    let routerResult: RouterResult?
    let tx: Tx?
}

// MARK: - RouterResult
struct RouterResult: Codable {
    let chainID: String?
    let dexRouterList: [DexRouterList]?
    let estimateGasFee: String?
    let fromToken: TokenData?
    let fromTokenAmount: String?
    let toToken: TokenData?
    let toTokenAmount: String?

    enum CodingKeys: String, CodingKey {
        case chainID = "chainId"
        case dexRouterList, estimateGasFee, fromToken, fromTokenAmount, toToken, toTokenAmount
    }
}

// MARK: - DexRouterList
struct DexRouterList: Codable {
    let router, routerPercent: String?
    let subRouterList: [SubRouterList]?
}

// MARK: - SubRouterList
struct SubRouterList: Codable {
    let dexProtocol: [DexProtocol]?
    let fromToken, toToken: TokenData?
}

// MARK: - DexProtocol
struct DexProtocol: Codable {
    let dexName, percent: String?
}

// MARK: - Token
struct TokenData: Codable {
    let tokenContractAddress, tokenSymbol: String?
}

// MARK: - Tx
struct Tx: Codable {
    let data, from, gas, gasPrice: String?
    let minReceiveAmount, to, value: String?
}

struct PreviewSwap {
    let payCoinDetail: Token?
    let getCoinDetail: Token?
    let payAmount: String?
    let getAmount: String?
    let quote: String?
    let paySymbol: String?
    let getSymbol : String?
}
