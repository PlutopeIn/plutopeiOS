//
//  LoginViewController+Delegate.swift
//  Plutope
//
//  Created by sonoma on 16/05/24.
//

import UIKit
import IQKeyboardManagerSwift
import PhoneNumberKit
extension LoginViewController: UITextFieldDelegate {

    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText = textField.text else { return true }
            
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            // Allow deletion of all text including the '+'
            if newText.isEmpty {
                txtMobileNo.withFlag = false  // Remove the flag when text is empty
                txtMobileNo.withPrefix = false // Remove the prefix when text is empty
                return true
            }
        // Ensure the text starts with a '+'
                if !newText.hasPrefix("+") {
                    textField.text = "+" + newText
                    txtMobileNo.withFlag = true  // Ensure the flag is visible when prefix is added
                    txtMobileNo.withPrefix = true // Ensure the prefix is visible when prefix is added
                   
                    return false
                }
            // Validate phone number format dynamically
            do {
                if newText.count > 1 {
//                    let _ = try PhoneNumberKit.parse(newText)
                }
                return true
            } catch {
                return true  // Allow editing, but you may add further handling if needed
            }
        }
        
}

struct Constants {
    static let maxAttempts = 2
    static let blockDuration: TimeInterval = 30 * 60 // 30 minutes in seconds
    static let userDefaultsKeyPrefix = "LoginAttempts_"
}
extension UserDefaults {
    func attemptCount(for phoneNumber: String) -> Int {
        return integer(forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_attemptCount")
    }

    func setAttemptCount(_ count: Int, for phoneNumber: String) {
        set(count, forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_attemptCount")
    }

    func lastAttemptTime(for phoneNumber: String) -> Date? {
        return object(forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_lastAttemptTime") as? Date
    }

    func setLastAttemptTime(_ time: Date?, for phoneNumber: String) {
        set(time, forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_lastAttemptTime")
    }

    func blockEndTime(for phoneNumber: String) -> Date? {
        return object(forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_blockEndTime") as? Date
    }

    func setBlockEndTime(_ time: Date?, for phoneNumber: String) {
        set(time, forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_blockEndTime")
    }

    func resetAttempts(for phoneNumber: String) {
        removeObject(forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_attemptCount")
        removeObject(forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_lastAttemptTime")
        removeObject(forKey: Constants.userDefaultsKeyPrefix + phoneNumber + "_blockEndTime")
    }
}

func isAccountBlocked(for phoneNumber: String) -> Bool {
    let userDefaults = UserDefaults.standard

    if let blockEndTime = userDefaults.blockEndTime(for: phoneNumber) {
        return Date() < blockEndTime
    }
    return false
}
