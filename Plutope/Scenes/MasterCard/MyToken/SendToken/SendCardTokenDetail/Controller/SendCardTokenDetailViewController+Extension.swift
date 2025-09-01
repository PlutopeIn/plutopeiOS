//
//  SendCardTokenDetailViewController+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import UIKit
import QRScanner
import AVFoundation
import Web3
// MARK: UITextFieldDelegate
extension SendCardTokenDetailViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textFieldDidChangeSelection")
        if sendVia != "walletAddress" {
            if textField == txtSend {
                let text = txtSend.text ?? ""
                if text == "" {
                    lblFromError.text = ""
                    lblToError.text = ""
                    self.btnSend.alpha = 0.5
                    self.btnSend.isEnabled = false
                    self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
                }
                
                if (Double(txtSend.text ?? "") ?? 0.0) > 0.0 {
                        let balanceDouble = self.lblBalance.text?.asDouble
                        print("✅ Converted:", balanceDouble ?? 0.0)
                        if Double(txtSend.text ?? "") ?? 0.0 > balanceDouble ?? 0.0 {
                            self.btnSend.alpha = 0.5
                            self.btnSend.isEnabled = false
                            txtSend.textColor = UIColor.red
                            lblFromError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                        } else {
                            lblFromError.text = ""
                            lblToError.text = ""
                            txtSend.textColor = UIColor.label
                            txtTo.textColor = UIColor.label
                            //
                        }
                    } else {
                        lblFromError.text = ""
                        lblToError.text = ""
                        self.btnSend.alpha = 0.5
                        self.btnSend.isEnabled = false
                        self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
                        
                    }
            } else {
            }
            if (Double(txtSend.text ?? "") ?? 0.0) > 0 && txtTo.text != "" && txtTo.text?.count ?? 0 >= 5 {
               // dismissKeyboard()
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
                perform(#selector(apiCall), with: nil, afterDelay: 2)
            }
        } else {
          print("textFieldDidEndEditingElse")
//            if sendVia == "walletAddress" {
               
                if textField == txtTo {
                    let text = txtTo.text ?? ""
                    if text == "" {
                        lblFromError.text = ""
                        lblToError.text = ""
                        self.btnSend.alpha = 0.5
                        self.btnSend.isEnabled = false
                    }
                    if matches(pattern: self.addressPattern, in: text) {
                            lblFromError.text = ""
                            lblToError.text = ""
                            txtTo.textColor = UIColor.label
                    } else {
                        self.btnSend.alpha = 0.5
                        self.btnSend.isEnabled = false
                        txtTo.textColor = UIColor.red
                        lblToError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.incorrectAddress, comment: "") //"Incorrect address"
                        self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
                    }
                } else {
    //                txtSend.textColor = UIColor.label
                    let text = txtSend.text ?? ""
                    if text == "" {
                        lblFromError.text = ""
                        lblToError.text = ""
                        self.btnSend.alpha = 0.5
                        self.btnSend.isEnabled = false
                        self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
                    }
                    if (Double(txtSend.text ?? "") ?? 0.0) > 0 {
                        let balanceDouble = self.lblBalance.text?.asDouble
                        print("✅ Converted:", balanceDouble ?? 0.0)
                        if Double(txtSend.text ?? "") ?? 0.0 > balanceDouble ?? 0.0 {
                            self.btnSend.alpha = 0.5
                            self.btnSend.isEnabled = false
                            txtSend.textColor = UIColor.red
                            lblFromError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                            self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
                        } else {
                            lblFromError.text = ""
                            lblToError.text = ""
                            txtSend.textColor = UIColor.label
                            
                        }
                    } else {
                        lblFromError.text = ""
                        lblToError.text = ""
                        self.btnSend.alpha = 0.5
                        self.btnSend.isEnabled = false
                        self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
                    }
                }
               // dismissKeyboard()
                if (Double(txtSend.text ?? "") ?? 0.0) > 0 && txtTo.text != "" && lblToError.text == "" {
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
                    perform(#selector(apiCall), with: nil, afterDelay: 1)
                }
//            } else {
//                
//            }

        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtSend {
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Try to add the new input
            if let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                
                // Check if there's already a decimal point in the text
                if updatedText.components(separatedBy: ".").count > 2 {
                    return false // Block if there are more than one decimal points
                }
                return true 
            }
        }
            return true // Allow input if it's valid
        }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if sendVia == "walletAddress" {
//            print("textFieldDidEndEditing")
//            if textField == txtTo {
//                let text = txtTo.text ?? ""
//                if text == "" {
//                    lblFromError.text = ""
//                    lblToError.text = ""
//                    self.btnSend.alpha = 0.5
//                    self.btnSend.isEnabled = false
//                }
//                if matches(pattern: self.addressPattern, in: text) {
//                        lblFromError.text = ""
//                        lblToError.text = ""
//                        txtTo.textColor = UIColor.label
//                } else {
//                    self.btnSend.alpha = 0.5
//                    self.btnSend.isEnabled = false
//                    txtTo.textColor = UIColor.red
//                    lblToError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.incorrectAddress, comment: "") //"Incorrect address"
//                    self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
//                }
//            } else {
////                txtSend.textColor = UIColor.label
//                let text = txtSend.text ?? ""
//                if text == "" {
//                    lblFromError.text = ""
//                    lblToError.text = ""
//                    self.btnSend.alpha = 0.5
//                    self.btnSend.isEnabled = false
//                    self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
//                }
//                if (Double(txtSend.text ?? "") ?? 0.0) > 0 {
//                    let balanceDouble = self.lblBalance.text?.asDouble
//                    print("✅ Converted:", balanceDouble ?? 0.0)
//                    if Double(txtSend.text ?? "") ?? 0.0 > balanceDouble ?? 0.0 {
//                        self.btnSend.alpha = 0.5
//                        self.btnSend.isEnabled = false
//                        txtSend.textColor = UIColor.red
//                        lblFromError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
//                        self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
//                    } else {
//                        lblFromError.text = ""
//                        lblToError.text = ""
//                        txtSend.textColor = UIColor.label
//                        
//                    }
//                } else {
//                    lblFromError.text = ""
//                    lblToError.text = ""
//                    self.btnSend.alpha = 0.5
//                    self.btnSend.isEnabled = false
//                    self.btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), for: .normal)
//                }
//            }
//            dismissKeyboard()
//            if (Double(txtSend.text ?? "") ?? 0.0) > 0 && txtTo.text != "" && lblToError.text == "" {
//                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
//                perform(#selector(apiCall), with: nil, afterDelay: 1)
//            }
//        } else {
//            
//        }
//    }
    @objc private func apiCall() {
        print("nscancel api call")
        //  txtGet.showLoading()
        self.btnSend.alpha = 1
        self.btnSend.isEnabled = true
        if sendVia == "phone" {
            self.getTokenFee(currency: walletArr?.currency ?? "", amount: txtSend.text ?? "",phone: txtTo.text ?? "",isFrom: "phone")
        } else {
            self.getTokenFee(currency: walletArr?.currency ?? "", amount: txtSend.text ?? "",address:txtTo.text ?? "",isFrom: "walletAddress")
        }
    }
}

extension SendCardTokenDetailViewController : SetPhoneNumberDelegate {
    func setPhoneNumber(phoneNo: String) {
        DispatchQueue.main.async {
            self.txtTo.text = phoneNo
        }
    }
}
// MARK: QRScannerDelegate
extension SendCardTokenDetailViewController: QRScannerDelegate {
    func qrScannerDidFail(scanner: QRScanner.QRScannerViewController, error: QRScanner.QRScannerError) {
        
    }
    func qrScannerDidSuccess(scanner: QRScanner.QRScannerViewController, result: String) {
        scanner.dismiss(animated: true) {
           // let input = result
            print(result)
            self.toWalletAddress = result
            self.txtTo.text = result
          //  self.txtTo.setCenteredEllipsisText(url)
            self.textFieldDidChangeSelection(self.txtTo)
            print("URL: \(result)")
        }
    }
}
extension SendCardTokenDetailViewController {
//    func matches(for regex: String, in text: String) -> [String] {
//        do {
//            let regex = try NSRegularExpression(pattern: regex)
//            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
//            return results.map {
//                String(text[Range($0.range, in: text)!])
//            }
//        } catch let error {
//            print("Invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
    func matches(pattern: String, in text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(text.startIndex..., in: text)
            return regex.firstMatch(in: text, range: range) != nil
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }

}
