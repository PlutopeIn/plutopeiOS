//
//  SendCoin+ScannerDelegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 23/06/23.
//

import UIKit
import QRScanner
import Web3

// MARK: QRScannerDelegate
extension SendCoinViewController: QRScannerDelegate {
    func qrScannerDidFail(scanner: QRScanner.QRScannerViewController, error: QRScanner.QRScannerError) {
        
    }
    
    fileprivate func bitcoinRegex(_ range: Range<String.Index>,result : String) {
        let urlString = result
        // Extract the URL without query parameters
        let url = String(urlString[..<range.lowerBound])
        self.txtAddress.text = url
        print("URL: \(url)")
        
        // Extract the value of the "amount" query parameter, if present
        if let amountRange = urlString.range(of: "amount=") {
            let amountString = urlString[amountRange.upperBound...]
            if let amount = Double(amountString) {
                let price = Double(self.coinDetail?.price ?? "") ?? 0.0
                
                // Calculate the converted coin/token amount
               // let convertedBalance = amount * price
                var convertedBalance = 0.0
                self.checkScientificNotationForBalance(amountString, &convertedBalance, price, amount)
                self.btnMAX.isHidden = false
                self.btnCoin.isHidden = false
                self.btnCurrency.isHidden = true
                
                // Will show payable amount
                let payableAmount = convertedBalance / 1
                // Format and display the coin balance
                let coinBalance = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 5)
                self.lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "") \(coinBalance)"
                if self.isScientificNotation("\(amountString)") {
                    let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                    self.txtCoinQuantity.text = "\(weiToEther ?? "")"
                    self.textFieldDidChangeSelection(self.txtCoinQuantity)
                } else {
                    self.txtCoinQuantity.text = "\(amountString)"
                    self.textFieldDidChangeSelection(self.txtCoinQuantity)
                }
            }
        }
    }
    
    fileprivate func regexstartWith(_ addressRange: Range<String.Index>,result : String) {
        let trimmedUrl = result[addressRange.lowerBound...]
        print("Address: \(trimmedUrl)")
        let urlString = String(trimmedUrl)
        // Check for the presence of "&" in the urlString
        if let range = urlString.range(of: "&") {
            // Extract the URL without query parameters
            let url = String(urlString[..<range.lowerBound])
            let inputString = url
            let stringWithoutEqualSign = inputString.replacingOccurrences(of: "=", with: "")
            print(stringWithoutEqualSign)
            self.txtAddress.text = stringWithoutEqualSign
            print("URL: \(url)")
            
            // Extract the value of the "amount" query parameter, if present
            if let amountRange = urlString.range(of: "&uint256=") {
                let amountString = urlString[amountRange.upperBound...]
                print(amountString)
                if let amount = Double(amountString) {
                    let price = Double(self.coinDetail?.price ?? "") ?? 0.0
                    _ = self.coinDetail?.symbol ?? ""
                    
                    // Calculate the converted coin/token amount
                    var convertedBalance = 0.0
                    self.checkScientificNotationForBalance(amountString, &convertedBalance, price, amount)
                    self.btnMAX.isHidden = false
                    self.btnCoin.isHidden = false
                    self.btnCurrency.isHidden = true
                    
                    // Will show payable amount
                    let payableAmount = convertedBalance / 1
                    let formattedPrice = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 5)
                    self.lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedPrice)"
                    if self.isScientificNotation("\(amountString)") {
                        let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                        self.txtCoinQuantity.text = "\(weiToEther ?? "")"
                        self.textFieldDidChangeSelection(self.txtCoinQuantity)
                    } else {
                        self.txtCoinQuantity.text = "\(amountString)"
                        self.textFieldDidChangeSelection(self.txtCoinQuantity)
                    }
                }
            }
        } else {
            // No query parameters found, set the text field value directly
            self.txtAddress.text = urlString
            self.txtCoinQuantity.text = ""
        }
    }
    
     func checkScientificNotationForBalance(_ amountString: String.SubSequence, _ convertedBalance: inout Double, _ price: Double, _ amount: Double) {
        if self.isScientificNotation("\(amountString)") {
            let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
            let amountvalue = Double(weiToEther ?? "")
            convertedBalance = (amountvalue ?? 0.0) * price
        } else {
            convertedBalance = amount * price
        }
    }
    
    fileprivate func verifyPrifixBTC(result : String) {
        // Remove "bitcoin:" prefix if present
        if result.hasPrefix("bitcoin:") {
            var urlString = result
            urlString.removeFirst("bitcoin:".count)
            if urlString.hasPrefix("bc1") || urlString.hasPrefix("1") || urlString.hasPrefix("3") {
                if let range = urlString.range(of: "?") {
                    let resultStr = urlString
                    self.bitcoinRegex(range, result: resultStr)
                } else {
                    // No query parameters found, set the text field value directly
                    self.txtAddress.text = urlString
                    self.txtCoinQuantity.text = ""
                    
                }
            }
        } else if result.hasPrefix("bc1") || result.hasPrefix("1") || result.hasPrefix("3") {
            if let range = result.range(of: "?") {
                let resultStr = result
                self.bitcoinRegex(range, result: resultStr)
            } else {
                // No query parameters found, set the text field value directly
                self.txtAddress.text = result
                self.txtCoinQuantity.text = ""
                
            }
        } else {
            print("No address found.")
        }
    }
    
    func qrScannerDidSuccess(scanner: QRScanner.QRScannerViewController, result: String) {
        scanner.dismiss(animated: true) {
           // let input = result
            print(result)
            
            if result.hasPrefix("bitcoin:") || result.hasPrefix("bc1") || result.hasPrefix("1") || result.hasPrefix("3") {
                self.coinType = "BTC"
                if self.coinDetail?.type != self.coinType {
                    self.showToast(message: "Invalid \(self.coinDetail?.type ?? "") Address", font: AppFont.medium(15).value)
                    return
                }
                self.verifyPrifixBTC(result:result)
            }
            // Check for the presence of "=0x" in the result string
            if let addressRange = result.range(of: "=0x") {
                self.regexstartWith(addressRange,result: result)
            } else if let addressRange = result.range(of: "0x") {
                let trimmedUrl = result[addressRange.lowerBound...]
                print("Address: \(trimmedUrl)")
                let urlString = String(trimmedUrl)
                
                // Check for the presence of "?" in the urlString
                if let range = urlString.range(of: "@") {
                    // Extract the URL without query parameters
                    let url = String(urlString[..<range.lowerBound])
                    self.txtAddress.text = url
                    print("URL: \(url)")
                    
                    // Extract the value of the "amount" query parameter, if present
                    if let amountRange = urlString.range(of: "?value=") {
                        let amountString = urlString[amountRange.upperBound...]
                        if let amount = Double(amountString) {
                            let price = Double(self.coinDetail?.price ?? "") ?? 0.0
                            _ = self.coinDetail?.symbol ?? ""
                            let decimalValue = NSDecimalNumber(string: "\(amount)")
                            //let doubleValue = Double(decimalValue)
                            // Calculate the converted coin/token amount
                            var convertedBalance = 0.0
                            self.checkScientificNotationForBalance(amountString, &convertedBalance, price, amount)
                            
                            self.btnMAX.isHidden = false
                            self.btnCoin.isHidden = false
                            self.btnCurrency.isHidden = true
                            
                            // Will show payable amount
                            let payableAmount = convertedBalance / 1
                            let formattedPrice = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 5)
                            self.lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedPrice)"
                            
                            if self.isScientificNotation("\(amountString)") {
                                let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                                self.txtCoinQuantity.text = "\(weiToEther ?? "")"
                                print("Amount: \(weiToEther ?? "")")
                            } else {
                                self.txtCoinQuantity.text = "\(amountString)"
                            }
                           
                        }
                    }
                }
                // Check for the presence of "?" in the urlString
                else if let range = urlString.range(of: "?") {
                    // Extract the URL without query parameters
                    let url = String(urlString[..<range.lowerBound])
                    self.txtAddress.text = url
                    print("URL: \(url)")
                    
                    // Extract the value of the "amount" query parameter, if present
                    if let amountRange = urlString.range(of: "amount=") {
                        let amountString = urlString[amountRange.upperBound...]
                        if let amount = Double(amountString) {
                            let price = Double(self.coinDetail?.price ?? "") ?? 0.0
                            _ = self.coinDetail?.symbol ?? ""
                            
                            // Calculate the converted coin/token amount
                           // let convertedBalance = amount * price
                            var convertedBalance = 0.0
                            self.checkScientificNotationForBalance(amountString, &convertedBalance, price, amount)
                            self.btnMAX.isHidden = false
                            self.btnCoin.isHidden = false
                            self.btnCurrency.isHidden = true
                            
                            // Will show payable amount
                            let payableAmount = convertedBalance / 1
                            //                            self.lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "")\(payableAmount.rounded(toPlaces: 10))"
                            let coinBalance = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 5)
                            self.lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "") \(coinBalance)"
                            
                            if self.isScientificNotation("\(amountString)") {
                                let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                                self.txtCoinQuantity.text = "\(weiToEther ?? "")"
                                self.textFieldDidChangeSelection(self.txtCoinQuantity)
                                print("Amount: \(weiToEther ?? "")")
                            } else {
                                self.txtCoinQuantity.text = "\(amountString)"
                                self.textFieldDidChangeSelection(self.txtCoinQuantity)
                            }
                            print("Amount: \(amount)")
                        }
                    }
                } else {
                    // No query parameters found, set the text field value directly
                    self.txtAddress.text = urlString
                    self.txtCoinQuantity.text = ""
                }
                
                // Check if the address is in the list of contacts
                let allContactAddress = DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
                if allContactAddress?.contains(where: { $0.address?.lowercased() == (self.txtAddress.text ?? "").lowercased() }) == true {
                    self.btnAddAddress.isHidden = true
                } else {
                    self.btnAddAddress.isHidden = false
                }
            }
            
        }
        //} // else cointype !=bitcoin
    }
    
//    func isScientificNotation(_ input: String) -> Bool {
//        let scientificNotationRegex = "^[+-]?\\d*\\.?\\d+([eE][+-]?\\d+)?$"
//
//        if let range = input.range(of: scientificNotationRegex, options: .regularExpression) {
//            return range.lowerBound == input.startIndex && range.upperBound == input.endIndex
//        }
//
//        return false
//    }
    
    func isScientificNotation(_ input: String) -> Bool {
        let scientificNotationRegex = #"[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)"#

        if let range = input.range(of: scientificNotationRegex, options: .regularExpression) {
            return range.lowerBound == input.startIndex && range.upperBound == input.endIndex
        }

        return false
    }
}

// MARK: SelectContactDelegate
extension SendCoinViewController: SelectContactDelegate {
    
    func selectContact(_ contact: Contacts) {
        self.txtAddress.text = contact.address ?? ""
        self.btnAddAddress.isHidden = true
    }
    
}
/*
 if let result = self.extractQRCodeScannerInfo(input: result) {
 let (address, valueAmount, prefix) = result
 print("Address: \(address), Value/Amount: \(valueAmount), Prefix: \(prefix)")
 self.txtAddress.text = address
 self.txtCoinQuantity.text = valueAmount
 
 } else {
 print("No match found.")
 }
 
 let allContactAddress = DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
 if allContactAddress?.contains(where: { $0.address?.lowercased() == (self.txtAddress.text ?? "").lowercased() }) == true {
 self.btnAddAddress.isHidden = true
 } else {
 self.btnAddAddress.isHidden = false
 } */

/// Remove prefix if it's there before address
//            if let addressRange = result.range(of: "0x") {
//                let trimmedUrl = result[addressRange.lowerBound...]
//                print("Address: \(trimmedUrl)")
//
//                let urlString: String = String(trimmedUrl)
//                if urlString.contains("?") {
//                    if let range = urlString.range(of: "?") {
//
//                        // Extract the URL without query parameters
//                        let url = String(urlString[..<range.lowerBound])
//                        self.txtAddress.text = url
//                        print("URL: \(url)")
//                        // Extract the value of the "amount" query parameter, if present
//                        if let amountRange = urlString.range(of: "amount=") {
//                            let amountString = urlString[amountRange.upperBound...]
//                            if let amount = Double(amountString) {
//
//                                let amount = Double(amount)
//                                let price = Double(self.coinDetail?.price ?? "") ?? 0.0
//                                let symbol = self.coinDetail?.symbol ?? ""
//                                // Calculate the converted coin/Token amount
//                                let convertedBalance = (amount * price)
//
//                                self.btnMAX.isHidden = false
//                                self.btnCoin.isHidden = false
//                                self.btnCurrency.isHidden = true
//
//                                /// Will show payable amount
//                                let payableAmount = ( convertedBalance ) / 1
//                                self.lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "")\(payableAmount)"
//
////                                self.lblYourCoinBal.text = "~\(convertedBalance) \(symbol)"
//                                self.txtCoinQuantity.text = "\(amount)"
//                                print("Amount: \(amount)")
//
//                            }
//                        }
//                    }
//
//                }  else {
//                    // No query parameters found, set the text field value directly
//                    self.txtAddress.text = urlString
//                    self.txtCoinQuantity.text = ""
//                }
//                let allContactAddress = DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
//                if allContactAddress?.contains(where: { $0.address?.lowercased() == (self.txtAddress.text ?? "").lowercased() }) == true {
//                    self.btnAddAddress.isHidden = true
//                } else {
//                    self.btnAddAddress.isHidden = false
//                }
//            } else {
//                print("No address found.")
//            }
extension Float {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}
