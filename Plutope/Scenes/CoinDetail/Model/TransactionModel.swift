//
//  TransactionModel.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//
import UIKit
// MARK: - TransactionData
struct TransactionData: Codable {
    let code, msg: String?
    let data: [Transactions]?
}
// MARK: - Datum
struct Transactions: Codable {
    let page, limit, totalPage, chainFullName: String?
    let chainShortName: String?
    let transactionLists: [TransactionResult]?
}

// MARK: - TransactionResult
struct TransactionResult: Codable {
    let txID: String?
    let methodID: String?
    let blockHash, height, transactionTime: String?
    let from: String?
    let to: String?
    let isFromContract, isToContract: Bool?
    let amount: String?
    let transactionSymbol: String?
    let txFee: String?
    let state: String?
    let tokenID, tokenContractAddress, challengeStatus, l1OriginHash: String?
    var isSwap: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case txID = "txId"
        case methodID = "methodId"
        case blockHash, height, transactionTime, from, to, isFromContract, isToContract, amount, transactionSymbol, txFee, state
        case tokenID = "tokenId"
        case tokenContractAddress, challengeStatus, l1OriginHash
    }
}

struct TransactionHistory: Hashable {
    let from: String?
    let to: String?
    let transactionTime: String?
    let amount: String?
    let title: String?
    let symbol: String?
    
    // Implement the equality function
    static func == (lhs: TransactionHistory, rhs: TransactionHistory) -> Bool {
        return lhs.from == rhs.from &&
            lhs.to == rhs.to &&
            lhs.transactionTime == rhs.transactionTime &&
            lhs.amount == rhs.amount &&
            lhs.title == rhs.title &&
            lhs.symbol == rhs.symbol
    }
}
