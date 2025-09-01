//
//  SendCoinViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import QRScanner
import AVFoundation
import Web3
// swiftlint:disable type_body_length
class SendCoinViewController: UIViewController, Reusable {
    
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBOutlet weak var txtAddress: customTextField!
//    @IBOutlet weak var txtCoinQuantity: customTextField!
    @IBOutlet weak var txtCoinQuantity: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblAmountCoin: UILabel!
//    @IBOutlet weak var btnCoin: UIButton!
    
    @IBOutlet weak var btnCoin: UILabel!
//    @IBOutlet weak var btnCurrency: UIButton!
    
    @IBOutlet weak var lblYourCoinBal: UILabel!
    @IBOutlet weak var btnMAX: UIButton!
    var gasPrice  = ""
    var gasLimit = ""
    var nonce = ""
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnPaste: UIButton!
    @IBOutlet weak var lblAddressNaming: UILabel!
    
    @IBOutlet weak var imgSymbol: UIImageView!
    @IBOutlet weak var lblCoinBalance: UILabel!
    @IBOutlet weak var lblNetworkType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnCurrency: UILabel!
    
    @IBOutlet weak var leftView: UIView!
 
    var encryptedKey  = ""
    var decryptedKey  = ""
    var coinType = ""
    var sendAddress = ""
    var sendCoinQuantity = ""
    var isFrom = ""
    var fromDashbord = ""
    var transHex = ""
    var walletAddress  = ""
    var isSelectedLable = false
    var finalValue = ""
    lazy var viewModel: SendBTCCoinViewModel = {
        SendBTCCoinViewModel { _ , _ in
            // self.showToast(message: message, font: .systemFont(ofSize: 15))
           
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
         //   self.showToast(message: message, font: .systemFont(ofSize: 15))
            // self.btnDone.HideLoader()
        }
    }()
    var coinDetail : Token?
    lazy var primaryWallet: Wallets? = nil
    var tokensList: [Token]? = []
    weak var refreshWalletDelegate: RefreshDataDelegate?
    
    fileprivate func uiSetUp() {
        
        if let coinDetail = self.coinDetail {
            if coinDetail.symbol == "usdc.e" {
                coinDetail.symbol = "usdt"
            }
        }
     //   print(coinDetail?.symbol?.lowercased() == "usdc.e")
   
        let balanceString = WalletData.shared.formatDecimalString("\(coinDetail?.balance ?? "0")", decimalPlaces: 8)
        lblCoinBalance.text = "\(balanceString) \(coinDetail?.symbol ?? "")"
        lblNetworkType.text = coinDetail?.type
        /// Set coin image
//        if let logoURI = coinDetail?.logoURI, !logoURI.isEmpty {
////            imgSymbol.sd_setImage(with: URL(string: logoURI))
//            if logoURI == "" {
//                imgSymbol.sd_setImage(with: URL(string: "https://plutope.app/api/images/applogo.png"))
//            } else {
//                imgSymbol.sd_setImage(with: URL(string: logoURI))
//            }
//        } else {
//            imgSymbol.image = coinDetail?.chain?.chainDefaultImage
//        }
        var logoURI = coinDetail?.logoURI ?? ""
        if coinDetail?.tokenId == "PLT".lowercased() {
           
            if logoURI == "" {
                imgSymbol.sd_setImage(with: URL(string: "https://plutope.app/api/images/applogo.png"))
            } else {
                imgSymbol.sd_setImage(with: URL(string: logoURI))
            }
        } else {
            if logoURI == "" {
                imgSymbol.sd_setImage(with: URL(string: logoURI))
            } else {
                imgSymbol.sd_setImage(with: URL(string: logoURI))
            }
        }
        
        
        lblPrice.text = "1 \(coinDetail?.symbol ?? "") = \(WalletData.shared.primaryCurrency?.sign ?? "")\(coinDetail?.price ?? "0")"
        
//        self.btnMAX.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: ""), for: .normal)
        
        let localizedTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: "")

        // Create an attributed string with underline style
        let attributedTitle = NSAttributedString(string: localizedTitle, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])

        // Set the attributed title for the button
        self.btnMAX?.setAttributedTitle(attributedTitle, for: .normal)
        
        // Set the image to the right side
//        self.btnCoin.semanticContentAttribute = .forceRightToLeft

//        self.btnPaste.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paste, comment: ""), for: .normal)
        self.lblAddressNaming.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addressornamingservice, comment: "")
        let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        btnAddAddress.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addthisaddresstoyouraddressbook, comment: ""), for: .normal)
        lblAmountCoin.text = "\(amount) \(coinDetail?.symbol ?? "")"
//        btnCoin.setTitle(coinDetail?.symbol ?? "", for: .normal)
        
        btnCoin.text = "\(coinDetail?.symbol ?? "")"
        
//        btnCurrency.setTitle(WalletData.shared.primaryCurrency?.symbol, for: .normal)
        
        btnCurrency.text = "\(WalletData.shared.primaryCurrency?.symbol ?? "")"
        txtCoinQuantity.delegate = self
        txtAddress.delegate = self
        self.btnAddAddress.isHidden = true
        btnAddAddress.isUserInteractionEnabled = true
        if(coinDetail?.chain?.coinType == CoinType.bitcoin) {
            self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendBitcoin, comment: ""), for: .normal)
        } else {
            self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.next, comment: ""), for: .normal)
        }
        
        lblCoinBalance.font = AppFont.violetRegular(26).value
        lblAddressNaming.font = AppFont.violetRegular(15).value
        lblAmountCoin.font = AppFont.violetRegular(15).value
        lblPrice.font = AppFont.regular(16).value
        lblNetworkType.font = AppFont.regular(10.53).value
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtAddress.textAlignment = .right
                txtCoinQuantity.textAlignment = .right
            } else {
                txtAddress.textAlignment = .left
                txtCoinQuantity.textAlignment = .left
            }
            
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        let titleText = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send,comment: "")
        defineHeader(headerView: headerView, titleText:"\(titleText) \(coinDetail?.symbol ?? "")")
        self.uiSetUp()
        if isFrom == "Dashboard" {
            txtAddress.text = sendAddress
            txtCoinQuantity.text = sendCoinQuantity
            self.textFieldDidChangeSelection(self.txtCoinQuantity)
        }
         
        if fromDashbord == "Dashboard" {
            let sendAddress = UserDefaults.standard.string(forKey: "sendAddress")
            let sendCoinQuantityvalue = UserDefaults.standard.string(forKey: "sendCoinQuantity")
            txtAddress.text = sendAddress
            txtCoinQuantity.text = sendCoinQuantityvalue
            self.textFieldDidChangeSelection(self.txtCoinQuantity)
        }
        self.checkForCameraPermission()
        let privateKey = WalletData.shared.walletBTC?.privateKey ?? ""
     //   let privateKey = "cRxJ9jx3cUBGpY9teQPAJ541Cp4LJscY5agNgxTPv4PfZCeN4SJB"
        let encryptionManager = EncryptionManager()
        
        if let encrypted = encryptionManager.encrypt(privateKey: privateKey) {
            print("Encrypted: \(encrypted)")
            self.encryptedKey = encrypted
            if let decrypted = encryptionManager.decrypt(encryptedPrivateKey: encrypted) {
                print("Decrypted: \(decrypted)")
                self.decryptedKey =  decrypted
            }
        }
      //  DispatchQueue.main.async {
            
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                self.txtAddress.leftSpacing = 15
                self.txtAddress.rightSpacing = 130
                self.txtAddress.textAlignment = .right
                self.txtCoinQuantity.textAlignment = .right
            } else {
                self.txtAddress.leftSpacing = 15
                self.txtAddress.rightSpacing = 130
                self.txtAddress.textAlignment = .left
                self.txtCoinQuantity.textAlignment = .left
            }
        
        self.txtCoinQuantity.keyboardType = .decimalPad
        
        btnCurrency.addTapGesture {
            self.btnMAX.isHidden = false
            self.btnCoin.isHidden = false
            self.btnCurrency.isHidden = false
            self.txtCoinQuantity.text = ""
            self.lblYourCoinBal.text = ""
            let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
            let tempText = self.btnCoin.text
            self.btnCoin.text = self.btnCurrency.text
            self.btnCurrency.text = tempText
            if self.btnCoin.text == WalletData.shared.primaryCurrency?.symbol ?? "" {
                self.btnMAX.isHidden = true
                self.isSelectedLable = true
                self.lblAmountCoin.text = "\(amount) \(WalletData.shared.primaryCurrency?.symbol ?? "")"
               
            } else {
                self.btnMAX.isHidden = false
                self.isSelectedLable = false
                self.lblAmountCoin.text = "\(amount) \(self.coinDetail?.symbol ?? "")"
            }
          
        }
        
        btnCoin.addTapGesture {
            
            self.btnMAX.isHidden = false
            self.btnCoin.isHidden = false
            self.btnCurrency.isHidden = false
            self.txtCoinQuantity.text = ""
            self.lblYourCoinBal.text = ""
            let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
            
            let tempText = self.btnCoin.text
            self.btnCoin.text = self.btnCurrency.text
            self.btnCurrency.text = tempText
            if self.btnCoin.text == WalletData.shared.primaryCurrency?.symbol ?? "" {
                self.btnMAX.isHidden = true
                self.isSelectedLable = true
                self.lblAmountCoin.text = "\(amount) \(WalletData.shared.primaryCurrency?.symbol ?? "")"
                
            } else {
                self.btnMAX.isHidden = false
                self.isSelectedLable = false
                self.lblAmountCoin.text = "\(amount) \(self.coinDetail?.symbol ?? "")"
            }
            
        }
        
        self.btnMAX.titleLabel?.textColor = .label
        
    }
    
    //    actionContact
    @IBAction func actionContact(_ sender: Any) {
        HapticFeedback.generate(.light)
        let addressContactsVC = AddressContactsViewController()
        addressContactsVC.isFromSend = true
        addressContactsVC.selectContactDelegate = self
        self.navigationController?.pushViewController(addressContactsVC, animated: true)
    }
    
    //    actionScan
    @IBAction func actionScan(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.coinType = ""
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                let scanner = QRScannerViewController()
                scanner.delegate = self
                self.present(scanner, animated: true, completion: nil)
            }
        case .denied, .restricted:
            self.showCameraSettingsAlert()
        case .notDetermined:
            // Request camera permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        let scanner = QRScannerViewController()
                        scanner.delegate = self
                        self.present(scanner, animated: true, completion: nil)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    //    actionPaste
    @IBAction func actionPaste(_ sender: Any) {
        HapticFeedback.generate(.light)
        if let copiedText = UIPasteboard.general.string {
            // Use the copied text here
            txtAddress.text = copiedText
            let allContactAddress = DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
            if allContactAddress?.contains(where: { $0.address?.lowercased() == (self.txtAddress.text ?? "").lowercased() }) == true || (!(txtAddress.text?.validateContractAddress() ?? false)) {
                self.btnAddAddress.isHidden = true
            } else {
                self.btnAddAddress.isHidden = false
            }
        }
    }
    
    //    actionMax
    @IBAction func actionMax(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtCoinQuantity.text = coinDetail?.balance
        self.textFieldDidChangeSelection(self.txtCoinQuantity)
    }
    
    //    actionCoinTap
    @IBAction func actionCoinTap(_ sender: Any) {
        btnMAX.isHidden = true
        btnCoin.isHidden = true
        btnCurrency.isHidden = false
        txtCoinQuantity.text = ""
        lblYourCoinBal.text = ""
        let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        lblAmountCoin.text = "\(amount) \(WalletData.shared.primaryCurrency?.symbol ?? "")"
       
    }
    
//    @objc func btnCoinlabelTapped() {
//        btnMAX.isHidden = true
//        btnCoin.isHidden = true
//        btnCurrency.isHidden = false
//        txtCoinQuantity.text = ""
//        lblYourCoinBal.text = ""
//        let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
//        lblAmountCoin.text = "\(amount) \(WalletData.shared.primaryCurrency?.symbol ?? "")"
//    }
    
    //    actionCurrencyTap
    @IBAction func actionCurrencyTap(_ sender: Any) {
        HapticFeedback.generate(.light)
        btnMAX.isHidden = false
        btnCoin.isHidden = false
        btnCurrency.isHidden = true
        txtCoinQuantity.text = ""
        lblYourCoinBal.text = ""
       let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        lblAmountCoin.text = "\(amount) \(coinDetail?.symbol ?? "")"
    }
    @IBAction func swepBtnAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        let tempText = self.btnCoin.text
//        self.btnCoin.text = self.btnCurrency.text
//        self.btnCurrency.text = tempText
//        if btnCoin.text == "INR" {
//            self.btnMAX.isHidden = true
//        } else {
//            self.btnMAX.isHidden = false
//        }
    }
    
    //    addToAddressBookAction
    @IBAction func addToAddressBookAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let popUpVc = SaveContactPopUpViewController()
        popUpVc.address = self.txtAddress.text ?? ""
        popUpVc.refreshDataDelegate = self
        popUpVc.modalTransitionStyle = .crossDissolve
        popUpVc.modalPresentationStyle = .overFullScreen
        self.present(popUpVc, animated: true)
    }
   
    //    actionContinue
    @IBAction func actionContinue(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
           // if resStatus == 1 {
                print("registermsg",message)
            // }
        }
        guard let address = txtAddress.text?.trimmingCharacters(in: .whitespaces), !address.isEmpty, let coinType = coinDetail?.chain?.coinType  else {
            showToast(message: ToastMessages.addressRequired, font: AppFont.regular(15).value)
            return
        }
        
        guard let coinQuantityText = txtCoinQuantity.text?.trimmingCharacters(in: .whitespaces), !coinQuantityText.isEmpty else {
            showToast(message: ToastMessages.amountRequired, font: AppFont.regular(15).value)
            return
        }
        print("coinQuantityText",coinQuantityText)
        let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(coinDetail?.price ?? "") ?? 0.0)
        
        var test = "\(coinQuantityFromPrice)"
        print("coinQuantityFromPrice",test)
        let payDoubleValue = convertScientificToDouble(scientificNotationString: test)
        print("payDoubleValue",payDoubleValue)
        var coinAmount = 0.0
        if self.isSelectedLable == false {
            coinAmount = Double(coinQuantityText) ?? 0.0
            
        } else {
            coinAmount = payDoubleValue ?? 0.0
        }
       print("coinAmount",coinAmount)
        guard let coinBalance = Double(coinDetail?.balance ?? "") else {
            return
        }
        if coinAmount <= 0 {
            showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
            return
        }
        let toWalletAddress = try? EthereumAddress(hex: address, eip55: false) 
        print("toWalletAddress",toWalletAddress)
        let btcWalletAddress = address.validateBTCAddress()
        if toWalletAddress != nil  || btcWalletAddress {
        } else {
            showToast(message: ToastMessages.invalidAddress, font: AppFont.regular(15).value)
            return
        }
        print("coinAmount",coinAmount)
        print("coinBalance",coinBalance)
        if coinAmount > coinBalance {
            showToast(message: ToastMessages.lowBalance(coinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
            return
        }
        if(coinDetail?.chain?.coinType == CoinType.bitcoin) {
            
            DGProgressView.shared.showLoader(to: view)
            self.viewModel.sendBTCApi(privateKey: self.encryptedKey, value: self.txtCoinQuantity.text ?? "", toAddress:self.txtAddress.text ?? "" , env: "testnet", fromAddress: self.coinDetail?.chain?.walletAddress ?? "") { statusResult, message, resData in
                if statusResult == 1 {
                    DispatchQueue.main.async {
                        DGProgressView.shared.hideLoader()
                        self.transHex = resData ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
                        }
                        
                        self.walletActivityLog { }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
                                self.refreshWalletDelegate = rootViewController
                            } else {
                                self.refreshWalletDelegate = nil
                            }
                            self.refreshWalletDelegate?.refreshData()
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }
                   // }//
                    }
                } else {
//                    self.showSimpleAlert(Message: message)
                    self.showToast(message: message , font: AppFont.regular(15).value)
                    
                }
            }
//            self.viewModel.sendBTCApi(privateKey: self.encryptedKey, value: self.txtCoinQuantity.text ?? "", toAddress:self.txtAddress.text ?? "" , env: "testnet", fromAddress: walletAddress) { statusResult, message, resData in
//                if statusResult == 1 {
//                    DispatchQueue.main.async {
//                        DGProgressView.shared.hideLoader()
//                        self.transHex = resData ?? ""
//                        self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
//                        self.walletActivityLog {
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
//                                self.refreshWalletDelegate = rootViewController
//                            } else {
//                                self.refreshWalletDelegate = nil
//                            }
//                            self.refreshWalletDelegate?.refreshData()
//                            self.navigationController?.popToRootViewController(animated: true)
//                        }
//                    }//
//                    }
//                } else {
////                    self.showSimpleAlert(Message: message)
//                    self.showToast(message: message , font: AppFont.regular(15).value)
//                    
//                }
          //  }
        } else {
            let sendPreviewVC = PreviewSendViewController()
            sendPreviewVC.assets = "\(coinDetail?.name ?? "")(\(coinDetail?.symbol ?? ""))"
            sendPreviewVC.coinDetail = self.coinDetail
            if !self.isSelectedLable {
                sendPreviewVC.tokenAmount = txtCoinQuantity.text ?? ""
            } else {
                let str = lblYourCoinBal.text ?? ""
                let stringWithoutPrefix = str.replacingOccurrences(of: "~", with: "")
                print(stringWithoutPrefix)
               
                let originalString = stringWithoutPrefix
                if let result = extractSubstringBetweenWhitespaces(originalString) {
                    print(result)
                    sendPreviewVC.tokenAmount = result
                }
            }
            
            sendPreviewVC.tokentype = coinDetail?.symbol ?? ""
            sendPreviewVC.tokenPrice = self.lblYourCoinBal.text ?? ""
            sendPreviewVC.fromAddress = self.coinDetail?.chain?.walletAddress ?? ""
            sendPreviewVC.fromAddressType = self.coinDetail?.chain?.coinType.rawValue ?? 0
            sendPreviewVC.toAddress = txtAddress.text ?? ""
            sendPreviewVC.toBtcWalletAddres = btcWalletAddress
            
            let transition = CATransition()
            transition.duration = 0.1
            transition.type = .moveIn
            transition.subtype = .fromTop
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            
           // if let destinationViewController = sendPreviewVC {
                self.navigationController?.pushViewController(sendPreviewVC, animated: false)
            // }
//            self.navigationController?.pushViewController(sendPreviewVC, animated: true)
//            sendPreviewVC.modalPresentationStyle = .fullScreen
           // self.present(sendPreviewVC, animated: true, completion: nil)
        }
    }
    func convertScientificToDouble(scientificNotationString: String) -> Double? {
            // Create a NumberFormatter instance
            let formatter = NumberFormatter()

            // Set the number style to scientific
            formatter.numberStyle = .scientific

            // Convert the scientific notation string to a number
            if let number = formatter.number(from: scientificNotationString) {
                // Convert the number to a Double
                return number.doubleValue
            } else {
                return nil
            }
        }
    //    checkForCameraPermission
    func checkForCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .denied:
            showCameraSettingsAlert()
        case .restricted:
            break
        default: break
        }
    }
    
    // showCameraSettingsAlert
    func showCameraSettingsAlert() {
        let alert = UIAlertController(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccessDenied, comment: ""))", message: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccess, comment: ""))", preferredStyle: .alert)
        // Add an action to open the app's settings
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.openSetting, comment: ""))", style: .default, handler: { action in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        // Add a cancel action
        // alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), style: .cancel, handler: nil))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getTokensListFromCoredata() {
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        
        if primaryWallet == nil {
            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            primaryWallet = allWallet?.first(where: { $0.isPrimary })
        }
        
        guard let primaryWallet = primaryWallet else {
            // Handle the case when primaryWalletID is nil
            return
        }
        let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
        let enableTokens = getPrimaryWalletToken?.compactMap { $0.tokens  }
        let addressToRemove = "0x0000000000000000000000000000000000001010"

        self.tokensList = self.tokensList?.filter { token in
            return token.address != addressToRemove
        }
        self.tokensList = self.tokensList?.filter({ token1 in
            token1.symbol != "bnry".uppercased()
        })
//        print(tokensList)
        if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "ETH" {
            self.coinDetail = tokensList?.first
        } else if(tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "POL" {
            self.coinDetail = tokensList?.first
        } else if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "BNB" {
            self.coinDetail = tokensList?.first
        } else if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "OKT" {
            self.coinDetail = tokensList?.first
        } else if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "op" {
            self.coinDetail = tokensList?.first
        } else if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "ARB" {
            self.coinDetail = tokensList?.first
        } else if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "AVAX" {
            self.coinDetail = tokensList?.first
        } else if (tokensList?.first?.chain?.walletAddress == "") && tokensList?.first?.chain?.symbol == "base" {
            self.coinDetail = tokensList?.first
        }
        print(coinDetail)
    }
}

// MARK: UITextFieldDelegate
extension SendCoinViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if textField == txtCoinQuantity {
            if self.isSelectedLable == false {
                
                    let payableAmount = ( (Double(text) ?? 0.0) * (Double(coinDetail?.price ?? "") ?? 0.0) ) / 1
                    /// Will show payable amount
                    
                    let getbalance = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 10)
                if txtCoinQuantity.text != "" {
                    lblYourCoinBal.text = "= \(WalletData.shared.primaryCurrency?.sign ?? "") \(getbalance)"
                } else {
                    lblYourCoinBal.text = ""
                }
            } else {
                /// Will show payable token/coin
                let amount = (Double(text) ?? 0) / (Double(coinDetail?.price ?? "") ?? 0.0)
                let stringValue = String(amount)
                
                let getbalance = WalletData.shared.formatDecimalString("\(stringValue)", decimalPlaces: 8)
                if txtCoinQuantity.text != "" {
                    lblYourCoinBal.text = "= \(getbalance) \(coinDetail?.symbol ?? "")"
                    self.finalValue = lblYourCoinBal.text ?? ""
                } else {
                    lblYourCoinBal.text = ""
                }
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCoinQuantity {
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
        }
            return true // Allow input if it's valid
        }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//           // This method is called whenever the user types or pastes characters
//
//           // If the paste action is performed
//        
//        if textField == txtAddress {
//            if UIPasteboard.general.hasStrings, string.isEmpty {
//                // Call your action method
//            } else {
//                actionPaste(self) 
//            }
//        }
//           return true
//       }

}

// MARK: RefreshDataDelegate
extension SendCoinViewController: RefreshDataDelegate {
    func refreshData() {
        DispatchQueue.main.async {
            self.showToast(message: ToastMessages.contactAdded, font: AppFont.regular(15).value)
            self.btnAddAddress.isHidden = true
        }
       
    }
}
extension SendCoinViewController {
    func extractSubstringBetweenWhitespaces(_ inputString: String) -> String? {
        // Find the indices of all whitespaces
        let whitespaceIndices = inputString.indices.filter { inputString[$0] == " " }

        // Check if there are at least two whitespaces
        guard whitespaceIndices.count >= 2 else {
            // Handle the case where there are fewer than two whitespaces
            print("Not enough whitespaces in the string.")
            return nil
        }

        // Extract the substring starting from the index after the first whitespace up to the index of the second whitespace
        let resultString = inputString[inputString.index(after: whitespaceIndices[0])..<whitespaceIndices[1]]
        
        return String(resultString)
    }
}
extension SendCoinViewController {
    
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
                        "address":"\(txtAddress.text ?? "")"
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
// swiftlint:enable type_body_length
