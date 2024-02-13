//
//  AddContacts+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 01/08/23.
//

import Foundation
import QRScanner

// MARK: QRScannerDelegate
extension AddContactViewController: QRScannerDelegate {
    func qrScannerDidFail(scanner: QRScanner.QRScannerViewController, error: QRScanner.QRScannerError) {
        
    }
    
    func qrScannerDidSuccess(scanner: QRScanner.QRScannerViewController, result: String) {
        scanner.dismiss(animated: true) {
            let urlString = result
            
            self.txtAddress.text = ""
            
            if urlString.validateContractAddress() {
                self.txtAddress.text = urlString
                self.updateButtonAvailability()
              
            } else {
                self.showToast(message: "Invalid address", font: .systemFont(ofSize: 15))
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension AddContactViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonAvailability()
    }

}
