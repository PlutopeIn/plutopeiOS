//
//  AddCustomToken+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 26/07/23.
//

import UIKit
import QRScanner

// MARK: QRScannerDelegate
extension AddCustomTokenViewController: QRScannerDelegate {
    func qrScannerDidFail(scanner: QRScanner.QRScannerViewController, error: QRScanner.QRScannerError) {
        
    }
    
    func qrScannerDidSuccess(scanner: QRScanner.QRScannerViewController, result: String) {
        scanner.dismiss(animated: true) {
            let urlString = result
            
            self.txtContractAddress.text = ""
            
            if urlString.validateContractAddress() {
                DGProgressView.shared.showLoader(to: self.view)
                // Use the copied text here
                self.txtContractAddress.text = urlString
                /// check if it contain in our dtatabase
                self.checkIsAvailableInOurDatabase()
                
            } else {
                self.showToast(message: "Invalid contract address", font: .systemFont(ofSize: 15))
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension AddCustomTokenViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonAvailability()
    }

}

// MARK: SelectNetworkDelegate
extension AddCustomTokenViewController : SelectNetworkDelegate {
    
    func selectNetwork(chain: Token) {
        self.coinDetail = chain
        lblChain.text = chain.name ?? ""
        self.tokenId = chain.tokenId ?? ""
        for textFields in [self.txtTokenName,self.txtDecimal,self.txtTokenSymbol,self.txtContractAddress] {
            textFields?.text = ""
        }
        btnSave.alpha = 0.5
        btnSave.isUserInteractionEnabled = false
    }

}
