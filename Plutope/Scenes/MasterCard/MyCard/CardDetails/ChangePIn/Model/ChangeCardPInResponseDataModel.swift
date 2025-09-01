//
//  ChangeCardPInResponseDataModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/09/24.
//

import Foundation

struct ChangeCardPInResponseDataModel: Codable {
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
