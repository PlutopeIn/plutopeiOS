//
//  AddCardDetailModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit

enum Step: Int {
    case personalDetails = 0
    case membership = 1
    case card = 2
    case payment = 3
    
    var title: String {
        switch self {
        case .personalDetails:
            return """
Personal
Details
"""
        case .membership:
            // return "Membership"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.membership, comment: "")
        case .card:
            // return "Card"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: "")
        case .payment:
            // return "Payment"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.payment, comment: "")
        }
    }
}
