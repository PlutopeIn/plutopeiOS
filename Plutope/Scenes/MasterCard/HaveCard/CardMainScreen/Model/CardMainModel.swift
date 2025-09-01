//
//  CardMainModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
import UIKit
struct CardFeaturs {
    var name : String
}
// MARK: - KycStatusData
struct KycStatusData: Codable {
    let status: Int?
    let data: KycStatusList?
}

// MARK: - KycStatusList
struct KycStatusList: Codable {
    let kycLevel: String?
    let kyc1ClientData, kyc2ClientData, kyc3ClientData: KycClientData?
    let remainingAmount, blockedAmount: KycAmount?
}

// MARK: - KycClientData
struct KycClientData: Codable {
    let status: String?
//    let reason: String?
    let rejectFormattedMessage: String?
}
// MARK: - kycAmount
struct KycAmount: Codable {
    let value: PriceValue?
    let currency: String?
}
