//
//  TransactionDetailModel.swift
//  Plutope
//
//  Created by Mitali Desai on 05/07/23.
//

import Foundation
// MARK: - MarketData
struct TransactionDetailData: Codable {
    let code, msg: String?
    let data: [TransactionDetails]?
}

// MARK: - Datum
struct TransactionDetails: Codable {
    let chainFullName, chainShortName, txid, height: String?
    let transactionTime, amount, transactionSymbol, txfee: String?
    let index, confirm: String?
    let inputDetails, outputDetails: [PutDetail]?
    let state, gasLimit, gasUsed, gasPrice: String?
    let totalTransactionSize, virtualSize, weight, nonce: String?
    let transactionType, methodID, errorLog, inputData: String?
    let tokenTransferDetails: [TokenTransferDetail]?

    enum CodingKeys: String, CodingKey {
        case chainFullName, chainShortName, txid, height, transactionTime, amount, transactionSymbol, txfee, index, confirm, inputDetails, outputDetails, state, gasLimit, gasUsed, gasPrice, totalTransactionSize, virtualSize, weight, nonce, transactionType
        case methodID = "methodId"
        case errorLog, inputData, tokenTransferDetails
    }
}

// MARK: - PutDetail
struct PutDetail: Codable {
    let inputHash: String?
    let isContract: Bool?
    let tag, amount, outputHash: String?
}

// MARK: - TokenTransferDetail
struct TokenTransferDetail: Codable {
    let index, token, tokenContractAddress, symbol: String?
    let from, to, tokenID, amount: String?
    let isFromContract, isToContract: Bool?

    enum CodingKeys: String, CodingKey {
        case index, token, tokenContractAddress, symbol, from, to
        case tokenID = "tokenId"
        case amount, isFromContract, isToContract
    }
}
