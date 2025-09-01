//
//  RegisterUserModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/12/23.
//

import Foundation
// MARK: - WalletData
struct RegisterWalletData: Codable {
    let status: Int?
    let message: String?
    let data: RegisterWalletList?
}

// MARK: - RegisterWalletList
struct RegisterWalletList: Codable {
    let walletAddress: String?
    let appType: Int?
    let isActive: Bool?
    let id: String?
   // let v: Int?
    
    enum CodingKeys: String, CodingKey {
        case walletAddress, appType, isActive
        case id = "_id"
      //  case v = "__v"
    }
}
///
struct ActiveUserTransaction {
    var walletAddress: String?
    var transactionType: TransactionType?
    var providerType: ProvidersType?
    var transactionHash: String?
    var tokenDetailArrayList: [ActiveUserTokenDetail]?
}

struct ActiveUserTokenDetail {
    var from: ActiveUserTokenInfo?
    var to: ActiveUserTokenInfo?
}

struct ActiveUserTokenInfo {
    var chainId: String?
    var address: String?
    var symbol: String?
}
enum TransactionType : String {
    case send = "Send"
    case buy = "buy"
    case swap = "swap"
    case other = "other"
}
enum ProvidersType: String {
    case okx = "OKX"
    case changeNow = "ChangeNow"
    case rango = "Rango"
    case exodus = "Exodus"
    
}
