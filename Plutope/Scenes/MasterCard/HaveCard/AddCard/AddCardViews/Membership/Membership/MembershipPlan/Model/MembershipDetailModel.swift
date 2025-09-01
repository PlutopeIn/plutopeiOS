//
//  MembershipDetailModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 09/08/23.
//

import Foundation

protocol Membership {
    var title: String { get }
    var price: String { get }
    var btnTitle: String { get }
}

enum MembershipData: Membership {
    
    case basic
    case professional
    case business
    case platinumElite
  
    var title: String {
        switch self {
        case .basic:
            //return StringConstants.Basic
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.basic, comment: "")
        case .professional:
            //return StringConstants.Professional
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.professional, comment: "")
        case .business:
            //return StringConstants.Business
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.business, comment: "")
        case .platinumElite:
            //return StringConstants.PlatinumElite
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.platinumelite, comment: "")
        }
    }
    var price: String {
        switch self {
        case .basic:
            return StringConstants.BasicPrice
        case .professional:
            return StringConstants.ProfessionalPrice
        case .business:
            return StringConstants.BusinessPrice
        case .platinumElite:
            return StringConstants.PlatinumElitePrice
        }
    }
    
    var btnTitle: String {
        switch self {
        case .basic:
            //return StringConstants.BasicCard
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getbasiccard, comment: "")
        case .professional:
            return StringConstants.ProfessionalCard
        case .business:
            return StringConstants.BusinessCard
        case .platinumElite:
            return StringConstants.PlatinumEliteCard
        }
    }
}
    
