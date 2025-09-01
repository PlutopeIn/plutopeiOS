//
//  RegisterCardViewController+Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/03/24.
//

import UIKit
import IQKeyboardManagerSwift
import PhoneNumberKit

extension RegisterCardViewController: UITextFieldDelegate {
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

        return true
        }
        

}
