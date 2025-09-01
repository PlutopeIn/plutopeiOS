//
//  AllTranscationHistryModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import Foundation

struct AllTransactionHistrySection {
    let date: String?
    var data: [AllTransactionHistryDataList]?
}
struct SingleTransactionHistrySection {
    let date: String?
    var data: [SingleTransactionHistry]?
}
// MARK: - CardHistoryData
struct SingleWalletHistoryData: Codable {
    let status: Int?
    let message: String?
    let data: [SingleTransactionHistry]?
}

// MARK: - SingleTransactionHistry
struct SingleTransactionHistry: Codable {
    let operationID, operationDate: String?
    let operationStatus: String?
    let sequenceID: String?
    let payinCardModel: SingleTransactionPayinCardModel?
    let payoutCardModel: PayoutCardModel?
    let receiveCryptoModel: ReceiveCryptoModel?
    let cardIssueModel: CardIssueModel?
    let sendToPhoneModel: SendToPhoneModel?
    let sendToWalletModel: SendToWalletModel?
    let exchangeModel: ExchangeCardModel?
   
    enum CodingKeys: String, CodingKey {
        case operationID = "operationId"
        case operationDate, operationStatus
        case sequenceID = "sequenceId"
        case  payinCardModel, payoutCardModel, receiveCryptoModel,cardIssueModel,sendToPhoneModel, sendToWalletModel,exchangeModel
//        case type,title,depositLockInModel, depositUnlockModel, depositInterestModel, type, payinCardModel, payoutCardModel, receiveCryptoModel        case depositLockInModel, depositUnlockModel, depositInterestModel, type, sendToPhoneModel, sendToWalletModel, receiveCryptoModel

    }
}
typealias SingleTransactionHistryData = [SingleTransactionHistry]
struct SingleTransactionHistry1: Codable {
    let operationID, operationDate: String?
    let operationStatus: String?
    let sequenceID: String?
    var title: String?
   // let depositLockInModel, depositUnlockModel, depositInterestModel: JSONNull?
    var type: String?
    let payinCardModel: SingleTransactionPayinCardModel?
    let payoutCardModel: PayoutCardModel?
    let receiveCryptoModel: ReceiveCryptoModel?
    let cardIssueModel: CardIssueModel?
    let sendToPhoneModel: SendToPhoneModel?
    let sendToWalletModel: SendToWalletModel?
    let exchangeModel: ExchangeCardModel?
    
    enum CodingKeys: String, CodingKey {
        case operationID = "operationId"
        case operationDate, operationStatus
        case sequenceID = "sequenceId"
        case type, payinCardModel, payoutCardModel, receiveCryptoModel,cardIssueModel,sendToPhoneModel, sendToWalletModel,title,exchangeModel
//        case depositLockInModel, depositUnlockModel, depositInterestModel, type, payinCardModel, payoutCardModel, receiveCryptoModel        case depositLockInModel, depositUnlockModel, depositInterestModel, type, sendToPhoneModel, sendToWalletModel, receiveCryptoModel

    }
}
// MARK: - PayinCardModel
struct SingleTransactionPayinCardModel: Codable {
    let fromCardPAN: String?
    let toAddress: String?
    let debitAmount, creditAmount, feeAmount: Amount?
    let exchangeRate: ExchangeRate?
}
// MARK: - AllTransactionHistry
struct AllTransactionHistry: Codable {
    let page: Int?
    // let limit: Int?
    let totalPage: Int?
    let finalResponse: [AllTransactionHistryDataList]?
}
// MARK: - AllTransactionHistryData
struct AllTransactionHistryData: Codable {
    let status: Int?
    let message: String?
    var data: AllTransactionHistry?
}

// MARK: - Datum
struct AllTransactionHistryDataList: Codable {
    let operationID, operationDate: String?
    let operationStatus: String?
    let sequenceID: String?
  //  let depositLockInModel, depositUnlockModel, depositInterestModel: JSONNull?
    let type: String?
    let title: String?
    let fromCardPAN: String?
    let creditAmount: PriceValue?
    let transactionType: String?
    let payinCardModel: PayinCardModel?
    let toCardPAN: String?
    let debitAmount, feeAmount: PriceValue?
    let payoutCardModel: PayoutCardModel?
    let toAddress: String?
    let amount: PriceValue?
    let receiveCryptoModel: ReceiveCryptoModel?
    let cardIssueModel: CardIssueModel?
    let sendToPhoneModel: SendToPhoneModel?
    let sendToWalletModel: SendToWalletModel?
    let exchangeModel: ExchangeCardModel?
    enum CodingKeys: String, CodingKey {
        case operationID = "operationId"
        case operationDate, operationStatus
        case sequenceID = "sequenceId"
        case type, title, fromCardPAN, creditAmount, transactionType, payinCardModel, toCardPAN, debitAmount, feeAmount, payoutCardModel, toAddress, amount, receiveCryptoModel,cardIssueModel,sendToWalletModel,sendToPhoneModel,exchangeModel
        //case exchangeModel, payinAdvcashModel, sendToWalletModel, sendToPhoneModel, depositLockInModel, depositUnlockModel, depositInterestModel,
    }
}

// MARK: - AllTransactionHistryDataListNewElement
struct AllTransactionHistryDataListNewElement: Codable {
    let operationID, operationDate: String?
    let operationStatus: String?
    let sequenceID: String?
    let exchangeModel: ExchangeCardModel?
    let receiveCryptoModel: ReceiveCryptoModel?
   // let payinAdvcashModel: JSONNull?
    let payinCardModel: PayinCardModel?
    let payoutCardModel: PayoutCardModel?
    let sendToWalletModel: SendToWalletModel?
    let sendToPhoneModel: SendToPhoneModel?
   // let depositLockInModel, depositUnlockModel, depositInterestModel, launchpadClaimModel: JSONNull?
    let cardIssueModel: CardIssueModel?
//    let monthlyLoyaltyRewardModel, giftModel: JSONNull?
    
    var type: String?
    var title: String?

    enum CodingKeys: String, CodingKey {
        case operationID = "operationId"
        case operationDate, operationStatus
        case sequenceID = "sequenceId"
        case exchangeModel, receiveCryptoModel, payinCardModel, payoutCardModel, sendToWalletModel, sendToPhoneModel, cardIssueModel
//        case exchangeModel, receiveCryptoModel, payinAdvcashModel, payinCardModel, payoutCardModel, sendToWalletModel, sendToPhoneModel, depositLockInModel, depositUnlockModel, depositInterestModel, launchpadClaimModel, cardIssueModel, monthlyLoyaltyRewardModel, giftModel
    }
}
// typealias AllTransactionHistryDataListNew = [AllTransactionHistryDataListNewElement]

// MARK: - AllTransactionHistrySectionNew
struct AllTransactionHistrySectionNew {
    let date: String?
    var data: [AllTransactionHistryDataListNewElement]?
}
// MARK: - SendToPhoneModel
struct SendToPhoneModel: Codable {
    let fromAddress, toPhone: String?
    let amount: Amount?
}

// MARK: - SendToWalletModel
struct SendToWalletModel: Codable {
    let fromAddress, toAddress: String?
    let debitAmount, creditAmount, feeAmount: Amount?
    let txHash: String?
}
// MARK: - CardIssueModel
struct CardIssueModel: Codable {
    let fromAddress: String?
    let amount, exchangeAmount: Amount?
    let exchangeRate: ExchangeRate?
    let description: String?
}

// MARK: - PayinCardModel
struct PayinCardModel: Codable {
    let fromCardPAN: String?
    let toAddress: String?
    let debitAmount, creditAmount, feeAmount: Amount?
    let exchangeRate: ExchangeRate?
}
// MARK: - ExchangeCardModel
struct ExchangeCardModel: Codable {
    let fromAddress, toAddress: String?
    let debitAmount, creditAmount: Amount?
    let exchangeRate: ExchangeRate?
}
// MARK: - Amount
struct Amount: Codable {
    let value: PriceValue?
    let currency: String?
}
// MARK: - ExchangeRate
struct ExchangeRate: Codable {
    let sourceCurrency, targetCurrency: String?
    let rate: PriceValue?
    let multiplier: Int?
}

// MARK: - PayoutCardModel
struct PayoutCardModel: Codable {
    let fromAddress: String?
    let toCardPAN: String?
    let debitAmount, creditAmount, feeAmount: Amount?
    let exchangeRate: ExchangeRate?
}

// MARK: - ReceiveCryptoModel
struct ReceiveCryptoModel: Codable {
    let toAddress: String?
    let fromAddress: String?
    let amount: Amount?
    let txHash: String?
}
