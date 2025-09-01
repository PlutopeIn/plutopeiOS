//
//  SendCardTokenModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import Foundation

// MARK: - GetTokenFeeData
struct GetTokenFeeData: Codable {
    let status: Int?
    let data: GetTokenFeeList?
}

// MARK: - GetTokenFeeList
struct GetTokenFeeList: Codable {
    let fee: PriceValue?
    let sourceCurrency, transactionType: String?
    let transactionAvailability: Bool?
}
// MARK: - WalletSendValidateData
//struct WalletSendValidateData: Codable {
//    let status: Int?
//    let data: WalletSendValidateList?
//}

// MARK: - WalletSendValidateList
struct WalletSendValidateList: Codable {
    let possibleToExecute: Bool?
    let blockedAmount: BlockedAmount?
}

// MARK: - BlockedAmount
struct BlockedAmount: Codable {
    let value: Int?
    let currency: String?
}


// MARK: - WalletSendValidateData
struct WalletSendData: Codable {
    let status: Int?
    let message: String?
    let data: WalletSendList?
}

// MARK: - DataClass
struct WalletSendList: Codable {
    let sequenceID: String?
    let fee: Int?
    let dataInternal, sendConfirmation: Bool?

    enum CodingKeys: String, CodingKey {
        case sequenceID = "sequenceId"
        case fee
        case dataInternal = "internal"
        case sendConfirmation
    }
}


//MARK: - WalletSendViaWalletData
struct WalletSendViaWalletData: Codable {
    let status: Int?
    let message: String?
    let data: WalletSendViaWalletList?
}

// MARK: - WalletSendViaWalletList
struct WalletSendViaWalletList: Codable {
    let txID, sequenceID: String?
    let fee: Double?
    let dataInternal, sendConfirmation: Bool?

    enum CodingKeys: String, CodingKey {
        case txID = "txId"
        case sequenceID = "sequenceId"
        case fee
        case dataInternal = "internal"
        case sendConfirmation
    }
}
