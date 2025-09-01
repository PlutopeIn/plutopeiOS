//
//  CardSettingModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 23/05/24.
//

import Foundation
import UIKit

struct CardGroupSettingData {
    var group: [CardSettingData]
}

protocol CardSetting {
    var image: UIImage { get }
    var title: String { get }
    var subTitle: Bool { get }
    var showForward: Bool { get }
    var height: Float { get }
    var width: Float { get }
}

enum CardSettingData: CardSetting {
    var height: Float {
        switch self {
        case .primarycurrency:
            return 20
        case .changePassword:
            return 20
        case .changeEmail:
            return 20
        }
    }
    
    var width: Float {
        switch self {
        case .primarycurrency:
            return 20
        case .changePassword:
            return 20
        case .changeEmail:
            return 20
        }
    }
    
    case primarycurrency
    case changePassword
    case changeEmail
    var image: UIImage {
        switch self {
        case .primarycurrency:
            return UIImage.icCardCurrency
        case .changePassword:
            return UIImage.icCardchangePassword
        case .changeEmail:
            return UIImage.iccardEmai
       
        }
    }
    
    var title: String {
        switch self {
        case .primarycurrency:
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.currency, comment: "") // "Primary Currency"
            
        case .changePassword:
            /*return "Change Password"*/ return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.changePassword, comment: "")
            
        case .changeEmail:
            return  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.changeEmails, comment: "")/*"Change Email"*/
        }
    }
    var subTitle: Bool {
        switch self {
        case .primarycurrency:
            return true
        default: return false
        }
    }
    var showForward: Bool {
        switch self {
        case .primarycurrency, .changePassword,.changeEmail:
            return false
        
//            return true
        }
    }
}
    
