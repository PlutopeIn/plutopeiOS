//
//  TopUpCardViewController+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 06/06/24.
//

import UIKit
// MARK: UITextFieldDelegate
extension TopUpCardViewController : UITextFieldDelegate {
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
//            let text = txtGet.text ?? ""
            var numberString = ""
            if isFromCollectionView == true {
                numberString = txtGet.text?.filter { "0123456789".contains($0) } ?? ""
            } else {
                numberString = txtGet.text ?? ""
            }
            
            if numberString == "" {
                lblPayError.text = ""
                lblGetError.text = ""
            }
            if (Double(numberString) ?? 0.0) > 0 {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall1), object: nil)
                perform(#selector(apiCall1), with: nil, afterDelay: 1)
            } else {
                txtPay.text = ""
                self.txtPay.hideLoading()
                lblPayError.text = ""
                lblGetError.text = ""
                
            }
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
    }
    @objc private func apiCall1() {
        getTokenAmount()
    }
    /// getBestPrice
     func getBestPrice() {
         DispatchQueue.main.async {
             print("enterAmount",Double(self.txtPay.text ?? "") ?? 0.0)
             let balanceDouble = self.balance.asDouble
             print("✅ Converted:", balanceDouble)
             if Double(self.txtPay.text ?? "") ?? 0.0 > balanceDouble {
                 self.btnContinue.alpha = 0.5
                 self.btnContinue.isEnabled = false
                 self.lblPayError.isHidden = false
                 self.txtPay.textColor = UIColor.red
                 self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                 self.lblGetError.isHidden = false
                 self.txtGet.textColor = UIColor.red
                 self.lblGetError.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "") // "Not enough funds"
             } else if Double(self.txtPay.text ?? "") ?? 0.0 > Double(self.lblMax.text ?? "") ?? 0.0 {
                 self.btnContinue.alpha = 0.5
                 self.btnContinue.isEnabled = false
                 self.lblPayError.isHidden = false
                 self.txtPay.textColor = UIColor.red
                 self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.samllAmountError, comment: "") // "Enter a smaller amount"
                 self.lblGetError.isHidden = false
                 self.txtGet.textColor = UIColor.red
                 self.lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.samllAmountError, comment: "") // "Enter a smaller amount"
                 
             } else  if Double(self.txtPay.text ?? "") ?? 0.0 < Double(self.lblMin.text ?? "") ?? 0.0 {
                 self.btnContinue.alpha = 0.5
                 self.btnContinue.isEnabled = false
                 self.lblPayError.isHidden = false
                 self.txtPay.textColor = UIColor.red
                 self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.heigherAmountError, comment: "") // "Enter a heigher amount"
                 self.lblGetError.isHidden = false
                 self.txtGet.textColor = UIColor.red
                 self.lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.heigherAmountError, comment: "") // "Enter a heigher amount"
                 
             } else {
                 self.lblPayError.text = ""
                 self.lblGetError.text = ""
                 self.txtPay.textColor = UIColor.label
                 self.txtGet.textColor = UIColor.label
                 self.btnContinue.alpha = 1
                 self.btnContinue.isEnabled = true
             }
             let pay = Double(self.txtPay.text ?? "") ?? 0.0
             let selectedToken = self.lblType1.text
             var tokenRate = ""
             var selectedPairRate: PriceValue?
             var tokenCurrency = ""
             var tokenName = ""
             if let pair = self.arrPayloadOtherData?.pairs?.first(where: { $0.currencyFrom == selectedToken }) {
                 selectedPairRate = pair.rate
                 tokenCurrency = pair.currencyTo ?? ""
                 tokenName = pair.currencyFrom ?? ""
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
               //  self.txtCurrency.text = "\(tokenCurrency)"
                 let total = payableAmount + self.totalFees
                 let totalBalance = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 6)
                 self.lblTotal.text = "\(totalBalance) \(tokenName)"
                 
             }
             self.txtGet.hideLoading()
             self.lblRateTitle.text = "\(tokenName) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
             self.lblRate.text = "\(tokenRate) \(tokenCurrency)"
             let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
             let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: self.toCurrency)
             self.btnContinue.setTitle(message, for: .normal)
            
         }
        
    }
    func getTokenAmount() {
        DispatchQueue.main.async {
            var numberString = ""
            if self.isFromCollectionView == true {
                numberString = self.txtGet.text?.filter { "0123456789".contains($0) } ?? ""
            } else {
                numberString = self.txtGet.text ?? ""
            }
            let pay = Double(numberString) ?? 0.0
            let selectedToken = self.lblType1.text
            var tokenRate = ""
            var selectedPairRate: PriceValue?
            var tokenCurrency = ""
            var tokenName = ""
            if let pair = self.arrPayloadOtherData?.pairs?.first(where: { $0.currencyFrom == selectedToken }) {
                selectedPairRate = pair.rate
                tokenCurrency = pair.currencyTo ?? ""
                tokenName = pair.currencyFrom ?? ""
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
                self.lblPayError.text = ""
                self.lblGetError.text = ""
            } else {
                let value = payableAmount
                let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 6)
                self.toCurrency = "\(tokenCurrency)"
                self.txtPay.text = "\(formattedValue)"
               
                let balanceDouble = self.balance.asDouble
                print("✅ Converted:", balanceDouble)
               
                if Double(self.txtPay.text ?? "") ?? 0.0 > balanceDouble {
                    self.btnContinue.alpha = 0.5
                    self.btnContinue.isEnabled = false
                    self.lblPayError.isHidden = false
                    self.txtPay.textColor = UIColor.red
                    self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                    self.lblGetError.isHidden = false
                    self.txtGet.textColor = UIColor.red
                    self.lblGetError.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                } else if Double(self.txtPay.text ?? "") ?? 0.0 > Double(self.lblMax.text ?? "") ?? 0.0 {
                    self.btnContinue.alpha = 0.5
                    self.btnContinue.isEnabled = false
                    self.lblPayError.isHidden = false
                    self.txtPay.textColor = UIColor.red
                    self.lblPayError.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.samllAmountError, comment: "")
                    self.lblGetError.isHidden = false
                    self.txtGet.textColor = UIColor.red
                    self.lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.samllAmountError, comment: "")
                    
                } else  if Double(self.txtPay.text ?? "") ?? 0.0 < Double(self.lblMin.text ?? "") ?? 0.0 {
                    self.btnContinue.alpha = 0.5
                    self.btnContinue.isEnabled = false
                    self.lblPayError.isHidden = false
                    self.txtPay.textColor = UIColor.red
                    self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.heigherAmountError, comment: "")
                    self.lblGetError.isHidden = false
                    self.txtGet.textColor = UIColor.red
                    self.lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.heigherAmountError, comment: "")
                    
                } else {
                    self.lblPayError.text = ""
                    self.lblGetError.text = ""
                    self.txtPay.textColor = UIColor.label
                    self.txtGet.textColor = UIColor.label
                    self.btnContinue.alpha = 1
                    self.btnContinue.isEnabled = true
                }
                let total = payableAmount + self.totalFees
                let totalBalance = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 6)
                self.lblTotal.text = "\(totalBalance) \(tokenName)"
            }
            self.txtPay.hideLoading()
            self.lblRateTitle.text = "\(tokenName) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
            self.lblRate.text = "\(tokenRate) \(tokenCurrency)"
            let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
            let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: self.toCurrency)
            self.btnContinue.setTitle(message, for: .normal)
        }
    }
}
