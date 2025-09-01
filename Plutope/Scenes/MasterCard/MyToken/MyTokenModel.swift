//
//  MyTokenModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
// MARK: - CreateSwapNFTDataModel
struct MyCardDataListModel: Codable {
    let status: Int?
        let message: String?
        let data: [MyCardDataList]?
}

// MARK: - MyCardDataList
struct MyCardDataList: Codable {
    let email: String?
    let confirmedEmail: Bool?
    let phone, firstName, lastName, primaryCurrency: String?
    let pushEnabled, enabled2FA: Bool?
    let veroID: String?

    enum CodingKeys: String, CodingKey {
        case email, confirmedEmail, phone, firstName, lastName, primaryCurrency, pushEnabled, enabled2FA
        case veroID = "veroId"
    }
}

// MARK: - CardTokenData
struct CardTokenData: Codable {
    let status: Int?
    let data: CardTokenDataList?
}

// MARK: - CardTokenDataList
struct CardTokenDataList: Codable {
    let wallets: [Wallet]?
    let account: [AccountValueList]?
    let fiat: Fiat?
}

// MARK: - AccountValueList
struct AccountValueList: Codable {
    let name: String?
    let availableBalance: PriceValue?
    let balance: PriceValue?
    let color: String?
    let currency: String?
    let status: String?
    let scale: Int?
//    let details: String?
    let kyc: Kyc?
    let createdAt, iconURL: String?

    enum CodingKeys: String, CodingKey {
        case name, availableBalance, balance, color, currency, status, kyc, createdAt
        case iconURL = "iconUrl"
        case scale
        // case details
    }
}

// MARK: - Kyc
struct Kyc: Codable {
    let status: String?
    let rejectReason: String?
}

// MARK: - Fiat
struct Fiat: Codable {
    var customerCurrency: String?
    var amount: PriceValue?
    let change: PriceValue?
    let changePercent: PriceValue?
    var rate: PriceValue?
}

// MARK: - Wallet
struct Wallet: Codable {
    let id: Int?
    let name: String?
    let address: String?
    var currency: String?
    let baseCurrency: String?
    let pattern: String?
    let balance: PriceValue?
    let limits: Limits?
    let balanceString: String?
    let availableBalance: PriceValue?
    let customerID: Int?
    let allowOperations: [String]?
    let color: String?
    var fiat: Fiat?
    let scale: Int?
    let stub: Bool?
    let walletCreationState: String?
    let network: String?
    let debit: Bool?
    let image: String?
    let iconUrl:String?

    enum CodingKeys: String, CodingKey {
        case id, name, address, currency, baseCurrency, balance, limits, balanceString, availableBalance
        case customerID = "customerId"
        case color, walletCreationState, network, debit,fiat,image,allowOperations
        case pattern, scale, stub,iconUrl
        //case allowOperations, fiat, scale, stub
        
    }
}

// MARK: - Limits
struct Limits: Codable {
    let payoutCrypto: PayoutCrypto?

    enum CodingKeys: String, CodingKey {
        case payoutCrypto = "PAYOUT_CRYPTO"
    }
}

// MARK: - PayoutCrypto
struct PayoutCrypto: Codable {
    let min, all: Double?
}
enum AmountValue: Codable {
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

// MARK: - CreateWalletData
struct CreateWalletData: Codable {
    let status: Int?
    let message: String?
    let data: CreateWalletList?
}

// MARK: - CreateWalletList
struct CreateWalletList: Codable {
    let wallets: [CreateWalletDataList]?
}

// MARK: - CreateWallets
struct CreateWallets: Codable {
    let id: Int?
    let name, address, currency, baseCurrency: String?
}
// MARK: - Wallet
struct CreateWalletDataList: Codable {
    let id: Int?
    let name, address, currency, baseCurrency: String?
    let pattern: String?
    let balance: Int?
    let limits: Limits?
    let balanceString: String?
    let availableBalance, customerID: Int?
    let allowOperations: [String]?
    let color: String?
    let fiat: Fiat?
    let scale: Int?
    let stub: Bool?
    let walletCreationState, network: String?
    let debit: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, address, currency, baseCurrency, pattern, balance, limits, balanceString, availableBalance
        case customerID = "customerId"
        case allowOperations, color, fiat, scale, stub, walletCreationState, network, debit
    }
}


