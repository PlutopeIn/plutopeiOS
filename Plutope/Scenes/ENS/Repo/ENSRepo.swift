//
//  ENSRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/01/24.
//

import Foundation
import DGNetworkingServices

struct ApiRequestParameters: Codable {
    let currency: String
    let domainName: String
    let owner: Owner
    let records: Records
}

struct Owner: Codable {
    let address: String
}

struct Records: Codable {
    let cryptoETHAddress: String

    // CodingKeys to map the Swift variable name to the desired JSON key
    enum CodingKeys: String, CodingKey {
        case cryptoETHAddress = "crypto.ETH.address"
    }
}

class ENSRepo {
    func apiENSData(currency: String, domainName: String, ownerAddress: String, recordsAddress: String, completion: @escaping ((ApiResponse) -> Void)) {

        // Assuming apiRequestParams is an instance of ApiRequestParameters
        let apiRequestParams = ApiRequestParameters(
            currency: currency,
            domainName: domainName,
            owner: Owner(address: ownerAddress),
            records: Records(cryptoETHAddress: recordsAddress)
        )
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.domainCheck
        // Convert the struct to a dictionary
        do {
            if let jsonData = try? JSONEncoder().encode(apiRequestParams),
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                // Use jsonObject in your DGNetworkingServices.main.dataRequest function
                DGNetworkingServices.main.dataRequest(
                    Service: NetworkURL(withURL:apiUrl),
                    HttpMethod: .post,
                    parameters: jsonObject, // Pass the JSON object here
                    headers: nil
                ) { status, error, data in
                    if status {
                        do {
                            if let responseData = data {
                                let decoder = JSONDecoder()
                                let apiResponse = try decoder.decode(ApiResponse.self, from: responseData)
                                completion(apiResponse)
                            } else {
                                // Handle no data received
                                completion(.notAvailable(ErrorResponse(status: 400, message: "No data received", data: "")))
                            }
                        } catch {
                            // Handle decoding error
                            completion(.notAvailable(ErrorResponse(status: 400, message: "Error decoding JSON: \(error)", data: "")))
                        }
                    } else {
                        // Handle the network error
                        completion(.notAvailable(ErrorResponse(status: 400, message: "Error: \(error?.rawValue ?? "")", data: "")))
                    }
                }
            }
        } catch {
            print("Error encoding/decoding JSON: \(error)")
        }
    }
  
}
