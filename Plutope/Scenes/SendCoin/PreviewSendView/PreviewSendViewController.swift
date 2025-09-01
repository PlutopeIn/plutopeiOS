//
//  PreviewSwap1ViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import UIKit
import Web3
import QRScanner
import AVFoundation
import Foundation
protocol ConfirmSendDelegate : AnyObject {
    func confirmSend()
    func confirmSendWithLavrageFee(gasPrice:String,gasLimit:String,nonce:String)
}

class PreviewSendViewController: UIViewController {
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTokenAmount: UILabel!
    
    @IBOutlet weak var lblAssets: UILabel!
    
    @IBOutlet weak var lblFromAddress: UILabel!
    
    @IBOutlet weak var ivSettings: UIImageView!
    @IBOutlet weak var btnConfirm: GradientButton!
    @IBOutlet weak var lblMaxTotal: UILabel!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var lblToAddress: UILabel!
    weak var refreshWalletDelegate: RefreshDataDelegate?
    
    @IBOutlet weak var lblMaxText: UILabel!
    @IBOutlet weak var lblAssetsText: UILabel!
    @IBOutlet weak var lblNetworkFeeText: UILabel!
    @IBOutlet weak var lblToText: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var imgSymbol: UIImageView!
   
    @IBOutlet weak var imgGassp: UIImageView!
    @IBOutlet weak var vwNewtworkFee: UIView!
    var gasfee = ""
    var coinDetail : Token?
    var tokenAmount = ""
    var tokentype = ""
    var tokenPrice = ""
    var assets = ""
    var fromAddress = ""
    var fromAddressType: UInt32 = 0
    var toBtcWalletAddres = false
    var toAddress = ""
    var maxTotal = ""
    var gasPrice = ""
    var gasLimit = ""
    var nonce = ""
    var networkFee = ""
    var stringWithoutPrefix = ""
    var isFromSettings = false
    var gasAmount = ""
    var getNetworkFee = ""
    var calculatedGasPrice = ""
    var amount = ""
    var isSelectedIvLow = false
    var isSelectedIvMarket = false
    var isSelectedIvAggressive = false
    var transHex = ""
    var walletAddress = ""
    weak var delegate: ConfirmSendDelegate?
    
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            // self.btnDone.HideLoader()
        }
    }()
    fileprivate func uiSetUp() {
        
        /// Set coin image
        if let logoURI = coinDetail?.logoURI, !logoURI.isEmpty {
            imgSymbol.sd_setImage(with: URL(string: logoURI))
        } else {
            imgSymbol.image = coinDetail?.chain?.chainDefaultImage
        }
        
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        self.lblAssetsText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.asset, comment: "")
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblToText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblMaxText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxtotal, comment: "")
        self.lblTokenAmount.font = AppFont.violetRegular(25).value
        self.lblPrice.font = AppFont.regular(14.02).value
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// setSendDetail
        setSendDetail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetUp()
        /// go to settings screen
        lblNetworkFee.addTapGesture {
            HapticFeedback.generate(.light)
            let settingsVC = SettingPreviewViewController()
            settingsVC.gasPrice = self.gasPrice
            settingsVC.nonce = self.nonce
            settingsVC.gasLimit = self.gasLimit
            settingsVC.coinDetail = self.coinDetail
            settingsVC.toAddress = self.toAddress
            settingsVC.delegate = self
            let originalString = self.tokenAmount
            settingsVC.tokenAmount = self.amount
            settingsVC.networkFee = self.networkFee
            settingsVC.gasAmount = self.gasAmount
            settingsVC.fromAddress = self.fromAddress
            settingsVC.fromAddressType = self.coinDetail?.chain?.coinType.rawValue ?? 0
            settingsVC.toBtcWalletAddres = self.toBtcWalletAddres
            settingsVC.isSelectedIvLow = self.isSelectedIvLow
            settingsVC.isSelectedIvMarket = self.isSelectedIvMarket
            settingsVC.isSelectedIvAggressive = self.isSelectedIvAggressive
            settingsVC.modalTransitionStyle = .crossDissolve
            settingsVC.modalPresentationStyle = .overFullScreen
            self.present(settingsVC, animated: true)
        }
        
        imgGassp.addTapGesture {
            HapticFeedback.generate(.light)
            let settingsVC = SettingPreviewViewController()
            settingsVC.gasPrice = self.gasPrice
            settingsVC.nonce = self.nonce
            settingsVC.gasLimit = self.gasLimit
            settingsVC.coinDetail = self.coinDetail
            settingsVC.toAddress = self.toAddress
            settingsVC.delegate = self
            let originalString = self.tokenAmount
            settingsVC.tokenAmount = self.amount
            settingsVC.networkFee = self.networkFee
            settingsVC.gasAmount = self.gasAmount
            settingsVC.fromAddress = self.fromAddress
            settingsVC.fromAddressType = self.coinDetail?.chain?.coinType.rawValue ?? 0
            settingsVC.toBtcWalletAddres = self.toBtcWalletAddres
            settingsVC.isSelectedIvLow = self.isSelectedIvLow
            settingsVC.isSelectedIvMarket = self.isSelectedIvMarket
            settingsVC.isSelectedIvAggressive = self.isSelectedIvAggressive
            settingsVC.modalTransitionStyle = .crossDissolve
            settingsVC.modalPresentationStyle = .overFullScreen
            self.present(settingsVC, animated: true)
        }
    }
    
    func setSendDetail() {
        
        lblAssets.text = assets
        stringWithoutPrefix = tokenPrice.replacingOccurrences(of: "~", with: "")
        lblPrice.text = stringWithoutPrefix
        lblFromAddress.text = fromAddress
        lblToAddress.text = toAddress
        _ = tokenAmount
        self.amount = tokenAmount
        
        lblTokenAmount.text = "-\(tokenAmount) \(tokentype)"
        DGProgressView.shared.showLoader(to: self.view)
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            var allCoin: [Token] = []
            print("coindetail",coinDetail)
//            if  coinDetail?.chain?.name == "Arbitrum" &&  coinDetail?.chain?.symbol == "ARB" {
//                // Special case for Arbitrum + ARB
//                allCoin = allToken.filter {
//                    $0.type == coinDetail?.type &&
//                    $0.symbol == coinDetail?.chain?.symbol
//                }
//            }
//            else if coinDetail?.chain?.name == "Base" &&  coinDetail?.chain?.symbol == "BASE" {
//                allCoin = allToken.filter {
//                    $0.type == coinDetail?.type &&
//                    $0.symbol == coinDetail?.chain?.symbol
//                }
//            }
//            else {
//                // Default case
//                allCoin = allToken.filter {
//                    $0.type == coinDetail?.type &&
//                    $0.symbol == coinDetail?.chain?.symbol
//                }
//            }
            
            //            let allCoin = allToken.filter { $0.address == "" && $0.type == coinDetail?.type && $0.symbol == coinDetail?.chain?.symbol ?? "" }
            print("allToken",allCoin)
            _ = Double(self.amount) ?? 0.0
            var address = ""
            print("allCoinPrice",coinDetail?.price)
            if fromAddressType == CoinType.bitcoin.rawValue {
                address = toAddress
            } else if toBtcWalletAddres {
                address = fromAddress
            } else {
                address = toAddress
            }
            self
                .coinDetail?.callFunction.getGasFee(address, tokenAmount: Double(self.amount) ?? Double(2) , completion: { status, data, gasPrice,gasLimit,nonce,res  in
                    if status {
                        self.gasfee = data ?? ""
                        self.gasPrice = gasPrice ?? ""
                        self.gasLimit = gasLimit ?? ""
                        self.nonce = nonce ?? ""
                        let fee = self.gasfee
                        print(fee)
                        let convertedValue = UnitConverter.convertWeiToEther(fee,self.coinDetail?.chain?.decimals ?? 0) ?? ""
                        print("convertedValue",convertedValue)
                        print("allCoin.first?.price" ,self.coinDetail?.price ?? "")
                        let gasAmount = ((Double(convertedValue) ?? 0.0) * (Double(self.coinDetail?.price ?? "") ?? 0.0))
                        self.gasAmount = "\(gasAmount)"
                        print("self.gasAmount",self.gasAmount)
                        let originalString = convertedValue
                        if let originalNumber = Double(originalString) {
                            //   let formattedString = String(format: "%.8f", originalNumber)
                            print("Orignalnum",originalNumber)
                            let formattedString = originalNumber
                            print("formattedStringnetworkFee",formattedString)
                            let networkFee = WalletData.shared.formatDecimalString("\(convertedValue)", decimalPlaces: 12)
                            print("networkFee",networkFee)
                            self.networkFee = networkFee
                            print(formattedString)
                            DispatchQueue.main.async {
                                DGProgressView.shared.hideLoader()
                                let priceValue = WalletData.shared.formatDecimalString("\(gasAmount)", decimalPlaces: 4)
                                var coinSymbol = ""
                                if  self.coinDetail?.name == "Arbitrum" &&  self.coinDetail?.tokenId == "arbitrum" {
                                    coinSymbol = "ETH" }
                                else if self.coinDetail?.name == "Base" &&  self.coinDetail?.tokenId == "base" {coinSymbol = "ETH" }
                                else if self.coinDetail?.name == "Optimism" &&  self.coinDetail?.tokenId == "optimism" {coinSymbol = "ETH" }
                                else {
                                    coinSymbol = self.coinDetail?.chain?.symbol ?? ""
                                }
                                
                                
                                let networkFee = "\(networkFee) \(coinSymbol) (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
                                self.lblNetworkFee.attributedText  =  networkFee.underLined
                                let originalString = self.stringWithoutPrefix
                                
                                do {
                                    let regex = try NSRegularExpression(pattern: "([0-9]+\\.*[0-9]*)", options: [])
                                    if let match = regex.firstMatch(in: originalString, options: [], range: NSMakeRange(0, originalString.count)) {
                                        if let range = Range(match.range, in: originalString) {
                                            let numericSubstring = originalString[range]
                                            if let numericValue = Double(numericSubstring) {
                                                print(numericValue) // This will print the numeric value as a Double
                                                
                                                let maxTotal = numericValue  + gasAmount
                                                let maxTotalValue = WalletData.shared.formatDecimalString("\(maxTotal)", decimalPlaces: 4)
                                                self.maxTotal = "\(maxTotalValue)"
                                                self.lblMaxTotal.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(maxTotalValue)"
                                            }
                                        }
                                    }
                                } catch {
                                    print("Regular expression failed: \(error)")
                                }
                            }
                        }
                        
                    }
                    
                })
        }
    }
   
    @IBAction func btnConfirmSwapAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if UserDefaults.standard.value(forKey: DefaultsKey.isTransactionSignin) != nil {
            guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
            guard let viewController = sceneDelegate.window?.rootViewController else { return }
            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: viewController, completion: { status in
                if status {
                    if self.isFromSettings {
                        
                        DGProgressView.shared.showLoader(to: self.view)
                        let price = BigInt(self.gasPrice) ?? 0
                        _ = UnitConverter.gweiToWei(price)
                        self.confirmSendWithLavrageFee(gasPrice: "\(self.gasPrice)", gasLimit: self.gasLimit, nonce: self.nonce)
                        
                    } else {
                        
                        DGProgressView.shared.showLoader(to: self.view)
                        self.confirmSend()
                        
                    }
                    
                }
            })
        } else {
            if self.isFromSettings {

                DGProgressView.shared.showLoader(to: self.view)
                let price = BigInt(self.gasPrice) ?? 0
                let gasPriceValue = UnitConverter.gweiToWei(price)
                self.confirmSendWithLavrageFee(gasPrice: "\(self.gasPrice)", gasLimit: self.gasLimit, nonce: self.nonce)

            } else {

                DGProgressView.shared.showLoader(to: self.view)
                self.confirmSend()
            }
        }
    }
    
    func confirmSend() {
        
        coinDetail?.callFunction.sendTokenOrCoin(toAddress, tokenAmount: Double(self.amount) ?? 0.0) { status, errMsg, ethereumData in
           
            if status {
                DispatchQueue.main.async {
                    DGProgressView.shared.hideLoader()
                    self.walletActivityLog { }
                    self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
                          
                    }
                    self.transHex = ethereumData?.hex() ?? ""
                    print(self.transHex)
                    DispatchQueue.main.async {
                        self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
                    }
//                    self.walletActivityLog {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if let navigationController = self.navigationController {
//                                print("self.navigationController ",self.navigationController?.viewControllers)
                                for viewController in navigationController.viewControllers {
                                    if let walletDash = viewController as? WalletDashboardViewController {
                                        print("gotoHome")
                                        self.refreshWalletDelegate = walletDash
                                        self.refreshWalletDelegate?.refreshData()
                                        self.navigationController?.popToViewController(walletDash, animated: true)
                                        
                                    }
                                }
                            } else {
                                self.refreshWalletDelegate?.refreshData()
                                self.refreshWalletDelegate = nil
                            }
//
//
//                            if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
//                                self.refreshWalletDelegate = rootViewController
//                                self.refreshWalletDelegate?.refreshData()
//                                self.navigationController?.popToViewController(rootViewController, animated: true)
//                                
//                            } else {
//                                self.refreshWalletDelegate?.refreshData()
//                                self.refreshWalletDelegate = nil
//                            }
                            self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
                            //                        self.navigationController?.popToRootViewController(animated: true)
                            
                        }
//                    } // walletActivityLog end
                }
            } else {
                DGProgressView.shared.hideLoader()
               
                DispatchQueue.main.async {
                print("errMsg = ",errMsg)
                    if let inputString = errMsg,
                       let range = inputString.range(of: #"message: "(.*?)""#, options: NSString.CompareOptions.regularExpression) {
                        
                        // Extract the error message from the matched range
                        let errorMessage = String(inputString[range]
                                                    .dropFirst("message: \"".count)
                                                    .dropLast("\"".count))
                        
                        print(errorMessage)
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: errorMessage, font: AppFont.regular(15).value)
                    } else {
                        // Handle case where the error message is not found
                        print("Error message not found")
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: errMsg ?? "", font: AppFont.regular(15).value)
                    }

//                    self.showSimpleAlert(Message: errMsg ?? "")
//                    DGProgressView.shared.hideLoader()
//                    self.showToast(message: errMsg ?? "", font: AppFont.regular(15).value)
                }
            }
        }
    }
    func confirmSendWithLavrageFee(gasPrice: String, gasLimit: String, nonce: String) {
        
        coinDetail?.callFunction.sendTokenOrCoinWithLavrageFee(toAddress, tokenAmount: Double(self.amount) ?? 0.0, nonce: nonce, gasAmount: gasPrice, gasLimit: gasLimit) { status, errMsg, ethereumData in
            DispatchQueue.main.async {
               
                if status {
                    DGProgressView.shared.hideLoader()
                    self.transHex = ethereumData?.hex() ?? ""
                    self.walletActivityLog {}
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
//                            self.refreshWalletDelegate = rootViewController
//                            self.refreshWalletDelegate?.refreshData()
//                            self.navigationController?.popToViewController(rootViewController, animated: true)
//                        } else {
//                            self.refreshWalletDelegate?.refreshData()
//                            self.refreshWalletDelegate = nil
//                        }
                        if let navigationController = self.navigationController {
                            for viewController in navigationController.viewControllers {
                                if let walletDash = viewController as? WalletDashboardViewController {
                                    self.refreshWalletDelegate = walletDash
                                    self.refreshWalletDelegate?.refreshData()
                                    self.navigationController?.popToViewController(walletDash, animated: true)
                                    break
                                }
                            }
                        } else {
                            self.refreshWalletDelegate?.refreshData()
                            self.refreshWalletDelegate = nil
                        }
                        self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
                    }
                //}

                } else {
                    let inputString = errMsg
                    
                    if let inputString = errMsg,
                       let range = inputString.range(of: #"message: "(.*?)""#, options: NSString.CompareOptions.regularExpression) {
                        
                        // Extract the error message from the matched range
                        let errorMessage = String(inputString[range]
                                                    .dropFirst("message: \"".count)
                                                    .dropLast("\"".count))
                        
                        print(errorMessage)
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: errorMessage, font: AppFont.regular(15).value)
                    } else {
                        // Handle case where the error message is not found
                        print("Error message not found")
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: errMsg ?? "", font: AppFont.regular(15).value)
                    }
                    
                }
            }
        }
    }
}
extension PreviewSendViewController : SettingsViewControllerDelegate {
    func selectedValue(isSelectedLow: Bool, isSelectedMarket: Bool, isSelectedAggressive: Bool) {
        
        self.isSelectedIvLow = isSelectedLow
        self.isSelectedIvMarket = isSelectedMarket
        self.isSelectedIvAggressive = isSelectedAggressive
        print(isSelectedLow,isSelectedMarket,isSelectedAggressive)
    }
    func getMaxFee(_ networkFee: String) {
        
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            let allCoin = allToken.filter { $0.address == "" && $0.type == coinDetail?.type && $0.symbol == coinDetail?.chain?.symbol ?? "" }
            _ = Double(self.amount) ?? 0.0
            
            DispatchQueue.main.async {
                self.lblNetworkFee.text = "\(networkFee)"
                
                let originalString = self.stringWithoutPrefix
                do {
                    let regex = try NSRegularExpression(pattern: "([0-9]+\\.*[0-9]*)", options: [])
                    if let match = regex.firstMatch(in: originalString, options: [], range: NSMakeRange(0, originalString.count)) {
                        if let range = Range(match.range, in: originalString) {
                            let numericSubstring = originalString[range]
                            if let numericValue = Double(numericSubstring) {
                                print(numericValue) // This will print the numeric
                                let maxTotal = numericValue  + (((Double(self.gasAmount) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0)))
                                
                                let maxTotalValue = WalletData.shared.formatDecimalString("\(maxTotal)", decimalPlaces: 3)
                                self.lblMaxTotal.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(maxTotalValue)"
                            }
                        }
                    }
                } catch {
                    print("Regular expression failed: \(error)")
                }
            }
        }
    }
    
    func getNetworkFee(gaslimit: String, nonce: String, gasPrice: String, isFromSettings: Bool, networkFee: String, gasAmount: String) {
        self.getNetworkFee = networkFee
        self.networkFee = networkFee
        self.isFromSettings = isFromSettings
        //  self.calculatedGasPrice = gasPrice
        self.gasAmount = "\(gasAmount)"
        self.gasLimit = gaslimit
        self.nonce = nonce
        
        let price = BigInt(gasPrice) ?? 0
        let gasPriceValue = UnitConverter.gweiToWei(price)
        self.gasPrice = "\(gasPriceValue)"
        
        getMaxFee(networkFee)
        
    }
}
// MARK: RefreshDataDelegate
extension PreviewSendViewController: RefreshDataDelegate {
    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
        }
        
        // self.btnAddAddress.isHidden = true
    }
}

extension PreviewSendViewController {
    
    func walletActivityLog(completion: @escaping () -> Void) {
        
        
        if self.coinDetail?.chain?.coinType == .bitcoin {
            walletAddress = WalletData.shared.getPublicWalletAddress(coinType: .bitcoin) ?? ""
        } else {
            walletAddress = WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? ""
        }
             // Define the URL
        guard let url = URL(string: "https://plutope.app/api/wallet-activity-log") else {
            print("Invalid URL")
            return
        }

        // Define the request body
        let json: [String: Any] = [
            "walletAddress": "\(walletAddress)",
            "transactionType": TransactionType.send.rawValue,
            "transactionHash": "\(self.transHex)",
            "providerType": "",
            "tokenDetailArrayList": [
                [
                    "from": [
                        "chainId": "\(self.coinDetail?.chain?.chainId ?? "")",
                        "symbol": "\(self.coinDetail?.chain?.symbol ?? "")",
                        "address":"\(self.coinDetail?.chain?.walletAddress ?? "")"
                    ],
                    "to": [
                        "chainId": "",
                        "symbol": "",
                        "address":"\(self.toAddress)"
                    ]
                ]
            ]
        ]

        // Convert the JSON to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Failed to serialize JSON data")
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Create the URLSession
        let session = URLSession.shared

        // Create a data task to send the request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse the response data if needed
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(jsonResponse)")
            } catch {
                print("Failed to parse JSON response: \(error)")
            }
            completion()
        }

        // Start the task
        task.resume()

    }
}
