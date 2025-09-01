//
//  TopUpCardModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 28/05/24.
//

import Foundation

struct PriceDataValues {
    var description :String
    var isSelected : Bool
}
//// MARK: - reateCardPayloadOfferData
struct TopUpCurrencys: Codable {
    let currencies: [String]?
}
// MARK: - Datum
struct CreateCardPayloadOfferList: Codable {
    let offerID: Int?
       let expirationTime: String?

       enum CodingKeys: String, CodingKey {
           case offerID = "offerId"
           case expirationTime
       }
}
//// MARK: - CreateCardPayloadOfferList
//struct CreateCardPayloadOfferList: Codable {
//    let offerID: Int?
//   // let expirationTime: String?
//  //  let from, to: FromCurrency?
//   // let fees: CardFees?
//   // let rate: FromCurrency?
//   // let possibleToExecute: Bool?
//  
//    enum CodingKeys: String, CodingKey {
//        case offerID = "offerId"
//       // case expirationTime, from,to, fees, rate //, limit //,possibleToExecute
//    }
//}

// MARK: - CardFees
struct CardFees: Codable {
    //let transactionFee, additionalFee: String?
    let vaultFee, supplierFee: PriceValue?
    let clientMarkUpFee: PriceValue?
}

// MARK: - FromCurrency
struct FromCurrency: Codable {
    let value: PriceValue?
    let currency: String?
}

// MARK: - PayloadOtherData
struct PayloadOtherData: Codable {
    let status: Int?
    let data: PayloadOtherList?
}

// MARK: - PayloadOtherList
struct PayloadOtherList: Codable {
    let card: PayloadCard?
    let fees: PayloadFees?
    let pairs: [PayloadPair]?
}

// MARK: - PayloadCard
struct PayloadCard: Codable {
    let cardID: Int?
    let maskedPan, cardCompany: String?
    let cardBalance: CardBalance?

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case maskedPan, cardCompany, cardBalance
    }
}

// MARK: - CardBalance
struct CardBalance: Codable {
    let value: PriceValue?
    let currency: String?
}

// MARK: - PayloadFees
struct PayloadFees: Codable {
    let transactionFee, additionalFee: PriceValue?
    let vaultFee, supplierFee: PriceValue?
    let clientMarkUpFee: PriceValue?
}

// MARK: - PayloadPair
struct PayloadPair: Codable {
    let rate: PriceValue?
    let currencyFrom, currencyTo: String?
//    let amountScaleFrom, amountScaleTo: Int?
    let fromLimits, toLimits: PayLoadLimits?
}

// MARK: - PayLoadLimits
struct PayLoadLimits: Codable {
    let min, max: PriceValue?
    let all: PriceValue?
}
// MARK: - PayloadCurrencyData
struct PayloadCurrencyData: Codable {
    let status: Int?
    let data: PayloadCurrencyList?
}

// MARK: - DataClass
struct PayloadCurrencyList: Codable {
    let currencies: [String]?
}
