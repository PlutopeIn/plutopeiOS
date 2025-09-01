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
    var transactionSymbol: String?
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

//// MARK: - TransactionHistoryDataNew
//struct TransactionHistoryDataNew: Codable {
//    let message: String?
//    let total: Int?
//    let cursor: String?
//    let data: [TransactionHistoryResult]?
//}
//
//// MARK: - Datum
//struct TransactionHistoryResult: Codable {
//    let type: String?
//    let timestamp, hash: String?
//    let transcationType: String?
//    let noOfLogs: Int?
//    var value: String?
//    let gas, gasPrice: String?
//    let fromAddress: String?
//    let toAddress: String?
//    let label: String?
//    let swapToken: [String]?
//    let swapTranscation: [SwapTranscationHistory]?
//    let method: String?
//    let state: String? = ""
//
//    enum CodingKeys: String, CodingKey {
//        case type, timestamp, hash
//        case transcationType = "transcation_type"
//        case noOfLogs = "no_of_logs"
//        case value, gas
//        case gasPrice = "gas_price"
//        case fromAddress = "from_address"
//        case toAddress = "to_address"
//        case label
//        case swapToken = "swap_token"
//        case swapTranscation = "swap_transcation"
//        case method
//    }
//}
//
//// MARK: - SwapTranscationHistory
//struct SwapTranscationHistory: Codable {
//    let contract: String?
//    let from: String?
//    let to, value: String?
//    let foundToken: FoundToken?
//}
//
//// MARK: - FoundToken
//struct FoundToken: Codable {
//    let name, symbol, id: String?
//}

//// MARK: - TransactionDataNew
//struct TransactionDataNew: Codable {
//    let cursor: String?
//    let pageSize, page: Int?
//    let result: [TransactionResultNew]?
//
//    enum CodingKeys: String, CodingKey {
//        case cursor
//        case pageSize = "page_size"
//        case page, result
//    }
//}

// MARK: - TokenTransactionHistoryDataNew
struct TransactionHistoryDataNew: Codable {
    let message: String?
    let data: [TransactionHistoryResult]?
    let total: Int?
    let cursor: String?
}

// MARK: - Datum
struct TransactionHistoryResult: Codable {
    let type, timestamp, hash, transcationType: String?
    let noOfLogs: Int?
    let formattedValue : FormatedValue?
    let value, gas, gasPrice: String?
    let fromAddress, toAddress, label: String?
//    let swapToken: [String]?
//    let swapTranscation: [FromArray]?
    let method, transactionFee, nonce: String?
//    let toArray, fromArray: [FromArray]?
    let receiptStatus : String?
    enum CodingKeys: String, CodingKey {
        case type, timestamp, hash
        case transcationType = "transcation_type"
        case noOfLogs = "no_of_logs"
        case value, gas
        case formattedValue = "formatted_value"
        case gasPrice = "gas_price"
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case label
//        case swapToken = "swap_token"
//        case swapTranscation = "swap_transcation"
        case method
        case transactionFee = "transaction_fee"
        case nonce
//        case toArray = "to_array"
//        case fromArray = "from_array"
        case receiptStatus = "receipt_status"
    }
}

enum FormatedValue: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value is not a valid Int or String")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
    
}
extension FormatedValue {
    var stringValue: String {
        switch self {
        case .int(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
}
// MARK: - FromArray
struct FromArray: Codable {
    let contract, from, to, value: String?
    let foundToken: FoundToken?
    let decoded: Decoded?
}

// MARK: - Decoded
struct Decoded: Codable {
    let label, signature, type: String?
    let params: [Param]?
}

// MARK: - Param
struct Param: Codable {
    let name: String?
    let type: String?
    let value: String?
}

// MARK: - FoundToken
struct FoundToken: Codable {
    let id, symbol, name: String?
    let platforms: Platforms?
}

// MARK: - Platforms
struct Platforms: Codable {
    let ethereum, polygonPos: String?

    enum CodingKeys: String, CodingKey {
        case ethereum
        case polygonPos = "polygon-pos"
    }
}
