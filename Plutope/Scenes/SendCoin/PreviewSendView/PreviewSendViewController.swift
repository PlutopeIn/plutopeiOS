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
protocol ConfirmSendDelegate : AnyObject {
    func confirmSend()
    func confirmSendWithLavrageFee(gasPrice:String,gasLimit:String,nonce:String)
}

class PreviewSendViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    
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
    weak var delegate: ConfirmSendDelegate?
    
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            // self.btnDone.HideLoader()
        }
    }()
    fileprivate func uiSetUp() {
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        self.lblAssetsText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.asset, comment: "")
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblToText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblMaxText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxtotal, comment: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// setSendDetail
        setSendDetail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfer, comment: ""))
        uiSetUp()
        /// go to settings screen
        lblNetworkFee.addTapGesture {
            let settingsVC = SettingPreviewViewController()
         //   let newFrontController = UINavigationController(rootViewController: settingsVC)
           
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
           // self.navigationController?.pushViewController(settingsVC, animated: true)
            settingsVC.modalTransitionStyle = .crossDissolve
            settingsVC.modalPresentationStyle = .overFullScreen
            self.present(settingsVC, animated: true)
        }
    }
    
    func setSendDetail() {
        
        lblAssets.text = assets
        stringWithoutPrefix = tokenPrice.replacingOccurrences(of: "~", with: "")
        print(stringWithoutPrefix)
        lblPrice.text = "≈ \(stringWithoutPrefix)"
        lblFromAddress.text = fromAddress
        lblToAddress.text = toAddress
//        lblTokenAmount.text = "-\(tokenAmount) \(tokentype)"
        let originalString = tokenAmount
        self.amount = tokenAmount
        
        lblTokenAmount.text = "-\(tokenAmount) \(tokentype)"
        DGProgressView.shared.showLoader(to: self.view)
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            let allCoin = allToken.filter { $0.address == "" && $0.type == coinDetail?.type && $0.symbol == coinDetail?.chain?.symbol ?? "" }
            _ = Double(self.amount) ?? 0.0
            var address = ""
         
            if fromAddressType == CoinType.bitcoin.rawValue {
                 address = toAddress
            } else if toBtcWalletAddres {
                address  = fromAddress
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
                        let gasAmount = ((Double(convertedValue) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0))
                        self.gasAmount = "\(gasAmount)"
                        let originalString = convertedValue
                        if let originalNumber = Double(originalString) {
                            //   let formattedString = String(format: "%.8f", originalNumber)
                            
                            let formattedString = originalNumber
                            let networkFee = WalletData.shared.formatDecimalString("\(formattedString)", decimalPlaces: 6)
                            print(networkFee)
                            self.networkFee = networkFee
                            print(formattedString)
                            DispatchQueue.main.async {
                                DGProgressView.shared.hideLoader()
                                let priceValue = WalletData.shared.formatDecimalString("\(gasAmount)", decimalPlaces: 2)
                                
                                let networkFee = "\(networkFee) \(self.coinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
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
        
        if UserDefaults.standard.value(forKey: DefaultsKey.isTransactionSignin) != nil {
            guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
            guard let viewController = sceneDelegate.window?.rootViewController else { return }
            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: viewController, completion: { status in
                if status {
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
//                    self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
//
//                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
                            self.refreshWalletDelegate = rootViewController
                            self.refreshWalletDelegate?.refreshData()
                            self.navigationController?.popToViewController(rootViewController, animated: true)
                            
                        } else {
                            self.refreshWalletDelegate?.refreshData()
                            self.refreshWalletDelegate = nil
                        }
                        self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
//                        self.navigationController?.popToRootViewController(animated: true)
                      
                    }
                }
            } else {
                DispatchQueue.main.async {
                    
                    let inputString = errMsg
                    
                    // Find the range of the error message within the string
                    if let range = inputString?.range(of: "message: \"(.*?)\"", options: .regularExpression) {
                        // Extract the error message using the range
                        let errorMessage = String(inputString?[range].dropFirst("message: \"".count).dropLast("\"".count) ?? "")
                        print(errorMessage)
                      //  self.showSimpleAlert(Message: errorMessage)
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: errorMessage , font: AppFont.regular(15).value)
                        
                    } else {
                        // Handle the case where the error message is not found
                        print("Error message not found")
                        DGProgressView.shared.hideLoader()
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
//                    self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
//                        
//                    }
                    DGProgressView.shared.hideLoader()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
                            self.refreshWalletDelegate = rootViewController
                            self.refreshWalletDelegate?.refreshData()
                            self.navigationController?.popToViewController(rootViewController, animated: true)
                            
                        } else {
                            self.refreshWalletDelegate?.refreshData()
                            self.refreshWalletDelegate = nil
                        }
                        self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
//                        self.navigationController?.popToRootViewController(animated: true)
                      
                    }
//                    self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
//                            self.refreshWalletDelegate = rootViewController
//                        } else {
//                            self.refreshWalletDelegate = nil
//                        }
//
//                        self.refreshWalletDelegate?.refreshData()
//                        self.navigationController?.popToRootViewController(animated: true)
//
//                    }
                } else {
                    let inputString = errMsg
                    
                    // Find the range of the error message within the string
                    if let range = inputString?.range(of: "message: \"(.*?)\"", options: .regularExpression) {
                        // Extract the error message using the range
                        let errorMessage = String(inputString?[range].dropFirst("message: \"".count).dropLast("\"".count) ?? "")
                        print(errorMessage)
                      //  self.showSimpleAlert(Message: errorMessage)
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: errorMessage , font: AppFont.regular(15).value)
                        
                    } else {
                        // Handle the case where the error message is not found
                        print("Error message not found")
                        DGProgressView.shared.hideLoader()
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
        self.showToast(message: ToastMessages.contactAdded, font: AppFont.regular(15).value)
        // self.btnAddAddress.isHidden = true
    }
}
