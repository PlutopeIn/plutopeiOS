//
//  StringScheme+Toast.swift
//  Plutope
//
//  Created by Priyanka Poojara on 23/06/23.
//

import Foundation

struct ToastMessages {
    static let addressRequired: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addressRequiredMsg, comment: "")
    static let amountRequired: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amountRequiredMsg, comment: "")
    static let payAmountRequired: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.payAmountRequiredMsg, comment: "")
    static let coinSend: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.coinSendMsg, comment: "")
    static func lowBalance(_ coinSymbol: String) -> String {
        
        return "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceMSg1, comment: "")) \(coinSymbol) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceMSg2, comment: ""))"
        
    }
    static func lowFeeBalance(_ coinSymbol: String) -> String {
        
        return "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowFeeBalanceMsg1, comment: "")) \(coinSymbol) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowFeeBalanceMsg2, comment: ""))"
        
    }
    static let samecoinError: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.samecoinErrorMsg, comment: "")
    static let insufficientAmount: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.insufficientAmountMsg, comment: "")
    static let alreadyExists: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.alreadyExistsMsg, comment: "")
    static let phraseError: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phraseErrorMsg, comment: "")
    static let invalidPhrase: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidPhraseMsg, comment: "")
    static let passwordRequired: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.passwordRequiredMsg, comment: "")
    static let incorrectPassword: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.incorrectPasswordMsg, comment: "")
    static let invalidAmount: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidAmountMsg, comment: "")
    static let contactAdded: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contactAddedMsg, comment: "")
    static let invalidAddress: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidAddressMsg, comment: "")
    static let btcComingSoon: String = "BTC in not available now implemented coming soon"
    
}
