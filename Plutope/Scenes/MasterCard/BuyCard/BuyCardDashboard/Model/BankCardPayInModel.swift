//
//  BankCardPayInModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 31/05/24.
//

import Foundation
// MARK: - CardPaymentData
struct AddCardPaying: Codable {
    let cardHolder: String?
    let cardNumber: String?
    let zip, city: String?
    let state: String?
    let address, countryCode: String?
    let cardExpirationYear, cardExpirationMonth: String?
}
// MARK: - PayinFiatRatesData
//struct PayinFiatRatesData: Codable {
//    let status: Int?
//    let data: [PayinFiatRates]?
//}
//struct PayinFiatRates: Codable {
//    
//}
struct PayinFiatRates: Codable {
    let baseCurrency, symbolCurrency: String?
    let rate: Double?
}

typealias PayinFiatRate = [PayinFiatRates]
// MARK: - PayinAddCardData
struct PayinCardBillingAddressData: Codable {
    let status: Int?
    let data: [PayinCardBillingAddressList]?
}
struct PayinCardBillingAddressList: Codable {
    
}
// MARK: - PayinAddCardData
struct PayinAddCardData: Codable {
    let status: Int?
    let message : String?
    let data: [PayinAddCardList]?
}
struct PayinAddCardList: Codable {
    
}

// MARK: - PayinOfferCreateData
//struct PayinOfferCreateData: Codable {
//    let status: Int?
//    let message: String?
//    let data: [String]?
////    let data: [PayinOfferCreateList]?
//}
// MARK: - PayinOfferCreateList
//struct PayinOfferCreateList: Codable {
//    
////    let offerID: Int?
////    //let expirationTime: String?
////  //  let validSeconds: Int?
////    let fromCurrency: String?
////    let rate: PayinOfferRate?
////    let feeInfo: [PayinOfferFeeInfo]?
////    let fees: PayinOfferFees?
////
////    enum CodingKeys: String, CodingKey {
////        case offerID = "offerId"
////        case fromCurrency, rate, feeInfo, fees
////    }
//}

// MARK: - FeeInfo
struct PayinOfferFeeInfo: Codable {
    let name: String?
    let value, valueOld: PriceValue?
   // let scale: Int?
    let currency: String?
}

// MARK: - Fees
struct PayinOfferFees: Codable {
    let currency: String?
    let rate, partnerFee, crypteriumGas: PriceValue?
    let additionalFee: PriceValue?
    let transactionFee: PriceValue?
    let insuranceFee: PriceValue?
    //let feeTableEnabled: Bool?
    
}

// MARK: - Rate
struct PayinOfferRate: Codable {
    let rate: PriceValue?
    let currency: String?
  //  let commissionFix, commissionPercentage, minCrypto, maxCrypto: Int?
}
// MARK: - PayinExecuteOfferPaymentData
struct PayinExecuteOfferPaymentData: Codable {
    let status: Int?
    let message: String?
    let data: [PayinExecuteOfferPaymentList]?
}
struct PayinExecuteOfferPaymentList: Codable {
    
}
struct PayinPayCallbackData: Codable {
    let status: Int?
    let message: String?
    let data: PayinPayCallbackList?
}

// MARK: - DataClass
struct PayinPayCallbackList: Codable {
    let offerID: Int?
    let status: String?
//    let amount: Int?
//    let currency: String?
//    let cryptoAmount: Double?
//    let cryptoCurrency, maskedPan, transactionStatus: String?
//    let transactionStatusCode: Int?
//    let originalTransactionStatus: String?
//    let originalTransactionStatusCode: Int?
//    let paymentMode: JSONNull?
  //  let transactionDate, transactionAmount, cardCountryCode, cardCountryName: String?
//    let cardBankName: String?
//    let blockedAmount: BlockedAmount?

    enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case status
//        case status, amount, currency, cryptoAmount, cryptoCurrency, maskedPan, transactionStatus, transactionStatusCode, originalTransactionStatus, originalTransactionStatusCode, paymentMode, transactionDate, transactionAmount, cardCountryCode, cardCountryName, cardBankName, blockedAmount
    }
}

//// MARK: - BlockedAmount
//struct BlockedAmount: Codable {
//    let value: Int?
//    let currency: String?
//}

// MARK: - PayInOtherData
struct PayInOtherData: Codable {
    let status: Int?
    let message: String?
    let data: PayInOtherDataList?
}
// MARK: - PayInOtherDataList
struct PayInOtherDataList: Codable {
    let cards: [PayInCard]?
   // let validTo: String?
//    let validSeconds: Int?
    let pairs: [PayInPair]?
   // let fiatPairs: [JSONAny]?
//    let feeInfo, feeTable: JSONNull?
    let defaultMinAmountFrom, defaultMaxAmountFrom: PriceValue?
   // let firstPurchaseLimit: FirstPurchaseLimit?
 //   let freeTransactionsPromo: FreeTransactionsPromo?
    let fees: PayInFees?
    let billingAddressRequired, firstPurchase: Bool?
}

// MARK: - PayInCard
struct PayInCard: Codable {
    let maskedPan: String?
    let cardID: Int?
    let cardType: String?
 //   let minAmountFrom, maxAmountFrom: Int?
    let validationStatus: String?
    let billingAddressRequired: Bool?

    enum CodingKeys: String, CodingKey {
        case maskedPan
        case cardID = "cardId"
        case cardType, validationStatus, billingAddressRequired
//        case minAmountFrom,maxAmountFrom
    }
}

// MARK: - PayInFees
struct PayInFees: Codable {
    let currency: String?
    let rate : PriceValue
    let scale,partnerFee, crypteriumGas: PriceValue?
    let additionalFee: PriceValue?
    let transactionFee: PriceValue?
    let insuranceFee: PriceValue?
   // let feeTableEnabled: Bool?
  //  let feeTable: JSONNull?
}


// MARK: - FirstPurchaseLimit
struct FirstPurchaseLimit: Codable {
    let value: PriceValue?
    let currency: String?
}

// MARK: - FreeTransactionsPromo
struct FreeTransactionsPromo: Codable {
    let available, total: Int?
}

// MARK: - Pair
struct PayInPair: Codable {
    let rate: PriceValue?
    let currencyFrom: String?
    let currencyTo: String?
    //let amountScaleFrom, amountScaleTo: Int?
    //let lock: Bool?
}
// MARK: - ExchangeOfferData

// Failure response models
struct FailureResponse: Codable {
    let status: Int
    let message: String
    let data: [FailureData]
}


struct PayinCreateOfferList: Codable {
    let offerID: Int?
   // let expirationTime: String?
   // let validSeconds: Int?
    let fromCurrency: String?
   // let rate: Rate?
   // let feeInfo: [FeeInfo]?
  //  let limit: Limit?
  //  let fees: Fees?

    enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case  fromCurrency //, rate, feeInfo
//        expirationTime, validSeconds
    }
}

// MARK: - FeeInfo
struct FeeInfo: Codable {
    let name: String?
    let value, valueOld, scale: Int?
    let currency: String?
}

//// MARK: - Fees
//struct Fees: Codable {
//    let currency: String?
//    let scale, rate, partnerFee, crypteriumGas: Int?
//    let additionalFee, transactionFee, insuranceFee: Int?
//    let feeTableEnabled: Bool?
//    let feeTable: [FeeTable]?
//}
//
//// MARK: - FeeTable
//struct FeeTable: Codable {
//    let amountFrom, amountTo: Limit?
//    let percent: Int?
//}

// MARK: - Limit
struct Limit: Codable {
    let value: Int?
    let currency: String?
}

// MARK: - Rate
struct Rate: Codable {
    let rate: Int?
    let currency: String?
    let commissionFix, commissionPercentage, minCrypto, maxCrypto: Int?
}
struct FailureData: Codable {
    let message: String
    let errorId: Int
    let systemId: String
}
// MARK: - DataClass
struct PayinExecuteeOfferList: Codable {
    let successURL, failURL, cancelURL, authLink: String?
    let offerID: Int?
    let transactionStatus:String?
    //, transactionStatusCode, originalTransactionStatus, originalTransactionStatusCode: Int?
    let paymentMode, maskedPan, transactionDate, transactionAmount: String?
    let cardCountryCode, cardCountryName, cardBankName: String?

    enum CodingKeys: String, CodingKey {
        case successURL = "successUrl"
        case failURL = "failUrl"
        case cancelURL = "cancelUrl"
        case authLink
        case offerID = "offerId"
        case paymentMode, maskedPan, transactionDate, transactionAmount, cardCountryCode, cardCountryName, cardBankName,transactionStatus
       // case transactionStatus, transactionStatusCode, originalTransactionStatus, originalTransactionStatusCode,
    }
}
