//
//  MyCardDetailsModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/05/24.
//

import Foundation
// MARK: - KycLimitData
struct CardInfoData: Codable {
    let status: Int?
    let message : String?
    let data: CardInfoDataList?
}

// MARK: - DataClass
struct CardInfoDataList: Codable {
    let number, cvv, expiry, cardholderName: String?
}
// MARK: - PublicKeyData
struct PublicKeyData: Codable {
    let publicKey, privateKey: String?

    enum CodingKeys: String, CodingKey {
        case publicKey
        case privateKey = "PrivateKey"
    }
}

// MARK: - CardNumberData
struct CardNumberData: Codable {
    let status: Int?
    let message: String?
    let data: CardNumberList?
}

// MARK: - DataClass
struct CardNumberList: Codable {
    let number, cardholderName: String?
}

struct CardHistorySection {
    let date: String?
    var data: [CardHistoryListNew]?
}
// MARK: - CardHistoryData
struct CardHistoryData: Codable {
    let status: Int?
    let message : String?
    let data: CardHistoryList?
}

// MARK: - CardHistoryList
struct CardHistoryList: Codable {
    let page, limit, totalPage, totalOperations: Int?
    let finalResponse: [CardHistoryFinalResponse]?
}

// MARK: - FinalResponse
struct CardHistoryFinalResponse: Codable {
    let operationID, operationDate: String?
    let operationStatus: String?
  //  let authorizationModel, feeModel, atmWithdrawalModel, atmBalanceInquiryModel: JSONNull?
 //   let cardTransactionModel, reversalTransactionModel, defaultTransactionModel, reapAuthTransactionModel: JSONNull?
    let type: String?
    let title: String?
    let amount: PriceValue?
    let currency:String?
    let transactionType: String?
    let reapClearedTransactionModel: ReapClearedTransactionModel?
    let topUpCardModel: CardTopUpCardModel?

    enum CodingKeys: String, CodingKey {
        case operationID = "operationId"
        case operationDate, operationStatus,type, title, amount,currency,transactionType, reapClearedTransactionModel, topUpCardModel
//        case operationDate, operationStatus, authorizationModel, feeModel, atmWithdrawalModel, atmBalanceInquiryModel, cardTransactionModel, reversalTransactionModel, defaultTransactionModel, reapAuthTransactionModel, type, title, amount, transactionType, reapClearedTransactionModel, topUpCardModel
    }
}

// MARK: - ReapClearedTransactionModel
struct ReapClearedTransactionModel: Codable {
    let amount, fee, billAmount: CardAmount?
    let creationDate, processingDate, category, merchantName: String?
}

// MARK: - CardAmount
struct CardAmount: Codable {
    let value: PriceValue?
    let currency: String?
}
// MARK: - TopUpCardModel
struct CardTopUpCardModel: Codable {
    let amount: CardAmount?
    let walletFrom: String?
    let exchangeRate: CardExchangeRate?
    let fee: CardAmount?
}

// MARK: - CardExchangeRate
struct CardExchangeRate: Codable {
    let sourceCurrency, targetCurrency: String?
    let rate :PriceValue
    //let multiplier: Int?
}
struct CardHistoryListNew: Codable {
    let operationID, operationDate: String?
    let operationStatus: String?
    let topUpCardModel: CardTopUpCardModel?
    let reapClearedTransactionModel,reapAuthTransactionModel: ReapClearedTransactionModel?

    enum CodingKeys: String, CodingKey {
        case operationID = "operationId"
        case operationDate, operationStatus, topUpCardModel, reapClearedTransactionModel,reapAuthTransactionModel
        
    }
}
