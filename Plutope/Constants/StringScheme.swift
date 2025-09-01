//
//  StringScheme.swift
//  Plutope
//
//  Created by Priyanka Poojara on 31/05/23.
//
import Foundation
import UIKit
struct StringConstants {
    
    /// Default chain address
    static let defaultAddress = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
   
    /// Your Recovery Phrase
    static let copied: String = "Copied"
    /// Currency
    static let currency: String = "Currency"
    
    /// Send
    static let send: String = "Send"
    
    /// Receive
    static let receive: String = "Receive"
    static let enterAmount: String = "Enter value"
    static let receiveNFT: String = "Receive NFT"
    
    /// Buy
    static let buy: String = "Buy"
    static let buyCoin: String = "Buy Coin"
    
    /// Providers
    static let providers: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.provider, comment: "")
    static let meld: String = "Meld"
    static let changeNow: String = "Change Now"
    static let onMeta: String = "On Meta"
    static let onRamp: String = "On Ramp"
    static let unLimit: String = "unLimit"
    static let guardarian: String = "guardarian"
    
    /// Welcome
    static let welcomeTitle1: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welcomeTitle1, comment: "")
    static let welcomeTitle2: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welcomeTitle2, comment: "")
    static let welcomeTitle3: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welcomeTitle3, comment: "")
    
    static let welcomeDesc1: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welcomeDesc1, comment: "")
    static let welcomeDesc2: String =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welcomeDesc2, comment: "")
    static let welcomeDesc3: String =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welcomeDesc3, comment: "")
    
    /// Notifications
    static let notification: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.notifications, comment: "")
    static let notificationTitle: String = "Received: 5,000 DST"
    
    /// Toaster Texts
    static let limitText: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.limitText, comment: "")
 
    /// Select Wallet Backup
    static let selectBackup: String = "Select Wallet Backup"
    static let instructionBackup: String = "If you don't see your backup, try to sync your iCloud."
    
    /// Passcode error message
    static let confirmPasscodeErrorMessage: String = "Confirm password does not match"
    static let enterEncryption: String = "Enter encryption password"
    static let setEncryption: String = "Set encryption password"
    
    /// Settings -> Contact
    static let contacts: String = "Contacts"
    static let addContacts: String = "Add Contacts"
    static let editContact: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.editContacts, comment: "")
    
    /// Wallet Recovery
    static let backUpActive: String = "Active"
    static let backUpNotActive: String = "Not Active"
    
    /// Walelt Delete
    static let askForManualBackup: String = "Before deleting your iCloud backup, ensure a manual backup is in place for your data's security."
    
    /// Add Contact
    static let invalidAdd = "Invalid address"
  
}
// MARK: User Defaults keys
struct DefaultsKey {
    static let appPasscode:String = "AppPasscode"
    static let isTransactionSignin:String = "isTransactionSignin"
    static let appLockMethod:String = "LockMethod"
    static let isRestore:String = "isRestore"
    static let mnemonic: String = "mnemonic"
    static let splashVideoPlayed: String = "splashVideo"
    static let homeButtonTip: String = "homeTip"
    static let newUser: String = "newUser"
    static let upadtedUser: String = "upadtedUser"
    static let tokenString: String = "tokenString"
}
