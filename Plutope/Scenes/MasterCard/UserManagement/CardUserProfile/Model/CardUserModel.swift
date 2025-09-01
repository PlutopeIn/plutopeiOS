//
//  CardUserModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
// MARK: - CardUserDataModel
struct CardUserDataModel: Codable {
    let status: Int?
    let data: CardUserDataList?
}

// MARK: - CardUserDataList
struct CardUserDataList: Codable {
    let email: String?
    let confirmedEmail: Bool?
    let phone, firstName, lastName, primaryCurrency: String?
    let residenceCountry, residenceCity, residenceStreet, residenceZipCode: String?
    let pushEnabled, enabled2FA: Bool?
    let dateOfBirth, veroID: String?

    enum CodingKeys: String, CodingKey {
            case email, confirmedEmail, phone, firstName, lastName, primaryCurrency, residenceCountry, residenceCity, residenceStreet, residenceZipCode, pushEnabled, enabled2FA, dateOfBirth
            case veroID = "veroId"
        }
}
