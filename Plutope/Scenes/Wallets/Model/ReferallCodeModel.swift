//
//  ReferallCodeModel.swift
//  Plutope
//
//  Created by sonoma on 03/07/24.
//

import Foundation

// MARK: - Welcome
struct ReferallCodeData: Codable {
    let status: Int?
    let message: String?
    let data: ReferallCodeDataList
}

// MARK: - DataClass
struct ReferallCodeDataList: Codable {
   // let isClaim: Bool?
    let id, deviceID, userCode, walletAddress: String?
  //  let isActive: Bool?
  //  let createdAt, updatedAt: String?
//    let v: Int

    enum CodingKeys: String, CodingKey {
      //  case isClaim
        case id = "_id"
        case deviceID = "deviceId"
        case userCode = "user_code"
        case walletAddress
//        case v = "__v"
    }
}


