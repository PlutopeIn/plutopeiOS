//
//  LoginModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/07/24.
//

import Foundation
struct LoginData : Codable {
    let success : LoginSuccessData?
    let failler : LoginFailerData?
}
// MARK: - LoginSuccessData
struct LoginSuccessData: Codable {
    let accessToken, tokenType, refreshToken: String?
    let expiresIn: Int?
    let scope, jti: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope, jti
    }
}
// MARK: - LoginFailerData
struct LoginFailerData: Codable {
    let message: String?
    let errorID: Int?
    let systemID, error: String?

    enum CodingKeys: String, CodingKey {
        case message
        case errorID = "errorId"
        case systemID = "systemId"
        case error
    }
}
