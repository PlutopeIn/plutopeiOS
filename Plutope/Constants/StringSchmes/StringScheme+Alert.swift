//
//  StringScheme+Alert.swift
//  Plutope
//
//  Created by Priyanka Poojara on 10/08/23.
//

import UIKit

protocol CustomAlertOptions {
    var title: String? { get }
    var description: String? { get }
    var hideTitle: Bool { get }
    var hideDesc: Bool { get }
    var hideIcon: Bool { get }
    var hideCancel: Bool { get }
    var hideButtons: Bool { get }
    var deleteTitle: String? { get }
    var cancelTitle: String? { get }
    var setIcon: UIImage? { get }
    var hideDelete: Bool { get }
}

enum CustomAlert: CustomAlertOptions {
    
    var setIcon: UIImage? {
        switch self {
        case .manualBackupWarning,.deleteIcloud, .deleteWallet, .sellCryptoWarning:
            return UIImage.icWarning
        case .swapping:
            return UIImage.icSwapProcess
        }
    }
    
    var cancelTitle: String? {
        switch self {
        case .manualBackupWarning,.deleteIcloud, .deleteWallet, .sellCryptoWarning:
            //return "Cancel"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
        case .swapping:
            //return "Ok"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ok, comment: "")
        }
    }
    
    var deleteTitle: String? {
        switch self {
        case .manualBackupWarning:
            return "Start Now"
        case .deleteIcloud, .deleteWallet:
            //return "Delete"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.delete, comment: "")
        case .sellCryptoWarning, .swapping:
            return nil
        }
    }
    
    var title: String? {
        switch self {
        case .deleteIcloud:
            //return "Delete Backup"
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.deletebackup, comment: "")
        case .deleteWallet:
            return "Are you sure you would like to delete this wallet?"
        case .sellCryptoWarning:
            return nil
        case .manualBackupWarning:
            return "Manual backup required"
        case .swapping:
            return "Processing..."
        }
    }
    
    var description: String? {
        switch self {
        case .deleteIcloud:
            return "Are you sure you want to delete this iCloud backup?"
        case .deleteWallet:
            return "Make sure you have backup of your wallet"
        case .sellCryptoWarning:
            return #"In accordance with regulatory requirements and to ensure the security and legitimacy of transactions, the "Sell" functionality on our platform requires users to complete the KYC (Know Your Customer) process."#
        case .manualBackupWarning:
            return StringConstants.askForManualBackup
        case .swapping:
            return "It might take few minutes..."
        }
    }
    
    var hideTitle: Bool {
        switch self {
        case .deleteIcloud, .deleteWallet, .swapping:
            return false
        case .sellCryptoWarning, .manualBackupWarning:
            return true
        }
    }
    
    var hideDesc: Bool {
        switch self {
        case .deleteIcloud, .deleteWallet, .sellCryptoWarning, .manualBackupWarning, .swapping:
            return false
        }
    }
    
    var hideIcon: Bool {
        switch self {
        case .deleteIcloud, .deleteWallet:
            return true
        case .sellCryptoWarning, .manualBackupWarning, .swapping:
            return false
        }
    }
    
    var hideCancel: Bool {
        switch self {
        case .deleteIcloud, .deleteWallet, .swapping:
            return false
        case .sellCryptoWarning, .manualBackupWarning:
            return true
        }
    }
    
    var hideButtons: Bool {
        switch self {
        case .deleteIcloud, .deleteWallet, .manualBackupWarning, .swapping:
            return false
        case .sellCryptoWarning:
            return true
        }
    }
    
    var hideDelete: Bool {
        switch self {
        case .deleteIcloud, .deleteWallet, .manualBackupWarning, .sellCryptoWarning:
            return false
        case .swapping:
            return true
        }
    }
    
    case manualBackupWarning
    case deleteIcloud
    case deleteWallet
    case sellCryptoWarning
    case swapping
}
