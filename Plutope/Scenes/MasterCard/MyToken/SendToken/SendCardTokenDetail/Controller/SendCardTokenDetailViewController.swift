//
//  SendCardTokenDetailViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import UIKit
import QRScanner
import AVFoundation
//protocol GotoSendDashboardDelegate : AnyObject {
//    func gotoSendDashboard()
//}
class SendCardTokenDetailViewController: UIViewController {

    @IBOutlet weak var stackAll: UIStackView!
    @IBOutlet weak var viewAllFund: UIView!
    @IBOutlet weak var lblToError: UILabel!
    @IBOutlet weak var lblFromError: UILabel!
    @IBOutlet weak var ivFeeInfo: UIImageView!
    @IBOutlet weak var ivScan: UIImageView!
    @IBOutlet weak var headerVieww: UIView!
    
    @IBOutlet weak var lblSendTitle: UILabel!
    
    @IBOutlet weak var btnWallets: UIButton!
    @IBOutlet weak var txtSend: LoadingTextField!
    
    @IBOutlet weak var ivCoin: UIImageView!
    
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblType1: DesignableLabel!
    
    @IBOutlet weak var lblAllFund: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var btnSend: GradientButton!
    
    @IBOutlet weak var lblAllFundTitle: UILabel!
    @IBOutlet weak var txtTo: LoadingTextField!
    
    @IBOutlet weak var lblToPay: UILabel!
    @IBOutlet weak var lblProcessingTimeTitle: UILabel!
    @IBOutlet weak var lblProcessingTime: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
//    weak var delegate : GotoSendDashboardDelegate?
    var arrWalletList : [Wallet] = []
    var walletArr : Wallet?
    var arrCurrencyList : [String] = []
    var priceDataValueSring : String = ""
    var tokentId : Int?
    var sendVia = ""
    var titleValue = ""
    var totalFees = 0.0
    var toCurrency = ""
    var tokenAddress = ""
    var feeValue = ""
    var sourceCurrency = ""
    var transactionType = ""
    var toWalletAddress = ""
    var addressPattern = ""
    var allFund = ""
    var transactionAvailability : Bool?
    lazy var sendCardTokenViewModel: SendCardTokenViewModel = {
        SendCardTokenViewModel { _ ,_ in
        }
    }()
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if sendVia == "walletAddress" {
            ivScan.isHidden = false
            viewAllFund.isUserInteractionEnabled = false
            txtTo.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletAddress1,comment: "")
            lblAllFund.isHidden = false
            
//            lblAllFund.text = "0.001"
            txtSend.textColor = UIColor.white
            txtTo.keyboardType = .default
           
            self.checkForCameraPermission()
        } else {
            txtTo.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumber1,comment: "")
            lblAllFundTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.all,comment: "")
            txtTo.maxLength = 15
            ivScan.isHidden = true
            lblAllFund.isHidden = true
            viewAllFund.isUserInteractionEnabled = false
        }
    }
    fileprivate func uiSetup() {
        lblTo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to,comment: "")
        lblToPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay1,comment: "")
        lblAllFundTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.min,comment: "")
        lblProcessingTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.processingTime,comment: "")
        lblTotalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalFees,comment: "")
        lblProcessingTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly,comment: "")
        btnSend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send,comment: ""), for: .normal)
        txtTo.placeHolderColor = UIColor.secondaryLabel
        txtSend.placeHolderColor = UIColor.secondaryLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWalletTokens()
        
        defineHeader(headerView: headerVieww, titleText: titleValue, btnBackHidden: false)
        txtSend.delegate = self
        txtTo.delegate = self
        uiSetup()
//        if sendVia == "walletAddress" {
//            ivScan.isHidden = false
//            txtTo.placeholder = "Wallet Address"
//            lblAllFund.isHidden = false
//            lblAllFund.text = "0.001"
//            txtSend.textColor = UIColor.white
//            txtTo.keyboardType = .default
//           
//            self.checkForCameraPermission()
//        } else {
//            txtTo.maxLength = 15
//            ivScan.isHidden = true
//            lblAllFund.isHidden = false
//        }
        viewAllFund.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtSend.text = self.allFund
//            self.textFieldDidChangeSelection(self.txtSend)
        }
        self.btnSend.alpha = 0.5
        self.btnSend.isEnabled = false

        ivScan.addTapGesture {
            HapticFeedback.generate(.light)
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
//                        DispatchQueue.main.async {
                            self.present(scanner, animated: true, completion: nil)
                        }
                    }
                }
            @unknown default:
                break
            }
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
    
    func getWalletTokens() {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.getTokenAPINew { status, data ,fiat , msg  in
            if status == 1 {
                DispatchQueue.main.async {
                    self.arrWalletList = data ?? []
                        guard let arrWallet = self.walletArr else { return }
                        // Find the wallet with the same name in arrPayWalletList
                        if let matchingWallet = self.arrWalletList.first(where: { $0.currency == arrWallet.currency }) {
                            // Update the UI elements with the matching wallet data
                            
                            self.ivCoin.sd_setImage(with: URL(string: "\(matchingWallet.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                            let balance = WalletData.shared.formatDecimalString(self.walletArr?.balanceString ?? "", decimalPlaces: 6)
                            self.lblType1.text = matchingWallet.currency ?? ""
                            self.lblBalance.text = balance
                            self.tokenAddress = matchingWallet.address ?? ""
                            if self.sendVia == "walletAddress" {
                                self.lblAllFund.text = "0.001"
                                self.allFund = self.lblAllFund.text ?? ""
                            } else {
                                self.lblAllFund.text = "\(balance) \(self.lblType1.text ?? "")"
                                self.allFund = "\(balance)"
                            }
                            
                            self.addressPattern = matchingWallet.pattern ?? ""
                            self.lblTotal.text = "0.0 \(self.sourceCurrency)"
                        }
                    DGProgressView.shared.hideLoader()
                }
            } else {
            }
            
        }
    }
    @IBAction func btnWalletAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtSend.text = ""
        txtTo.text = ""
        lblToError.text = ""
        lblFromError.text = ""
        let tokenListVC = MyTokenViewController()
        tokenListVC.isFrom = "sendCardWallet"
        tokenListVC.arrWalletList = self.arrWalletList
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
    }

    func getTokenFee(currency:String,amount:String,address:String? = "",phone:String? = "",isFrom:String) {
        DGProgressView.shared.showLoader(to: view)
        sendCardTokenViewModel.getFeeAPI(currency: currency, amount: amount, address: address ?? "", phone: phone ?? "",isFrom: isFrom) { resStatus, resMsg,dataValue in
            if resStatus == 1 {
                DispatchQueue.main.async {
                    
                    if let fee = dataValue?.fee {
                        let feeeValue: Double = {
                            switch fee {
                            case .int(let value):
                                return Double(value)
                            case .double(let value):
                                return value
                            }
                        }()
                       self.feeValue = "\(feeeValue)"
                    } else {
                        self.feeValue = "0"
                    }
                    self.sourceCurrency = dataValue?.sourceCurrency ?? ""
                    self.transactionType = dataValue?.transactionType ?? ""
                    self.transactionAvailability = ((dataValue?.transactionAvailability) != nil)
                    
                    let totalFee = (Double(self.txtSend.text ?? "") ?? 0.0) + (Double(self.feeValue) ?? 0.0)
                    self.lblTotal.text = "\(totalFee) \(self.sourceCurrency)"
                    
                    let amount = Double(self.txtSend.text ?? "0.0") ?? 0.0
                    let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""), amount: amount, currency: self.sourceCurrency)

                    self.btnSend.setTitle(message, for: .normal)
                    DGProgressView.shared.hideLoader()
                    self.dismissKeyboard()
//                    self.btnSend.setTitle("Send \(self.txtSend.text ?? "") \(self.sourceCurrency)", for: .normal)
                }
            } else {
                self.showToast(message: resMsg, font: AppFont.regular(15).value)
                DGProgressView.shared.hideLoader()
                self.dismissKeyboard()
            }
        }
    }
    @IBAction func btnSendAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtSend.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enteramount, comment: ""), font: AppFont.regular(20).value)
        } else if txtTo.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            if sendVia == "phone" {
                self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumberEmpty, comment: ""), font: AppFont.regular(20).value)
            } else {
                self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.empryWalletAddress, comment: ""), font: AppFont.regular(20).value)
            }
        } else {
            
            let popUpVc = BuyCardPopUpViewController()
            
            popUpVc.sendPhone = txtTo.text ?? ""
            popUpVc.sendAmount = txtSend.text ?? ""
            popUpVc.sendCurrency = lblType1.text ?? ""
            popUpVc.sendWallet = txtTo.text ?? ""
            popUpVc.isFrom = "sendCardWallet"
            popUpVc.toWalletAddress = self.toWalletAddress
            popUpVc.sendVia = self.sendVia
            popUpVc.feeValue = self.feeValue
            popUpVc.delegate = self
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            self.present(popUpVc, animated: true)

        }
        
    }
}
extension SendCardTokenDetailViewController : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String,isFromToken1: String?) {
        DispatchQueue.main.async {
            self.lblType1.text = tokenName
            self.ivCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
            let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
            self.lblBalance.text = "\(balance)"// \(tokenCurruncy)"
            self.tokenAddress = tokenArr?.address ?? ""
            let totalFee = (Double(tokenAmount) ?? 0.0) + (Double(self.feeValue) ?? 0.0)
            self.lblTotal.text = "\(totalFee) \(tokenCurruncy)"
            self.lblAllFund.text = "\(balance) \(self.lblType1.text ?? "")"
            self.allFund = "\(balance)"
            self.addressPattern = tokenArr?.pattern ?? ""
        }
    }
    
}
extension SendCardTokenDetailViewController : GotoDashBoardDelegate {
    func gotoPengingDashboard() {
            let pendingVC = PendingViewController()
            pendingVC.cardPrice = txtSend.text ?? ""
            pendingVC.cardCurrency = lblType1.text ?? ""
            if sendVia == "walletAddress" {
                pendingVC.phonenumber = txtTo.text ?? ""
            } else {
                pendingVC.phonenumber = txtTo.text ?? ""
            }
            pendingVC.isFrom = "sendCardWallet"
        pendingVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(pendingVC, animated: false)
    }
    
    func gotoDashBoard() {
        let topupSucesseVC = TopUpSuccessViewController()
        topupSucesseVC.cardPrice = txtSend.text ?? ""
        topupSucesseVC.cardCurrency = lblType1.text ?? ""
        if sendVia == "walletAddress" {
            topupSucesseVC.phonenumber = txtTo.text ?? ""
        } else {
            topupSucesseVC.phonenumber = txtTo.text ?? ""
        }
        
        topupSucesseVC.isFrom = "sendCardWallet"
        topupSucesseVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(topupSucesseVC, animated: false)
    }
}
