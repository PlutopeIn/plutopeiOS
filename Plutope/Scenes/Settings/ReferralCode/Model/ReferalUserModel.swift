//
//  ReferalUserModel.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 11/07/24.
//

import Foundation

// MARK: - ReferalUserDataModel
struct ReferalUserDataModel: Codable {
    let status: Int?
    let message:String?
    let data: [ReferalUserDataList]?
}

// MARK: - ReferalUserDataList
struct ReferalUserDataList: Codable {
    let id, deviceID, walletAddress, walletAction: String?
    let appType: Int?
    let isClaim: Bool?
    let referralCode: String?
    let isActive: Bool?
    let createdAt, updatedAt: String?
//    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deviceID = "deviceId"
        case walletAddress, walletAction, appType, isClaim
        case referralCode = "referral_code"
        case isActive, createdAt, updatedAt
//        case v = "__v"
    }
}

// MARK: - UpdateClaimDataModel
struct UpdateClaimDataModel: Codable {
    let status: Int?
    let message:String?
    let data: [UpdateClaimDataList]?
}
// MARK: - ReferalUserDataList
struct UpdateClaimDataList: Codable {
    let id, deviceID, walletAddress, walletAction: String?
    let appType: Int?
    let isClaim: Bool?
    let referralCode: String?
    let isActive: Bool?
    let createdAt, updatedAt: String?
//    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deviceID = "deviceId"
        case walletAddress, walletAction, appType, isClaim
        case referralCode = "referral_code"
        case isActive, createdAt, updatedAt
//        case v = "__v"
    }
}
