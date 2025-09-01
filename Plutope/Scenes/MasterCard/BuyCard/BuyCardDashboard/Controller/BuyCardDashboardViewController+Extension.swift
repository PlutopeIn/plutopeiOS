//
//  BuyCardDashboardViewController+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/06/24.
//

import Foundation
import UIKit
// MARK: UITextFieldDelegate
extension BuyCardDashboardViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtPay {
            let text = txtPay.text ?? ""
            if text == "" {
                lblPayError.text = ""
                lblGetError.text = ""
            }
            if (Double(text) ?? 0.0) > 0 {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
                perform(#selector(apiCall), with: nil, afterDelay: 1)
            } else {
                txtGet.text = ""
                self.txtGet.hideLoading()
                lblPayError.text = ""
                lblGetError.text = ""
            }
        } else {

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Try to add the new input
            if let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                
                // Check if there's already a decimal point in the text
                if updatedText.components(separatedBy: ".").count > 2 {
                    return false // Block if there are more than one decimal points
                }
            }
        
            return true // Allow input if it's valid
        }
    
    @objc private func apiCall() {

        getBestPrice()
        if Double(txtPay.text ?? "") ?? 0.0 > Double(self.lblMax.text ?? "") ?? 0.0 {
            self.btnContinue.alpha = 0.5
            self.btnContinue.isEnabled = false
            lblPayError.isHidden = false
            txtPay.textColor = UIColor.red
            lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enterASmallerAmount, comment: "")
            lblGetError.isHidden = false
            txtGet.textColor = UIColor.red
            lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enterASmallerAmount, comment: "")
            
        } else  if Double(txtPay.text ?? "") ?? 0.0 < Double(self.lblMin.text ?? "") ?? 0.0 {
            self.btnContinue.alpha = 0.5
            self.btnContinue.isEnabled = false
            lblPayError.isHidden = false
            txtPay.textColor = UIColor.red
            lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.heigherAmountError, comment: "")
            lblGetError.isHidden = false
            txtGet.textColor = UIColor.red
            lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.heigherAmountError, comment: "")
            
        } else {
            lblPayError.text = ""
            lblGetError.text = ""
            txtPay.textColor = UIColor.label
            txtGet.textColor = UIColor.label
            if arrCardList.isEmpty {
                self.btnContinue.alpha = 0.5
                self.btnContinue.isEnabled = false
            } else {
                self.btnContinue.alpha = 1
                self.btnContinue.isEnabled = true
            }
        }
        
    }
    @objc private func apiCall1() {
        getTokenAmount()
    }
    /// getBestPrice
     func getBestPrice() {
         DispatchQueue.main.async {
             let pay = Double(self.txtPay.text ?? "") ?? 0.0
             let selectedToken = self.lblType2.text
             var tokenRate = ""
             var selectedPairRate: PriceValue?
             var tokenCurrency = ""
             var tokenName = ""
             if let pair = self.arrPayInOtherData?.pairs?.first(where: { $0.currencyTo == selectedToken }) {
                 selectedPairRate = pair.rate
                 tokenName = pair.currencyTo ?? ""
                 tokenCurrency = pair.currencyFrom ?? ""
             } else {
                 selectedPairRate = nil
             }
             if let pairRates = selectedPairRate {
                 let pairRatesValue: Double = {
                     switch pairRates {
                     case .int(let value):
                         return Double(value)
                     case .double(let value):
                         return value
                     }
                 }()
                 tokenRate = "\(pairRatesValue)"
                 
             } else {
                 tokenRate = "0"
             }
             
             let payPrice = Double(tokenRate) ?? 0.0
             let payableAmount = pay * payPrice
             if self.txtPay.text == "" {
                 self.lblPayError.text = ""
                 self.lblGetError.text = ""
             } else {
                 let value = payableAmount
                 let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 6)
                 self.toCurrency = "\(tokenCurrency)"
                 self.txtGet.text = "\(formattedValue)"
                 let total = payableAmount + self.totalFees
                 let totalBalance = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 3)
                 self.lblTotal.text = "\(totalBalance) \(tokenCurrency)"
                 
             }
             self.txtGet.hideLoading()
             let localizedRateString = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokenNameRate, comment: "")
             let formattedRateString = String(format: localizedRateString, tokenName)
             self.lblRateTitle.text = formattedRateString
             
             let rate = WalletData.shared.formatDecimalString("\(tokenRate)", decimalPlaces: 6)
             self.lblRate.text = "\(rate) \(tokenCurrency)"
             let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
             let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: "\(tokenName)")
             self.btnContinue.setTitle(message, for: .normal)

             
         }
        
    }
    func getTokenAmount() {
        DispatchQueue.main.async {
            let pay = Double(self.txtGet.text ?? "") ?? 0.0
            let selectedToken = self.lblType2.text
            var tokenRate = ""
            var selectedPairRate: PriceValue?
            var tokenCurrency = ""
            var tokenName = ""
            if let pair = self.arrPayInOtherData?.pairs?.first(where: { $0.currencyTo == selectedToken }) {
                selectedPairRate = pair.rate
                tokenName = pair.currencyTo ?? ""
                tokenCurrency = pair.currencyFrom ?? ""
                self.fromCurrency = pair.currencyTo ?? ""
            } else {
                selectedPairRate = nil
            }
            if let pairRates = selectedPairRate {
                let pairRatesValue: Double = {
                    switch pairRates {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                tokenRate = "\(pairRatesValue)"
                
            } else {
                tokenRate = "0"
            }
            let payPrice = Double(tokenRate) ?? 0.0
            let payableAmount = pay * payPrice
            if self.txtGet.text == "" {
            } else {
                let value = payableAmount
                let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 6)
                self.toCurrency = "\(tokenCurrency)"
                
                self.txtPay.text = "\(formattedValue)"
                let total = payableAmount + self.totalFees
                let totalBalance = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 3)
                self.lblTotal.text = "\(totalBalance) \(tokenCurrency)"
            }
            self.txtPay.hideLoading()
            let localizedRateString = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokenNameRate, comment: "")
            let formattedRateString = String(format: localizedRateString, tokenName)
            self.lblRateTitle.text = formattedRateString
            
            let rate = WalletData.shared.formatDecimalString("\(tokenRate)", decimalPlaces: 6)
            self.lblRate.text = "\(rate) \(tokenCurrency)"
            let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
            let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: "\(tokenName)")
            self.btnContinue.setTitle(message, for: .normal)
        }
    }
}
extension BuyCardDashboardViewController {
    func showLastFourDigits(of input: String) -> String {
        let length = input.count
        guard length > 4 else {
            return input
        }
        let start = input.index(input.endIndex, offsetBy: -4)
        let lastFour = input[start..<input.endIndex]
        return "***" + lastFour
    }
}
