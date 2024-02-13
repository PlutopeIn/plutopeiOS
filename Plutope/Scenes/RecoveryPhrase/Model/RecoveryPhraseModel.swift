//
//  RecoveryPhraseModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import Foundation
struct SecretPhraseDataModel {
    var number: Int
    var phrase: String
}

enum BackupFrom {
    case iCloud
    case manual
    case wallets
}
