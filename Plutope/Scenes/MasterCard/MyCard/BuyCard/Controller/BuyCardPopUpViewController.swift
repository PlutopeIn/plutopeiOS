//
//  BuyCardPopUpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/05/24.
//

import UIKit

protocol GotoDashBoardDelegate : AnyObject {
    func gotoDashBoard()
    func gotoPengingDashboard()
}
protocol ShowCVVDataDelegate : AnyObject {
    func showOtpVC(isFrom:String?)
}
class BuyCardPopUpViewController: UIViewController {
    @IBOutlet weak var ivTime: UIImageView!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblRateTitle: UILabel!
    
    @IBOutlet weak var lblOprationTime: UILabel!
    
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lblRate: UILabel!
    lazy var cardPaymentViewModel: CardPaymentViewModel = {
        CardPaymentViewModel { _ ,message in
        }
    }()
    lazy var sendCardTokenViewModel: SendCardTokenViewModel = {
        SendCardTokenViewModel { _ ,_ in
        }
    }()
    lazy var topUpViewModel: TopUpCardViewwModel = {
        TopUpCardViewwModel { _ ,_ in
        }
    }()
    lazy var exchangeCardViewModel: ExchangeCardViewModel = {
        ExchangeCardViewModel { _ ,_ in
        }
    }()
    lazy var bankCardPayOutViewModel: BankCardPayOutViewModel = {
        BankCardPayOutViewModel { _ ,_ in
        }
    }()
    
    @IBOutlet weak var btnConfirm: GradientButton!
    weak var delegate : GotoDashBoardDelegate?
    weak var showOtpDelegate : ShowCVVDataDelegate?
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblOprationTimeTitle: UILabel!
    var isFrom = ""
    var cardType = ""
    var totalAmount = ""
    var totalCurrency = ""
    var fromAmount = ""
    var fromCurrency = ""
    var toCurrency = ""
    var toAmount = ""
    var address = ""
    var currency = ""
    var tokenRate = ""
    var tokenCurrency = ""
    var cardRequestId = Int()
    var sendPhone = ""
    var sendAmount = ""
    var sendCurrency = ""
    var sendWallet = ""
    var sendIsFrom = ""
    var sendVia = ""
    var feeValue = ""
    var toWalletAddress = ""
    var transactionAvailability : Bool?
    var isFromDashbord = ""
    var cardId = ""
    
    fileprivate func uiSetup() {
        lblTitle.font = AppFont.violetRegular(20).value
        lblMsg.font = AppFont.regular(13).value
        lblRate.font = AppFont.regular(13).value
        lblTime.font = AppFont.regular(13).value
        lblRateTitle.font = AppFont.regular(13).value
        lblOprationTime.font = AppFont.regular(13).value
        lblOprationTimeTitle.font = AppFont.regular(13).value
        btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        lblOprationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationtime, comment: "")
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionMsg, comment: "")
    }
    // swiftlint:disable function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardType =  UserDefaults.standard.value(forKey: cardTypes) as? String ?? ""
        uiSetup()
        
        if isFrom == "payment" {
             let number = self.totalAmount.components(separatedBy: " ").first
                print(number)  // Output: "8"
            let curruncy = self.totalAmount.components(separatedBy: " ").last
            print(curruncy)
            let payMessage =  LocalizationHelper.localizedMessageWithAmountAndCardType(
                key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paymentMessage, comment: ""),
                amount: Double(number ?? "") ?? 0.0, currency: curruncy ?? "",
                cardType: cardType
            )
            lblTitle.text =  payMessage
            lblTime.isHidden = true
            lblMsg.isHidden = true
            lblOprationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourAddress, comment: "")
            lblOprationTime.text = self.address
            view1.isHidden = true
            ivTime.isHidden = true
        } else if isFrom == "sendCardWallet" {
            if sendVia == "phone" {
                let phoneMessage = LocalizationHelper.localizedMessageWithAmountCurrencyAndPhone(
                    key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendviaCard, comment: ""),
                    amount: Double(sendAmount) ?? 0.0,
                    currency: sendCurrency,
                    phone: sendPhone
                )
            lblTitle.text = phoneMessage
            } else {
                let walletMessage = LocalizationHelper.localizedMessageWithAmountCurrencyAndPhone(
                    key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendviaCard, comment: ""),
                    amount: Double(sendAmount) ?? 0.0,
                    currency: sendCurrency,
                    phone: sendWallet.truncatedToFirstAndLastFour()
                )
            lblTitle.text = walletMessage
            }
            lblTime.isHidden = true
            lblMsg.isHidden = true
            lblOprationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationtime, comment: "")
            lblOprationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: "")
            view1.isHidden = true
            ivTime.isHidden = false
        } else if isFrom == "exchnageCrypto" {
            let exchangeMessage =  LocalizationHelper.localizedMessage(
                key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangeMsg, comment: ""),
                fromAmount: Double(self.fromAmount) ?? 0.0,
                fromCurrency: self.fromCurrency,
                toAmount: Double(self.toAmount) ?? 0.0,
                toCurrency: self.toCurrency
            )
            
            lblTitle.text = exchangeMessage
            lblTime.isHidden = true
            lblMsg.isHidden = false
            lblRateTitle.text = tokenCurrency
            lblRate.text = "\(tokenRate)"
            lblOprationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: "")
            
            view1.isHidden = false
            ivTime.isHidden = false
        } else if isFrom == "buyCrypto" {
            let buyMessage =  LocalizationHelper.localizedMessage(
                key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buyMsg, comment: ""),
                fromAmount: Double(self.fromAmount) ?? 0.0,
                fromCurrency: self.fromCurrency,
                toAmount: Double(self.toAmount) ?? 0.0,
                toCurrency: self.toCurrency
            )
            lblTitle.text = buyMessage
            lblTime.isHidden = true
            lblMsg.isHidden = false
            lblRateTitle.text = tokenCurrency
            lblRate.text = "\(tokenRate)"
            lblOprationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: "")
            view1.isHidden = false
            ivTime.isHidden = false
        } else  if isFrom == "topupVC" {
            let topupMessage =  LocalizationHelper.localizedMessage(
                key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.topupMsg, comment: ""),
                fromAmount: Double(self.fromAmount) ?? 0.0,
                fromCurrency: self.fromCurrency,
                toAmount: Double(self.toAmount) ?? 0.0,
                toCurrency: self.toCurrency
            )
            lblTitle.text = topupMessage
            lblTime.isHidden = true
            lblMsg.isHidden = false
            lblRateTitle.text = tokenCurrency
            lblRate.text = "\(tokenRate)"
            lblOprationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: "")
            view1.isHidden = false
            ivTime.isHidden = false
        } else if isFrom == "withdrawCrypto" {
            let withdrawMessage = LocalizationHelper.localizedMessage(
                key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.withdrawCryptoMsg, comment: ""),
                fromAmount: Double(self.fromAmount) ?? 0.0,
                fromCurrency: self.fromCurrency,
                toAmount: Double(self.toAmount) ?? 0.0,
                toCurrency: self.toCurrency
            )
            lblTitle.text = "\(withdrawMessage)"
            lblTime.isHidden = true
            lblMsg.isHidden = false
            lblRateTitle.text = tokenCurrency
            lblRate.text = "\(tokenRate)"
            lblOprationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.definedbybank, comment: "")
            view1.isHidden = false
            ivTime.isHidden = true
        }
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: false)
        }
        
    }
    

    fileprivate func sendCardWallet() {
        DGProgressView.shared.showLoader(to: view)
        if self.sendVia == "phone" {
            sendCardTokenViewModel.walletSendVerificationAPI(phone: sendPhone, amount: sendAmount, address: "", currency: sendCurrency, isFrom: "phone") { resStatus, resMessage, dataValue in
                if resStatus == 1 {
                    if dataValue?.possibleToExecute == true {
                        self.sendCardTokenViewModel.apiWalletSend(fee: self.feeValue, phone: self.sendPhone, amount: self.sendAmount, address: "", currency: self.sendCurrency, isFrom: "phone") { resStatus,resMessage,resValue in
                            if resStatus == 1 {
                                var sendConfirmation = resValue?["sendConfirmation"] as? Bool ?? false
                                            // Access the sendConfirmation value
                                print("sendConfirmation: \(sendConfirmation)")
                                
                                if sendConfirmation == true {
                                    self.dismiss(animated: false) {
                                        DGProgressView.shared.hideLoader()
                                        self.showToast(message: resMessage, font: AppFont.regular(15).value)
                                        self.delegate?.gotoPengingDashboard()
                                    }
                                } else {
                                    self.dismiss(animated: false) {
                                        DGProgressView.shared.hideLoader()
                                        self.showToast(message: resMessage, font: AppFont.regular(15).value)
                                        self.delegate?.gotoDashBoard()
                                    }
                                }
                            } else {
                                DGProgressView.shared.hideLoader()
                                self.showToast(message: resMessage, font: AppFont.regular(15).value)
                            }
                        }
                    } else {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendNotPossible, comment: ""), font: AppFont.regular(15).value)
                    }
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
                }
            }
            
        } else {
            sendCardTokenViewModel.walletSendVerificationAPI(phone:"", amount: sendAmount, address: self.toWalletAddress, currency: sendCurrency, isFrom: "walletAddress") { resStatus, resMessage, dataValue in
                if resStatus == 1 {
                    if dataValue?.possibleToExecute == true {
                        self.sendCardTokenViewModel.apiWalletSend(fee: self.feeValue, phone:"", amount: self.sendAmount, address: self.sendWallet, currency: self.sendCurrency, isFrom: "walletAddress") { resStatus,resMessage ,resValue in
                            if resStatus == 1 {
                                var sendConfirmation = resValue?["sendConfirmation"] as? Bool ?? false
                                            // Access the sendConfirmation value
                               // print("sendConfirmation: \(sendConfirmation)")
                                
                                if sendConfirmation == true {
                                    self.dismiss(animated: false) {
                                        DGProgressView.shared.hideLoader()
                                        self.showToast(message: resMessage, font: AppFont.regular(15).value)
                                        self.delegate?.gotoPengingDashboard()
                                    }
                                } else {
                                    self.dismiss(animated: false) {
                                        DGProgressView.shared.hideLoader()
                                        self.showToast(message: resMessage, font: AppFont.regular(15).value)
                                        self.delegate?.gotoDashBoard()
                                    }
                                }
//                                self.dismiss(animated: false) {
//                                    DGProgressView.shared.hideLoader()
//                                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
//                                    
//                                    
//                                    self.delegate?.gotoDashBoard()
//                                }
                                
                            } else {
                                DGProgressView.shared.hideLoader()
                                self.showToast(message: resMessage, font: AppFont.regular(15).value)
                            }
                        }
                    } else {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendNotPossible, comment: ""), font: AppFont.regular(15).value)
                    }
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
                }
            }
        }
    }
    // swiftlint:enable function_body_length
    @IBAction func btnConfirmAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if isFrom == "payment" {
            cardPaymentViewModel.apiPaymentOffer(currency: self.currency.lowercased(), id: "\(self.cardRequestId)") { status, msg, data in
                if status == 1 {
                    DGProgressView.shared.showLoader(to: self.view)
                        self.cardPaymentViewModel.apiPaymentOfferConfirm(id: "\(self.cardRequestId)") { resStatus, message, dataValue in
                            if resStatus == 1 {
                                self.dismiss(animated: false) {
                                    DGProgressView.shared.hideLoader()
                                    self.showToast(message: message, font: AppFont.regular(15).value)
                                    self.delegate?.gotoDashBoard()
                                }
                            } else {
                                DGProgressView.shared.hideLoader()
                                self.showToast(message: message, font: AppFont.regular(15).value)
                            }
                        }
                    
                } else {
                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            }
        } else if isFrom == "sendCardWallet" {
            sendCardWallet()
        } else if isFrom == "buyCrypto" {
            self.dismiss(animated: false, completion: {
                if self.isFromDashbord == "dashboard" {
                    self.showOtpDelegate?.showOtpVC(isFrom: "dashboard")
                } else {
                    self.showOtpDelegate?.showOtpVC(isFrom: "buy")
                }
            })
        } else if isFrom == "withdrawCrypto" {
            DGProgressView.shared.showLoader(to: self.view)
            bankCardPayOutViewModel.apiPayOutOfferCreate(amount: self.fromAmount, cardId: self.cardId, toCurrency: self.fromCurrency, fromCurrency: self.toCurrency) { resStatus, resMessage, resData in
                if resStatus == 1 {
                    let offerId = resData?["offerId"] as? Int ?? 0
                    self.bankCardPayOutViewModel.apipayOutExecuteOfferPayment(id: "\(offerId)") { resStatus, resMessage in
                        if resStatus == 1 {
                            self.dismiss(animated: false) {
                                DGProgressView.shared.hideLoader()
                                self.delegate?.gotoDashBoard()
                            }
                        } else {
                            DGProgressView.shared.hideLoader()
                            self.showToast(message: resMessage, font: AppFont.regular(15).value)
                        }
                    }
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
                }
            }
        }  else if isFrom == "exchnageCrypto" {
            DGProgressView.shared.showLoader(to: self.view)
            self.exchangeCardViewModel.apiExchangeOffer(amountTo: self.toAmount, amountFrom: self.fromAmount, currencyTo: self.toCurrency, currencyFrom: self.fromCurrency) { resStatus, dataValue, resMessage in
                if resStatus == 1 {
                    let offerId1 = dataValue?["offerId"] as? Int ?? 0
                    self.exchangeCardViewModel.getExchangeExecuteOffer(offerId: offerId1) { resStatus, resMessage in
                        if resStatus == 1 {
                            self.dismiss(animated: false) {
                                DGProgressView.shared.hideLoader()
                                self.delegate?.gotoDashBoard()
                            }
                        } else {
                            DGProgressView.shared.hideLoader()
                            self.showToast(message: resMessage, font: AppFont.regular(15).value)
                          }
                        }
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
                }
            }
        } else if isFrom == "topupVC" {
            DGProgressView.shared.showLoader(to: self.view)
            topUpViewModel.apiCreateCardPayloadOffer(cardId: "\(self.cardRequestId)", fromCurrency: self.fromCurrency, toCurrency: self.toCurrency, fromAmount: self.fromAmount) { resStatus ,resMsg ,dataValue in
                    if resStatus == 1 {
                        let offerId = (dataValue?.offerID ?? 0) 
                        self.topUpViewModel.apiPayloadOfferConfirm(cardId: "\(self.cardRequestId)", offerId: "\(offerId)") { resStatus, resMsg, dataValue in
                            if resStatus == 1 {
                                self.dismiss(animated: false) {
                                    DGProgressView.shared.hideLoader()
                                    self.showToast(message: "Sucsess", font: AppFont.regular(15).value)
                                    self.delegate?.gotoDashBoard()
                                }
                                
                            } else {
                                DGProgressView.shared.hideLoader()
                                self.showToast(message: resMsg, font: AppFont.regular(15).value)
                            }
                        }
                        
                    } else {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: resMsg, font: AppFont.regular(15).value)
                    }
            }
        } else {
            self.dismiss(animated: false) {
                print("Failer")
            }
        }
    }
}
