//
//  ShowOTPViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/05/24.
//

import UIKit
import SVPinView
protocol MasterCardInfoDetailsDelegate : AnyObject {
    func getMasterCardInfoDetails(cardNumber:String,cardCVV:String,cardExpiryDate:String?,cardHolderName:String?,isFrom:String)
    
    func gobackToHome(isFreeze:Bool)
}
protocol GotoBuyDashBoardDelegate : AnyObject {
    func gotoBuyDashBoard(response:String?)
}
class ShowOTPViewController: UIViewController {

    @IBOutlet weak var lblMSG: UILabel!
    @IBOutlet weak var otpViewTextField: SVPinView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var txtOtp: customTextField!
    @IBOutlet var txtOtp: [UITextField]!
    @IBOutlet weak var btnClose: UIImageView!
    @IBOutlet weak var btnSubmit: GradientButton!
    weak var delegate : MasterCardInfoDetailsDelegate?
    var payinDataArr: PayinCreateOfferList?
    var payinExecuteDataArr: PayinExecuteeOfferList?
    var arrCardList : Card?
    var cardNumber = ""
    var code = ""
    var pinNo = ""
    var publicKey = ""
    var privetKey = ""
    var isFromCardDetails = false
    var isFromCardFreeze = false
    var isFromCardUnFreeze = false
    var isFromBuyCrypto = false
    var isFrom = ""
    var isFromDashboard = ""
    
    //// buy crypto
    var fromAmount = ""
    var fromCurrency = ""
    var toCurrency = ""
    var toAmount = ""
    var address = ""
    var cvv = ""
    var cardId = ""
    var offerId = ""
    lazy var myCardDetailsViewModel: MyCardDetailsViewModel = {
        MyCardDetailsViewModel { _ ,_ in
        }
    }()
    lazy var bankCardPayInViewModel: BankCardPayInViewModel = {
        BankCardPayInViewModel { _ ,_ in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnClose.addTapGesture(target: self, action: #selector(closeScreen))
        // OTP filed setups
        otpViewTextField.style = .box
        otpViewTextField.font = AppFont.regular(13).value
        lblMSG.font = AppFont.regular(14).value
        if isFrom == "buyCrypto" {
            otpViewTextField.pinLength = 3
            lblMSG.isHidden = false
            lblMSG.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buyCardAlertMsg, comment: "")
            // txtOtp[2].isHidden = true
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cvvEnterMsg, comment: "")
        } else {
            lblMSG.isHidden = true
          //  txtOtp[2].isHidden = false
            otpViewTextField.pinLength = 4
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.smsSendMsg, comment: "")
           
        }
    }
   
    @objc func closeScreen() {
        HapticFeedback.generate(.light)
        if isFrom == "buyCrypto" {
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: false)
        } else {
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: false)
        }
    }
    @IBAction func btnSubmitAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        print(otpViewTextField.getPin())
        
        if otpViewTextField.getPin().count > 0 {
            if isFromCardDetails {
                self.getCardInfoDetails(otp: otpViewTextField.getPin())
            } else if isFromCardFreeze {
                self.getCardFreeze(otp: otpViewTextField.getPin())
            } else if isFromCardUnFreeze {
                self.getCardUnFreeze(otp: otpViewTextField.getPin())
            } else if isFromBuyCrypto {
                self.buyCard(otp: otpViewTextField.getPin())
            }
        } else {
            self.showSimpleAlert(Message: ToastMessages.otpEmpty)
        }
    }
    
    func getCardInfoDetails(otp:String) {
        DGProgressView.shared.showLoader(to: view)
        myCardDetailsViewModel.apiCardInformatonNew(cardId: "\(arrCardList?.id ?? 0)", code: otp, publicKey: encodePublicKey) { status,msg, data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.dismiss(animated: true) {
                    if self.isFrom == "cardExpiry" {
                        self.delegate?.getMasterCardInfoDetails(cardNumber:  "", cardCVV:data?.cvv ?? "" , cardExpiryDate:data?.expiry , cardHolderName:"", isFrom: "cardExpiry")
                    } else {
                        self.delegate?.getMasterCardInfoDetails(cardNumber: "", cardCVV:data?.cvv ?? "" , cardExpiryDate:data?.expiry , cardHolderName:"", isFrom: "pinNo")
                    }
                }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    func getCardFreeze(otp:String) {
        DGProgressView.shared.showLoader(to: view)
        myCardDetailsViewModel.apiCardFreezeNew(cardId: "\(arrCardList?.id ?? 0)", code: otp) { resStatus,resMessage,data  in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.dismiss(animated: true) {
                    self.delegate?.gobackToHome(isFreeze: true)
                }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: resMessage, font: AppFont.regular(15).value)
            }
        }
    }
    func getCardUnFreeze(otp:String) {
        DGProgressView.shared.showLoader(to: view)
        myCardDetailsViewModel.apiCardUnFreezeNew(cardId:"\(arrCardList?.id ?? 0)", code: otp) { resStatus ,resMessage ,data in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.dismiss(animated: false) {
                    self.delegate?.gobackToHome(isFreeze: false)
                }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: resMessage, font: AppFont.regular(15).value)
            }
        }
    }
    func buyCard(otp:String) {
        
        DGProgressView.shared.showLoader(to: view)
        bankCardPayInViewModel.apiPayinOfferCreate(amount: self.fromAmount, cardId: self.cardId, operation: "PAYIN", toCurrency: self.fromCurrency, fromCurrency: self.toCurrency, cardCVV: otpViewTextField.getPin()) { resStatus, resMessage, resData in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.offerId = "\(resData?.offerID ?? 0)"
                self.payinDataArr = resData
                
                self.bankCardPayInViewModel.apipayinExecuteOfferPayment(cardCVV: self.otpViewTextField.getPin(), id: "\(resData?.offerID ?? 0)") { resStatus, resMessage, dataValue in
                    
                    self.payinExecuteDataArr = dataValue
                    
                    if let status = self.extractTransactionStatus(from: self.payinExecuteDataArr?.transactionStatus ?? "") {
                            print(status) // Output: "declined"
                            
                            if status == "declined" {
                                DispatchQueue.main.async {
                                        self.dismiss(animated: true)
                                        self.navigationController?.popViewController(animated: false)
                                    
                                }
                            }
                        }
                    if self.payinExecuteDataArr?.transactionStatus == "Risk Blocked Transaction" || self.payinExecuteDataArr?.authLink == "" || self.payinExecuteDataArr?.authLink == nil {
                        
                    } else {
                    
    //                if self.payinDataArr?.authLink != "" || self.payinDataArr?.authLink != nil {
                        self.showWebView(for: self.payinExecuteDataArr?.authLink ?? "", onVC: self, title: "",successUrl: self.payinExecuteDataArr?.successURL,failerUrl: self.payinExecuteDataArr?.failURL)
                    }
                }

            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: resMessage, font: AppFont.regular(15).value)
            }
        }
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String,successUrl:String? = nil,failerUrl:String? = nil) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        webController.successUrl = successUrl ?? ""
        webController.failerUrl = failerUrl ?? ""
        webController.delegate = self
        webController.isFrom = "buyCrypto"
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: false)
    }
    func extractTransactionStatus(from message: String) -> String? {
        let parts = message.split(separator: ":")
        if parts.count > 1 { // Ensure there's at least one ":" separator
            let status = parts[1].split(separator: ".").first?.trimmingCharacters(in: .whitespaces)
            return status
        }
        return nil // Return nil if status is not found
    }
}

extension ShowOTPViewController : GotoBuyDashBoardDelegate {
    func gotoBuyDashBoard(response: String?) {
        if response == "" {
            DGProgressView.shared.showLoader(to: view)
            bankCardPayInViewModel.getpayinPayCallback(id: self.offerId) { status, msg,data in
                if status == 1 {
                    DGProgressView.shared.hideLoader()
                    if let status = data?.status {
                        // Use the status value as needed
                        if status == "SUCCESS" {
                            let topupSucesseVC = TopUpSuccessViewController()
                            topupSucesseVC.cardPrice = self.toAmount
                            topupSucesseVC.cardCurrency = self.fromCurrency
                            topupSucesseVC.cardNumber = self.address
                            topupSucesseVC.isFrom = "buyCryptoWallet"
                            topupSucesseVC.isFailer = false
                            topupSucesseVC.isFrom = self.isFromDashboard
                            topupSucesseVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(topupSucesseVC, animated: false)
                        } else {
                            DGProgressView.shared.hideLoader()
                            self.showToast(message: "FAILURE", font: AppFont.regular(15).value)
                            let failerVC = FailureViewController()
                            failerVC.cardPrice = self.toAmount
                            failerVC.cardCurrency = self.fromCurrency
                            failerVC.cardNumber = self.address
                            failerVC.isFrom = "buyCryptoWallet"
                            failerVC.isFailer = true
                            failerVC.isFrom = self.isFromDashboard
                            failerVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(failerVC, animated: false)
                        }
                    }
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            }
        }
    }
    
    func gotoDashBoard() {
        
    }
}
