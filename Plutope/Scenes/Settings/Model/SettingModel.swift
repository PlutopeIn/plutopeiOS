//
//  SettingModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit

struct GroupSettingData {
    var group: [SettingData]
}

protocol Setting {
    var image: UIImage { get }
    var title: String { get }
    var subTitle: Bool { get }
    var showForward: Bool { get }
    var height: Float { get }
    var width: Float { get }
}

enum SettingData: Setting {
    
    var height: Float {
        switch self {
        case .wallets:
            return 20.67
        case .currency:
            return 20
        case .security:
            return 22.5
        case .pushNotification:
            return 21.5
        case .helpCenter:
            return 20.38
        case .aboutPlutope:
            return 27
        case .contacts:
            return 20
        case .languages:
            return 20
        }
    }
    
    var width: Float {
        switch self {
        case .wallets:
            return 20
        case .currency:
            return 20
        case .security:
            return 17.14
        case .pushNotification:
            return 16.58
        case .helpCenter:
            return 20.38
        case .aboutPlutope:
            return 15
        case .contacts:
            return 20
        case .languages:
            return 20
        }
    }
    
    
    case wallets
    case currency
    case security
    case pushNotification
    case helpCenter
    case aboutPlutope
    case contacts
    case languages
  
    var image: UIImage {
        switch self {
        case .wallets:
            return UIImage.icWallet
        case .currency:
            return UIImage.coin
        case .security:
            return UIImage.icInsurance
        case .pushNotification:
            return UIImage.icSmartphone
        case .helpCenter:
            return UIImage.icHelp
        case .aboutPlutope:
            return UIImage.plutopayLogo
        case .contacts:
            return UIImage.icUser.sd_tintedImage(with: .white) ?? UIImage()
        case .languages:
            return UIImage.icLanguage.sd_tintedImage(with: .white) ?? UIImage()
        }
    }
    
    var title: String {
        switch self {
        case .wallets:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallets, comment: "")
            //return StringConstants.wallets
        case .currency:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.currency, comment: "")
            //return StringConstants.currency
        case .security:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.security, comment: "")
            //return StringConstants.security
        case .pushNotification:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pushnotifications, comment: "")
            //return StringConstants.pushNotifications
        case .helpCenter:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.helpcentre, comment: "")
            //return StringConstants.helpCenter
        case .aboutPlutope:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.aboutplutope, comment: "")
            //return StringConstants.aboutPlutoPe
        case .contacts:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contacts, comment: "")
            //return StringConstants.contacts
        case .languages:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.language, comment: "")
            //return StringConstants.languages
        }
    }
    
    var subTitle: Bool {
        switch self {
        case .currency:
            return true
        default: return false
        }
    }
    
    var showForward: Bool {
        switch self {
        case .wallets, .currency:
            return false
        case .security, .pushNotification, .helpCenter, .aboutPlutope, .contacts, .languages:
            return true
        }
    }
}
    
