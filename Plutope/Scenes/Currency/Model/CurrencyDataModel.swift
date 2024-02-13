//
//  CurrencyDataModel.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import Foundation

// MARK: - CurrencyList
struct CurrencyList: Codable {
    let id: Int?
    let name, sign, symbol: String?
}

// MARK: - Status
struct CurrencyStatus: Codable {
    let timestamp: String?
    let errorCode: Int?
    let errorMessage: String?
    let elapsed, creditCount: Int?
    let notice: String?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
        case notice
    }
}
