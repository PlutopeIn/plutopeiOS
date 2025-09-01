//
//  BankCardPayOutModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/07/24.
//

import Foundation

// MARK: - CardPaymentData
struct AddCardPayout: Codable {
    let cardHolder: String?
    let cardNumber: String?
    let cardExpirationYear, cardExpirationMonth: Int?
}
// MARK: - PayOutOtherData
struct PayOutOtherData: Codable {
    let status: Int?
    let message: String?
    let data: PayOutOtherDataList?
}

// MARK: - Datum
struct PayOutOtherDataList: Codable {
    let cards: [PayOutCard]?
    let validSeconds: Int?
    let pairs: [PayOutPair]?
    let fees: PayOutFees?
}

// MARK: - PayOutCard
struct PayOutCard: Codable {
    let maskedPan: String?
    let cardID: Int?
    let pairsLimits: [PayOutPairsLimit]?
    let validationStatus: String?

    enum CodingKeys: String, CodingKey {
        case maskedPan
        case cardID = "cardId"
        case pairsLimits, validationStatus
    }
}

// MARK: - PayOutPairsLimit
struct PayOutPairsLimit: Codable {
    let currencyFrom, currencyTo: String?
    let minAmountFrom, maxAmountFrom, allAmountFrom: PriceValue?
}

// MARK: - PayOutFees
struct PayOutFees: Codable {
    let rate, transactionFee, additionalFee, crypteriumGas: PriceValue?
    let partnerFee, fixFee: PriceValue?
}

// MARK: - PayOutPair
struct PayOutPair: Codable {
    let rate: PriceValue?
    let currencyFrom, currencyTo: String?
    let defaultMinAmountFrom, defaultMaxAmountFrom: PriceValue?
    let defaultMaxAmountAll: PriceValue?
}
// MARK: - ExchangeOfferData
struct PayOutCreateOfferData: Codable {
    let status: Int?
    let message: String?
    let data: PayOutCreateOfferList?
}

// MARK: - PayOutCreateOfferList
struct PayOutCreateOfferList: Codable {
    let offerID, validSeconds, amount: Int?
    let currencyFrom: String?
    let amountTo: Double?
    let currencyTo: String?
    let rate: Double?
    let feeInfo: [PayOutFeeInfo]?
    let possibleToExecute: Bool?
    let limit: PayOutLimit?

    enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case validSeconds, amount, currencyFrom, amountTo, currencyTo, rate, feeInfo, possibleToExecute, limit
    }
}

// MARK: - FeeInfo
struct PayOutFeeInfo: Codable {
    let currency, name: String?
    let scale: Int?
    let value: Double?
    let type: String?
}

// MARK: - Limit
struct PayOutLimit: Codable {
    let value: Double?
    let currency: String?
}

// MARK: - PayinAddCardData
struct PayOutAddCardData: Codable {
    let status: Int?
    let message : String?
    let data: [PayOutAddCardList]?
}
struct PayOutAddCardList: Codable {
    
}
// MARK: - ExecutePayOutOfferData
struct ExecutePayOutOfferData: Codable {
    let status: String?
    let amountFrom: Int?
    let currencyFrom: String?
    let amountTo: Double?
    let currencyTo: String?
}
