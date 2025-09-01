//
//  ExchangeCardViewController+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/06/24.
//

import Foundation
import UIKit

// MARK: UITextFieldDelegate
extension ExchangeCardViewController : UITextFieldDelegate {
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
            let text = txtGet.text ?? ""
            if text == "" {
                lblPayError.text = ""
                lblGetError.text = ""
            }
            let numberString = txtGet.text?.filter { "0123456789".contains($0) }
            print(numberString ?? "")
            if (Double(txtGet.text ?? "") ?? 0.0) > 0 {
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
        print("nscancel api call")
     //   txtGet.showLoading()
        getBestPrice()
        
    }
    @objc private func apiCall1() {
        print("nscancel api call1")
//        txtPay.showLoading()
        getTokenAmount()
    }
    /// getBestPrice
     func getBestPrice() {
         DispatchQueue.main.async {
             let balanceDouble = self.lblPayCoinBalance.text?.asDouble
             print("✅ Converted:", balanceDouble ?? 0.0)
             if Double(self.txtPay.text ?? "") ?? 0.0 > balanceDouble ?? 0.0 {
                 self.btnContinue.alpha = 0.5
                 self.btnContinue.isEnabled = false
                 self.lblPayError.isHidden = false
                 self.txtPay.textColor = UIColor.red
                 self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                 self.lblGetError.isHidden = false
                 self.txtGet.textColor = UIColor.red
                 self.lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
             } else  if  Double(self.txtPay.text ?? "") ?? 0.0 < Double(self.lblMin.text ?? "") ?? 0.0 {
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
             let pay = Double(self.txtPay.text ?? "") ?? 0.0
             let selectedToken1 = self.lblType1.text
             let selectedToken2 = self.lblType2.text
             var tokenRate = ""
             var selectedPairRate: PriceValue?
             var tokenCurrency = ""
             var tokenName = ""
             if let pair = self.arrExchangeCurrencyList?.pairs?.first(where: { $0.currencyFrom == selectedToken1 && $0.currencyTo == selectedToken2 }) {
                 selectedPairRate = pair.rateValue
                 tokenCurrency = pair.currencyFrom ?? ""
                 tokenName = pair.currencyTo ?? ""
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
                 self.fromCurrency = "\(tokenCurrency)"
                 self.txtGet.text = "\(formattedValue)"
             }
             self.txtGet.hideLoading()
             self.lblRateTitle.text = "\(tokenCurrency) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
             let rate = WalletData.shared.formatDecimalString("\(tokenRate)", decimalPlaces: 6)
             self.lblRate.text = "\(rate) \(tokenName)"
         }
    }
    func getTokenAmount() {
        DispatchQueue.main.async {
            let pay = Double(self.txtGet.text ?? "") ?? 0.0
            let selectedToken1 = self.lblType1.text
            let selectedToken2 = self.lblType2.text
            var tokenRate = ""
            var selectedPairRate: PriceValue?
            var tokenCurrency = ""
            var tokenName = ""
            if let pair = self.arrExchangeCurrencyList?.pairs?.first(where: { $0.currencyFrom == selectedToken1 && $0.currencyTo == selectedToken2}) {
                selectedPairRate = pair.rateValue
                tokenCurrency = pair.currencyFrom ?? ""
                tokenName = pair.currencyTo ?? ""
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
                self.toCurrency = "\(tokenName)"
                self.txtPay.text = "\(formattedValue)"
                let balanceDouble = self.lblPayCoinBalance.text?.asDouble
                print("✅ Converted:", balanceDouble ?? 0.0)
                if Double(self.txtPay.text ?? "") ?? 0.0 > balanceDouble ?? 0.0 {
                    self.btnContinue.alpha = 0.5
                    self.btnContinue.isEnabled = false
                    self.lblPayError.isHidden = false
                    self.txtPay.textColor = UIColor.red
                    self.lblPayError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                    self.lblGetError.isHidden = false
                    self.txtGet.textColor = UIColor.red
                    self.lblGetError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "")
                    
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
               
            }
            self.txtPay.hideLoading()
            self.lblRateTitle.text = "\(tokenCurrency) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
            let rate = WalletData.shared.formatDecimalString("\(tokenRate)", decimalPlaces: 6)
            self.lblRate.text = "\(rate) \(tokenName)"
        }
    }
}
