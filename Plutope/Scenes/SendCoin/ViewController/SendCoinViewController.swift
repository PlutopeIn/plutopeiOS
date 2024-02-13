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

class SendCoinViewController: UIViewController, Reusable {
    
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBOutlet weak var txtAddress: customTextField!
    @IBOutlet weak var txtCoinQuantity: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblAmountCoin: UILabel!
    @IBOutlet weak var btnCoin: UIButton!
    @IBOutlet weak var btnCurrency: UIButton!
    @IBOutlet weak var lblYourCoinBal: UILabel!
    @IBOutlet weak var btnMAX: UIButton!
    var gasPrice  = ""
    var gasLimit = ""
    var nonce = ""
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnPaste: UIButton!
    @IBOutlet weak var lblAddressNaming: UILabel!
    let key = "uPW*brqXJ3uwAWT#-8HYRXy=pe=hV%zh".data(using: .utf8)
    let iv = "41b126e31bd2a511".data(using: .utf8)
    var encryptedKey  = ""
    var decryptedKey  = ""
    var coinType = ""
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
    weak var refreshWalletDelegate: RefreshDataDelegate?
    
    fileprivate func uiSetUp() {
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.next, comment: ""), for: .normal)
        self.btnMAX.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: ""), for: .normal)
        self.btnPaste.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paste, comment: ""), for: .normal)
        self.lblAddressNaming.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addressornamingservice, comment: "")
        let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        btnAddAddress.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addthisaddresstoyouraddressbook, comment: ""), for: .normal)
        lblAmountCoin.text = "\(amount) \(coinDetail?.symbol ?? "")"
        btnCoin.setTitle(coinDetail?.symbol ?? "", for: .normal)
        btnCurrency.setTitle(WalletData.shared.primaryCurrency?.symbol, for: .normal)
        txtCoinQuantity.delegate = self
        txtAddress.delegate = self
        self.btnAddAddress.isHidden = true
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
        
        uiSetUp()
       
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
        DispatchQueue.main.async {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                self.txtAddress.leftSpacing = 15
                self.txtAddress.rightSpacing = 130
                self.txtCoinQuantity.leftSpacing = 15
                self.txtCoinQuantity.rightSpacing =  125
                self.txtAddress.textAlignment = .right
                self.txtCoinQuantity.textAlignment = .right
            } else {
                self.txtAddress.leftSpacing = 15
                self.txtAddress.rightSpacing = 130
                self.txtCoinQuantity.leftSpacing = 15
                self.txtCoinQuantity.rightSpacing =  125
                self.txtAddress.textAlignment = .left
                self.txtCoinQuantity.textAlignment = .left
            }
        }
        
    }
    
    //    actionContact
    @IBAction func actionContact(_ sender: Any) {
        let addressContactsVC = AddressContactsViewController()
        addressContactsVC.isFromSend = true
        addressContactsVC.selectContactDelegate = self
        self.navigationController?.pushViewController(addressContactsVC, animated: true)
    }
    
    //    actionScan
    @IBAction func actionScan(_ sender: Any) {
        checkForCameraPermission()
        self.coinType = ""
        let scanner = QRScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    
    //    actionPaste
    @IBAction func actionPaste(_ sender: Any) {
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
        txtCoinQuantity.text = coinDetail?.balance
        
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
    
    //    actionCurrencyTap
    @IBAction func actionCurrencyTap(_ sender: Any) {
        btnMAX.isHidden = false
        btnCoin.isHidden = false
        btnCurrency.isHidden = true
        txtCoinQuantity.text = ""
        lblYourCoinBal.text = ""
       let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        lblAmountCoin.text = "\(amount) \(coinDetail?.symbol ?? "")"
    }
    
    //    addToAddressBookAction
    @IBAction func addToAddressBookAction(_ sender: Any) {
        let popUpVc = SaveContactPopUpViewController()
        popUpVc.address = self.txtAddress.text ?? ""
        popUpVc.refreshDataDelegate = self
        popUpVc.modalTransitionStyle = .crossDissolve
        popUpVc.modalPresentationStyle = .overFullScreen
        self.present(popUpVc, animated: true)
    }
    
    //    actionContinue
    @IBAction func actionContinue(_ sender: Any) {
       
        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
           // if resStatus == 1 {
                print(message)
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
        
        let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(coinDetail?.price ?? "") ?? 0.0)
        
        guard let coinAmount = !btnCoin.isHidden ? Double(coinQuantityText) : coinQuantityFromPrice, let coinBalance = Double(coinDetail?.balance ?? "") else {
            return
        }
        
        if coinAmount <= 0 {
            showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
            return
        }
        let toWalletAddress = try? EthereumAddress(hex: address, eip55: false) 

        let btcWalletAddress = address.validateBTCAddress()
        if toWalletAddress != nil  || btcWalletAddress {
        } else {
            showToast(message: ToastMessages.invalidAddress, font: AppFont.regular(15).value)
            return
        }
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
                      
                        self.showToast(message: ToastMessages.coinSend, font: AppFont.regular(15).value)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if let rootViewController = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
                                self.refreshWalletDelegate = rootViewController
                            } else {
                                self.refreshWalletDelegate = nil
                            }
                            self.refreshWalletDelegate?.refreshData()
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                } else {
//                    self.showSimpleAlert(Message: message)
                    self.showToast(message: message , font: AppFont.regular(15).value)
                    
                }
            }
        } else {
            let sendPreviewVC = PreviewSendViewController()
            sendPreviewVC.assets = "\(coinDetail?.name ?? "")(\(coinDetail?.symbol ?? ""))"
            sendPreviewVC.coinDetail = self.coinDetail
            if !btnCoin.isHidden {
                
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
            self.navigationController?.pushViewController(sendPreviewVC, animated: true)
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
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""), style: .cancel, handler: nil))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UITextFieldDelegate
extension SendCoinViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if textField == txtCoinQuantity {
            if !btnCoin.isHidden {
                let payableAmount = ( (Double(text) ?? 0.0) * (Double(coinDetail?.price ?? "") ?? 0.0) ) / 1
                /// Will show payable amount
                
                let getbalance = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 10)
                lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "") \(getbalance)"
            } else {
                /// Will show payable token/coin
                let amount = (Double(text) ?? 0) / (Double(coinDetail?.price ?? "") ?? 0.0)
                let stringValue = String(amount)
                
                let getbalance = WalletData.shared.formatDecimalString("\(stringValue)", decimalPlaces: 8)
                lblYourCoinBal.text = "~ \(getbalance) \(coinDetail?.symbol ?? "")"
            }
        }
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
        self.showToast(message: ToastMessages.contactAdded, font: AppFont.regular(15).value)
        self.btnAddAddress.isHidden = true
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
