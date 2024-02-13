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
