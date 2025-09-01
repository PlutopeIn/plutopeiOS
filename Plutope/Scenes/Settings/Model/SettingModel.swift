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
        case .ens:
            return 20
        case .walletConnect:
            return 20
        case .refreal:
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
        case .ens:
            return 20
        case .walletConnect:
            return 20
        case .refreal:
            return 20
        }
    }
    
    case wallets
    case currency
    case security
    case refreal
    case pushNotification
    case helpCenter
    case aboutPlutope
    case contacts
    case languages
    case ens
    case walletConnect
   
    var image: UIImage {
        switch self {
        case .wallets:
            return UIImage.icNewWallet
        case .currency:
            return UIImage.newcoin
        case .security:
            return UIImage.icNewInsurance
        case .refreal:
            return UIImage.icReferral
//            return UIImage.icReferral.sd_tintedImage(with: .white) ?? UIImage()
        case .pushNotification:
            return UIImage.icNewSmartphone
        case .helpCenter:
            return UIImage.icNewHelp
        case .aboutPlutope:
            return UIImage.aboytplutope
        case .contacts:
            return UIImage.icNewUser
//            return UIImage.icNewUser.sd_tintedImage(with: .white) ?? UIImage()
        case .languages:
            return UIImage.icLanguage
//            return UIImage.icLanguage.sd_tintedImage(with: .white) ?? UIImage()
        case .ens:
            return UIImage.icENS.withRoundedCorners() ?? UIImage()
        case .walletConnect:
           return UIImage.icwalletConnectIcon.sd_tintedImage(with: .label) ?? UIImage()
        
        }
    }
    
    var title: String {
        switch self {
        case .wallets:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallets, comment: "")
            
        case .currency:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.currency, comment: "")
            
        case .security:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.security, comment: "")
          
        case .refreal:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.myReffreal, comment: "")
            
        case .pushNotification:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pushnotifications, comment: "")
           
        case .helpCenter:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.helpcentre, comment: "")
           
        case .aboutPlutope:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.aboutplutope, comment: "")
            
        case .contacts:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contacts, comment: "")
           
        case .languages:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.language, comment: "")
          
        case .ens:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ens, comment: "")
        case .walletConnect:
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletConnect, comment: "")
       
          //  return "Referral"
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
//            return false
            return true
        case .security, .pushNotification, .helpCenter, .aboutPlutope, .contacts, .languages,.ens,.walletConnect,.refreal:
            return true
        }
    }
}
    
