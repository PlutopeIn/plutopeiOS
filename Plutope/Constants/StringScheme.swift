//
//  StringScheme.swift
//  Plutope
//
//  Created by Priyanka Poojara on 31/05/23.
//
import Foundation
import UIKit
struct StringConstants {
    static let loreumIpsum = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna."
 
    /// Passcode
    static let passcodeText = "Adds an extra layer of security when using the app"
    
    /// Legal
    static let legal: String = "Legal"
    static let privacyPolicy: String = "Privacy Policy"
    static let termCondition: String = "Terms Of Service"
    
    /// Back up your wallet now
    static let information1: String = "If lose my secret phrase, my funds will be lost forever."
    static let information2: String = "If expose or share my secret phrase to anybody, my funds can get stolen."
    static let information3: String = "Plutope support will NEVER reach out to ask for it"
    
    /// Your Recovery Phrase
    static let recoveryPhrase: String = "Your Recovery Phrase"
    static let warning: String = "Never share your secret phrase with anyone."
    static let storeSecureWarning: String = "Never share your secret phrase with anyone, store it securely!"
    static let copied: String = "Copied"
    static let invalidOrder: String = "Invalid order. Try again!"
    static let phraseMatched: String = "Well done!"
    static let showPhrase: String = "Show Recovery Phrase"
    static let hidePhrase: String = "Hide Recovery Phrase"
    static let copy: String = "Copy"
    
    /// Verify Secret Phrase
    static let verifySecretPhrase: String = "Verify Secret Phrase"
    
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
    static let providers: String = "Providers"
    static let meld: String = "Meld"
    static let changeNow: String = "Change Now"
    static let onMeta: String = "On Meta"
    static let onRamp: String = "On Ramp"
    static let unLimit: String = "unLimit"
    
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
    
    /// Swap
    static let swap: String = "Swap"
    
    /// Card
    static let card: String = "Card"
    
    /// Setting
    static let setting: String = "Settings"
    
    static let wallet: String = "Wallet"
    
    static let wallets: String = "Wallets"
    static let security: String = "Security"
    static let pushNotifications: String = "Push Notifications"
    static let helpCenter: String = "Help Centre"
    static let aboutPlutoPe: String = "About PlutoPe"
    static let lockMethod: String = "Lock Methods"
    static let languages: String = "Language"
    
    /// Toaster Texts
    static let limitText: String = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.limitText, comment: "")
    
    /// Add custom token
    static let addCustomToken: String = "Add Custom Token"
    static let network: String = "Network"
    static let delete: String = "Delete"
    static let disable: String = "Disable"
    
    /// Transaction Detail
    static let transfer: String = "Transfer"
    
    /// Multicoin wallet
    static let importMulticoinWalet: String = "Import Multi-Coin Wallet"
    
    /// Passcode
    static let enterPasscode: String = "Enter Passcode"
    static let createPasscode: String = "Create Passcode"
    
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
    static let editContact: String = "Edit Contacts"
    
    /// Wallet Recovery
    static let backUpActive: String = "Active"
    static let backUpNotActive: String = "Not Active"
    
    /// Walelt Delete
    static let deleteWalletWarning: String = "Are you sure you want to delete this wallet?"
    static let askForManualBackup: String = "Before deleting your iCloud backup, ensure a manual backup is in place for your data's security."
    
    /// Card Membership Detail
    static let Basic: String = "Basic"
    static let Professional: String = "Professional"
    static let Business: String = "Business"
    static let PlatinumElite: String = "Platinum Elite"
    
    static let BasicPrice: String = "$9"
    static let ProfessionalPrice: String = "$10"
    static let BusinessPrice: String = "$10"
    static let PlatinumElitePrice: String = "$11"
    
    static let BasicCard: String = "Get Basic Card"
    static let ProfessionalCard: String = "Get Professional Card"
    static let BusinessCard: String = "Get Business Card"
    static let PlatinumEliteCard: String = "Get Platinum Elite Card"
    static let StandardMail: String = "Standard Mail (Global)-Free"
    static let Crypto: String = "Crypto"
    
    static let USDollar: String = "US Dollar ($)"
    static let PoundSterling: String = "Pound Sterling (£)"
    static let Euro: String = "Euro (€)"
    static let BitCoin: String = "BitCoin BTC"
    
    /// Add Contact
    static let invalidAdd = "Invalid address"
    
    /// Home / Wallet Dashboard
    static let homeTip = "Single tap to open menu & Hold and press to go dashboard."
    
    /// Default chain address
    static let defaultAddress = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    static let whatIsCustomToken: String = "What is Custom Token?"
    static let whatIsSecretPhrase: String = "What is Secret Phrase?"
    
    static let advanced: String = "Leverage gas fee"
    
    static let okx: String = "okx"
    static let rangoSwap: String = "RangoSwap"
    
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
}
