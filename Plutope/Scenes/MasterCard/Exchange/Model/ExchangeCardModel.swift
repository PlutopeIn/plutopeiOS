//
//  ExchangeCardModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/06/24.
//

import Foundation
// MARK: - ExchangeCurrencyData
struct ExchangeCurrencyData: Codable {
    let status: Int?
    let message:String?
    let data: ExchangeCurrencyList?
}

// MARK: - ExchangeCurrencyList
struct ExchangeCurrencyList: Codable {
    let pairs: [ExchangeCurrencyPair]?
}

// MARK: - ExchangeCurrencyPair
struct ExchangeCurrencyPair: Codable {
    let rateValue: PriceValue?
    let currencyFrom, currencyTo: String?
    let minAmountFrom, maxAmountFrom : PriceValue?
//    let minAmountTo, maxAmountTo: PriceValue?
  //  let amountScaleFrom, amountScaleTo: Int?
  //  let lock: Bool?
    let allAmountFrom: PriceValue?
    //let rateScale: Int?
    enum CodingKeys: String, CodingKey {
        case rateValue = "rate"
        case currencyFrom, currencyTo,minAmountFrom, maxAmountFrom,allAmountFrom
    }
}
// MARK: - ExchangeOfferData
struct ExchangeOfferData: Codable {
    let status: Int?
    let message:String?
    let data: ExchangeOfferList?
}

// MARK: - DataClass
struct ExchangeOfferList: Codable {
    let offerID: Int?
    let expirationDateTime: String?
    let exchangeRate: PriceValue?
   // let validSeconds: Int?
    let sourceCurrencyAmount, targetCurrencyAmount: CurrencyAmount?

    enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case expirationDateTime, exchangeRate, sourceCurrencyAmount, targetCurrencyAmount
    }
}

// MARK: - CurrencyAmount
struct CurrencyAmount: Codable {
    let amount: PriceValue?
    let currencyCode: String?
}
