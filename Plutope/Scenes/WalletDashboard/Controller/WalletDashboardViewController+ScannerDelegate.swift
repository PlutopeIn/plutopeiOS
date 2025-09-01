//
//  WalletDashboardViewController+ScannerDelegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 15/03/24.
//

import UIKit
import QRScanner
import Web3
import WalletConnectSign
import WalletConnectUtils
import ReownWalletKit
import Combine
// MARK: QRScannerDelegate
extension WalletDashboardViewController: QRScannerDelegate {
    func qrScannerDidFail(scanner: QRScanner.QRScannerViewController, error: QRScanner.QRScannerError) {
        
    }
    
    fileprivate func bitcoinRegex(_ range: Range<String.Index>,result : String) {
        let urlString = result
        // Extract the URL without query parameters
        let url = String(urlString[..<range.lowerBound])
        self.sendAddress = url
        print("URL: \(url)")
        
        // Extract the value of the "amount" query parameter, if present
        if let amountRange = urlString.range(of: "amount=") {
            let amountString = urlString[amountRange.upperBound...]
            if let amount = Double(amountString) {
                if self.isScientificNotation("\(amountString)") {
                    let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                    sendCoinQuantity = "\(weiToEther ?? "")"
                } else {
                    sendCoinQuantity = "\(amountString)"
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
            self.sendAddress = stringWithoutEqualSign
            print("URL: \(url)")
            
            // Extract the value of the "amount" query parameter, if present
            if let amountRange = urlString.range(of: "&uint256=") {
                let amountString = urlString[amountRange.upperBound...]
                print(amountString)
                if let amount = Double(amountString) {
                    if self.isScientificNotation("\(amountString)") {
                        let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                        sendCoinQuantity = "\(weiToEther ?? "")"
                    } else {
                        sendCoinQuantity = "\(amountString)"
                    }
                }
            }
        } else {
            // No query parameters found, set the text field value directly
            sendAddress = urlString
            sendCoinQuantity = ""
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
                    self.sendAddress = urlString
                    self.sendCoinQuantity = ""
                    
                }
            }
        } else if result.hasPrefix("bc1") || result.hasPrefix("1") || result.hasPrefix("3") {
            if let range = result.range(of: "?") {
                let resultStr = result
                self.bitcoinRegex(range, result: resultStr)
            } else {
                // No query parameters found, set the text field value directly
                self.sendAddress = result
                self.sendCoinQuantity = ""
                
            }
        } else {
            print("No address found.")
        }
    }
    func extractValueBeforeColon(from string: String) -> String? {
        let components = string.components(separatedBy: ":")
        if components.count > 1 {
            return components[0]
        }
        return nil
    }
    // swiftlint:disable function_body_length
    fileprivate func passingValueForScanner(value : String? = nil,urlString :String? = nil) {
        
        if value == "wc" {
            // Do nothing and return
            pairClient(uri: urlString ?? "")
            return
        }

        if self.coinType != "" {
            let sendCoinVC = SendCoinViewController()
            chainTokenList?.forEach { token in
                switch token.symbol {
                    case "ETH" where self.coinType == "ETH",
                         "POL" where self.coinType == "POL",
                         "BNB" where self.coinType == "BNB",
                         "BTC" where self.coinType == "BTC":
                        if token.address == "" {
                            coinDetail = token
                        }
                    default:
                        break
                }
            }
//            if self.coinType != "ETH" || self.coinType != "MATIC" ||  self.coinType != "BNB" ||  self.coinType != "BTC" {
//                return
//            }
            sendCoinVC.coinDetail = self.coinDetail
            sendCoinVC.sendAddress = self.sendAddress
            sendCoinVC.sendCoinQuantity = self.sendCoinQuantity
            sendCoinVC.isFrom = "Dashboard"
            sendCoinVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sendCoinVC, animated: true)
        } else {
//            if self.coinType != "ETH" || self.coinType != "MATIC" ||  self.coinType != "BNB" ||  self.coinType != "BTC" {
//                return
//            }
            let sendCoinVC = BuyCoinListViewController()
            sendCoinVC.isFrom = .send
            UserDefaults.standard.set(self.sendAddress, forKey: "sendAddress")
            UserDefaults.standard.set(self.sendCoinQuantity, forKey: "sendCoinQuantity")
            sendCoinVC.fromDashbord = "Dashboard"
            sendCoinVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sendCoinVC, animated: true)
        }

    }
    
    private func pair(uri: WalletConnectURI) {
        Task.detached(priority: .high) { @MainActor [unowned self] in
            do {
                try await self.interactor.pair(uri: uri)
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
            }
        }
    }
    /// pair to client
    func pairClient(uri: String) {
        print("[WALLET] Pairing to: \(uri)")
        do {
            let uri = try WalletConnectURI(uriString: uri)
            print("URI: \(uri)")
            self.pair(uri: uri)
//            self.router.dismiss()
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError.toggle()
        }

//        guard let uri = WalletConnectURI(string: uri) else {
//            return
//        }
//        Task {
//            do {
//                //self.showPairingLoading = true
//                try await WalletKit.instance.pair(uri: uri)
//                
//            } catch {
//              //  self.showPairingLoading = false
//                print("[DAPP] Pairing connect error: \(error)")
//            }
//        }
    }
    func qrScannerDidSuccess(scanner: QRScanner.QRScannerViewController, result: String) {
        var prefixValue = ""
        scanner.dismiss(animated: true) {
            print(result)
            
            if let value = self.extractValueBeforeColon(from: result) {
                print("Value before colon: \(value)")
                if value == "smartchain" {
                    self.coinType = "BNB"
                } else if value == "polygon" {
                    self.coinType = "POL"
                } else if value == "ethereum" {
                    self.coinType = "ETH"
                } else if value == "bitcoin" || value == "bc1" || value == "1" || value == "3" {
                    self.coinType = "BTC"
                } else if value == "wc" {
                    prefixValue = value
                } else {
                    self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidAddressMsg, comment: ""), font: AppFont.regular(15).value)
                    return
                }
                
            } 
//            else {
//                print("No value found before colon.")
//                self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidAddressMsg, comment: ""), font: AppFont.regular(15).value)
//                return
//            }
           
            if result.hasPrefix("bitcoin:") || result.hasPrefix("bc1") || result.hasPrefix("1") || result.hasPrefix("3") {
                self.coinType = "BTC"
                self.verifyPrifixBTC(result:result)
            } else {
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
                        self.sendAddress = url
                        print("URL: \(url)")
                        
                        // Extract the value of the "amount" query parameter, if present
                        if let amountRange = urlString.range(of: "?value=") {
                            let amountString = urlString[amountRange.upperBound...]
                            if let amount = Double(amountString) {
                                if self.isScientificNotation("\(amountString)") {
                                    let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                                    self.sendCoinQuantity = "\(weiToEther ?? "")"
                                } else {
                                    self.sendCoinQuantity = "\(amountString)"
                                }
                                
                            }
                        }
                    }
                    // Check for the presence of "?" in the urlString
                    else if let range = urlString.range(of: "?") {
                        // Extract the URL without query parameters
                        let url = String(urlString[..<range.lowerBound])
                        self.sendAddress = url
                        print("URL: \(url)")
                        
                        // Extract the value of the "amount" query parameter, if present
                        if let amountRange = urlString.range(of: "amount=") {
                            let amountString = urlString[amountRange.upperBound...]
                            if Double(amountString) != nil {
                                if self.isScientificNotation("\(amountString)") {
                                    let weiToEther = UnitConverter.convertWeiToEther(String(amountString), 18)
                                    self.sendCoinQuantity = "\(weiToEther ?? "")"
                                } else {
                                    self.sendCoinQuantity = "\(amountString)"
                                }
                            }
                        }
                    } else {
                        // No query parameters found, set the text field value directly
                        self.sendAddress = urlString
                        self.sendCoinQuantity = ""
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.passingValueForScanner(value: prefixValue,urlString: result)
        }
    }
    // swiftlint:enable function_body_length
    
    func isScientificNotation(_ input: String) -> Bool {
        let scientificNotationRegex = #"[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)"#

        if let range = input.range(of: scientificNotationRegex, options: .regularExpression) {
            return range.lowerBound == input.startIndex && range.upperBound == input.endIndex
        }

        return false
    }
}
