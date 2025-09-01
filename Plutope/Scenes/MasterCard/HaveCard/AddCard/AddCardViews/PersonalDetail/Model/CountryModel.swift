//
//  CountryModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import Foundation
import Combine

/// Country Model
struct Country: Codable, Identifiable {
    let name, flag, code, dialCode: String?
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case name, flag, code
        case dialCode = "dial_code"
    }
}

// Array of Country
typealias Countries = [Country]
