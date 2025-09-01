//
//  MyCardModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import Foundation
// MARK: - MyCardListData
struct MyCardListData: Codable {
    let status: Int?
    let data: MyCardList?
}

// MARK: - MyCardList
struct MyCardList: Codable {
    let cards: [Card]?
//    let iban: JSONNull?
}

// MARK: - MyCardListNew
struct MyCardListNew: Codable {
    let cards: [Card]?
//    let iban: JSONNull?
}
// MARK: - Card
struct Card: Codable {
    let cardType, status, cardCompany: String?
    let cardRequestID: Int?
    let additionalStatuses: [String]?
    let cardDesignID, cardProgram: String?
    let id: Int?
    let expired: String?
    let number: String?
    let balance: Balance?
    let cardholderName: String?
    let monthlyIncome, monthlyExpenses: Balance?

    enum CodingKeys: String, CodingKey {
        case cardType, status, cardCompany
        case cardRequestID = "cardRequestId"
        case additionalStatuses
        case cardDesignID = "cardDesignId"
        case cardProgram, id, number, balance, cardholderName, monthlyIncome, monthlyExpenses,expired
        //
    }
}

// MARK: - Balance
struct Balance: Codable {
    let value: PriceValue?
    let currency: String?
}
enum PriceValue: Codable {
    case int(Int)
    case double(Double)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "MarketCap value is not valid")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }
}
struct UpdateCardHolderAddress {
      let country : String?
      let documentCountry : String?
      let city : String?
      let state : String?
      let address : String?
      let address2 : String?
      let postalCode : String?
      let cardholderName : String? 
}
// MARK: - CountryWiseStateData
struct CountryWiseStateData: Codable {
    let error: Bool?
    let msg: String?
    let data: CountryWiseStateList?
}

// MARK: - CountryWiseStateList
struct CountryWiseStateList: Codable {
    let name, iso3, iso2: String?
    let states: [StatesList]?
}

// MARK: - StatesList
struct StatesList: Codable {
    let name, stateCode: String?

    enum CodingKeys: String, CodingKey {
        case name
        case stateCode = "state_code"
    }
}
// MARK: - StateWiseCityData
struct StateWiseCityData: Codable {
    let error: Bool?
    let msg: String?
    let data: [String]?
}
// MARK: - CountryListData
struct CountryListData: Codable {
    let error: Bool?
    let msg: String?
    let data: [CountryList]?
}

// MARK: - CountryList
struct CountryList: Codable {
    let iso2, iso3, country: String?
//    let cities: [String]?
}
// MARK: - CredPriceData
struct CardPriceData: Codable {
    let status: Int?
    let data: CardPrices?
}

// MARK: - DataClass
struct CardPrices: Codable {
    let prices: [CardPriceList]?
}

// MARK: - CardPriceList
struct CardPriceList: Codable {
    let cardType, currency: String?
    let price, delivery: PriceValue?
    let cardProgram, cardDesignID: String?

    enum CodingKeys: String, CodingKey {
        case cardType, currency, price, delivery, cardProgram
        case cardDesignID = "cardDesignId"
    }
}
// MARK: - CardPaymentData
struct CardPaymentData: Codable {
    let status: Int?
    let data: CardPaymentValue?
}

// MARK: - CardPaymentValue
struct CardPaymentValue: Codable {
    let fiatPrice, cryptoPrice: CryptoPrice?
    let card, delivery: CardDetail?
    let address: CardHolderAddress?
}

// MARK: - Address
struct CardHolderAddress: Codable {
    let country, city, state, address: String?
    let postalCode: String?
}

// MARK: - Card
struct CardDetail: Codable {
    let fiat, crypto: CryptoPrice?
}

// MARK: - CryptoPrice
struct CryptoPrice: Codable {
    let value: PriceValue?
    let currency: String?
}

// MARK: - AdditionalInfoData
struct AdditionalInfoData: Codable {
    let status: Int?
    let data: AdditionalInfoList?
}

// MARK: - AdditionalInfoList
struct AdditionalInfoList: Codable {
    let taxID, taxCountry, usRelatedPerson: String?
  //  let estimatedMonthlyTurnoverRange,incomeSource,dataCorrectnessConfirmation: String?
    let usRelated: Bool?

    enum CodingKeys: String, CodingKey {
        case taxID = "taxId"
        case taxCountry, usRelatedPerson,usRelated
    }
        //, incomeSource, estimatedMonthlyTurnoverRange, dataCorrectnessConfirmation,

}

// MARK: - NewsData
struct GetAdditionalInfoList: Codable {
    let taxID, taxCountry: String?
    let isUsRelated: Bool?
    let usRelatedPerson, incomeSource, estimatedMonthlyTurnoverRange: String?
    let dataCorrectnessConfirmation: Bool?

    enum CodingKeys: String, CodingKey {
        case taxID = "taxId"
        case taxCountry, isUsRelated, usRelatedPerson, incomeSource, estimatedMonthlyTurnoverRange, dataCorrectnessConfirmation
    }
}
// MARK: - DashboardImageData
struct DashboardImageData: Codable {
    let status: Int?
    let message: String?
    let data: [String]?
}

// MARK: - DataClass
struct DashboardImageList: Codable {
    let image1, image2, image3, image4: String?
    let image5: String?
}
