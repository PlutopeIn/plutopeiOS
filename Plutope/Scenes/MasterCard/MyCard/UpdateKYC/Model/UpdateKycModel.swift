//
//  UpdateKycModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 21/05/24.
//

import Foundation


struct GetKycToken: Codable {
    let token: String?
}
// MARK: - StartKYCData
struct StartKYCData: Codable {
    let status: Int?
    let data: StartKYCId?
}

// MARK: - DataClass
struct StartKYCId: Codable {
    let id: String?
}
// MARK: - KycLimitData
struct KycLimitData: Codable {
    let status: Int?
    let data: [String: KycLimitList]?
    // let data: [KycLimitList]?
}

// MARK: - Datum
struct KycLimitList: Codable {
    let value: Int?
    let currency: String?
}
// MARK: - KycLimitListValue
struct KycLimitListValue: Codable {
    let value: Int?
    let currency: String?
}

typealias KycLimitLists = [String: KycLimitListValue]
