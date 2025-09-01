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
    static let coinSend: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")
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
    
    static let otpEmpty: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.otpEmpty, comment: "")
    static let otpvalid: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.otpValid, comment: "")
    static let emailEmpty: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emailEmpty, comment: "")
    static let emailValid: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emailValid, comment: "")
    static let emptyFirstName :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyFirstName, comment: "")
    static let emptyLastName :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyLastName, comment: "")
    static let emptyDob :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyDob, comment: "")
    static let emptyCity :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyCity, comment: "")
    static let emptyZip :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyZip, comment: "")
    static let emptyStreet :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyStreet, comment: "")
    static let emptyCountry :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyCountry, comment: "")
    static let emptyState :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyState, comment: "")
    static let emptyAddress :String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyAddress, comment: "")
}
