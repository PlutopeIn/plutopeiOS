//
//  ENSDataModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/01/24.
//

import Foundation

enum ApiResponse: Decodable {
    case notAvailable(ErrorResponse)
    case success(ENSData)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            // Try decoding as ENSDataList (success case)
            let successResponse = try container.decode(ENSData.self)
            self = .success(successResponse)
        } catch DecodingError.typeMismatch {
            // If it fails, try decoding as ErrorResponse (error case)
            let errorResponse = try container.decode(ErrorResponse.self)
            self = .notAvailable(errorResponse)
        }
    }
}



struct ErrorResponse: Codable {
    let status: Int
    let message: String
    let data: String
}


// MARK: - ENSData
struct ENSData: Codable {
    let status: Int?
    let message: String?
    let data: ENSDataList?
}

// MARK: - ENSDataList
struct ENSDataList: Codable {
    let name: String?
    let availability: AvailabilityList?
    let tx: TxValue?
}

// MARK: - AvailabilityList
struct AvailabilityList: Codable {
    let status: String?
    let price: PriceList?
}

// MARK: - PriceList
struct PriceList: Codable {
    let listPrice, subTotal: ListPrice?
}

// MARK: - ListPrice
struct ListPrice: Codable {
    let usdCents: Int?
}

// MARK: - TxValue
struct TxValue: Codable {
    let chainID: Int?
    let function: String?
    let arguments: Arguments?
    let params: Params?

    enum CodingKeys: String, CodingKey {
        case chainID = "chainId"
        case function, arguments, params
    }
}

// MARK: - Arguments
struct Arguments: Codable {
    let owner: String?
    let expiration: Int?
    let signature: String?
    let labels, keys, values: [String]?
    let price: String?
}

// MARK: - Params
struct Params: Codable {
    let to, data, value: String?
}
