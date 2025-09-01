//
//  BuyCardDashboardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 14/06/24.
//

import UIKit

class BuyCardDashboardViewController: UIViewController {
   
    @IBOutlet weak var lblGetError: UILabel!
    @IBOutlet weak var lblPayError: UILabel!
    @IBOutlet weak var viewMax: UIView!
    @IBOutlet weak var viewMin: UIView!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMaxTitle: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMinTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewHaveCard: UIView!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var viewAddCard: UIView!
    @IBOutlet weak var btnContinue: GradientButton!
    
    /// Pay Coin Outlets
    @IBOutlet weak var vwPayIcon: UIView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var lblPayCoinBalance: UILabel!
    @IBOutlet weak var txtPay: LoadingTextField!
    @IBOutlet weak var lblType1: DesignableLabel!
    
    /// Get Coin Outlets
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var lblGetCoinBalance: UILabel!
    @IBOutlet weak var txtGet: LoadingTextField!
    @IBOutlet weak var lblType2: DesignableLabel!
    /// other
    @IBOutlet weak var lblRateTitle: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblOperationTimeTitle: UILabel!
    @IBOutlet weak var lblOperationTime: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblShippingTitle: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblYouPay: UILabel!
    
    @IBOutlet weak var btnAddBankCard: UIButton!
    @IBOutlet weak var lblYouGet: UILabel!
    //   @IBOutlet weak var txtCurrency: LoadingTextField!
    
    var arrCardList : [PayInCard] = []
    var arrWallet : Wallet?
    var arrWalletList : [Wallet] = []
    var arrCurrencyList : [String] = []
    var priceDataValueArr : [PriceDataValues] = []
    var priceDataValueSring : String = ""
    var cardRequestId : Int?
    var arrPayInOtherData : PayInOtherDataList?
    var partnerFee = ""
    var crypteriumGas = ""
    var additionalFee = ""
    var transactionFee  = ""
    var insuranceFee = ""
    var totalFees = 0.0
    var toCurrency = ""
    var minValue = ""
    var maxValue = ""
    var cardType = ""
    var cardId = ""
    var fromCurrency = ""
    var cardNumber = ""
    var isChecked: Bool = false
    var isFrom = ""
    var cardName = ""
    var selectedColor = UIColor()
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,_ in
        }
    }()
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var bankCardPayInViewModel: BankCardPayInViewModel = {
        BankCardPayInViewModel { _ ,_ in
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWalletTokens()
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buycrypto, comment: ""), btnBackHidden: false)
            self.btnContinue.alpha = 0.5
            self.btnContinue.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("RefreshBuyDashBoard"), object: nil)
        
        txtPay.delegate = self
        viewMin.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtPay.text = self.minValue
            self.textFieldDidChangeSelection(self.txtPay)
        }
        viewMax.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtPay.text = self.maxValue
            self.textFieldDidChangeSelection(self.txtPay)
        }
        lblYouPay.font = AppFont.regular(16).value
        lblType2.font = AppFont.regular(16).value
        lblPayError.font = AppFont.regular(9).value
        lblGetError.font = AppFont.regular(9).value
        txtGet.font = AppFont.regular(16).value
        txtPay.font = AppFont.regular(16).value
        lblYouGet.font = AppFont.regular(18.16).value
        lblGetCoinBalance.font = AppFont.regular(16).value
        btnAddBankCard.titleLabel?.font = AppFont.regular(14).value
        lblMinTitle.font = AppFont.violetRegular(14).value
        lblMaxTitle.font = AppFont.violetRegular(14).value
        lblRateTitle.font = AppFont.violetRegular(14).value
        lblRate.font = AppFont.violetRegular(14).value
        lblOperationTimeTitle.font = AppFont.violetRegular(14).value
        lblOperationTime.font = AppFont.violetRegular(14).value
        lblTotalTitle.font = AppFont.violetRegular(14).value
        lblTotal.font = AppFont.violetRegular(14).value
        lblShippingTitle.font = AppFont.violetRegular(14).value
        lblShipping.font = AppFont.violetRegular(14).value
        lblShipping.font = AppFont.violetRegular(14).value
        lblYouPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay, comment: "")
        lblYouGet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youget, comment: "")
        lblOperationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationtime, comment: "")
        lblOperationTime.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: ""))"
        lblTotalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalFees, comment: "")

    }
    
    @IBAction func btnAddCardAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let addCardVC = AddMasterCardViewController()
        addCardVC.isFromCard = "payin"
        addCardVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }
    @objc func refreshData() {
        self.getWalletTokens()
            print("Refresh data called")
      }
    deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshBuyDashBoard"), object: nil)
        }
    func getWalletTokens() {
        myTokenViewModel.getTokenAPINew { status, data ,fiat ,msg in
            if status == 1 {
                self.arrWalletList = data ?? []
                DispatchQueue.main.async {
                    guard let arrWallet = self.arrWallet else { return }
                    // Find the wallet with the same name in arrPayWalletList
                    if let matchingWallet = self.arrWalletList.first(where: { $0.currency == arrWallet.currency }) {
                        // Update the UI elements with the matching wallet data
                        
                        self.lblType2.text = matchingWallet.currency
                        self.ivGetCoin.sd_setImage(with: URL(string: "\(matchingWallet.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                        let balance = WalletData.shared.formatDecimalString(matchingWallet.balanceString ?? "", decimalPlaces: 6)
                        self.lblGetCoinBalance.text = balance
                    }
//                    PAYIN_CARD
                    self.getCardPayInData()
                }
            } else {
            }
            
        }
    }
    fileprivate func feesCalculation(dataValue: PayInOtherDataList?) {
        if let partnerFeeFee = dataValue?.fees?.partnerFee {
            let partnerFeeValue: Double = {
                switch partnerFeeFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.partnerFee = "\(partnerFeeValue)"
        } else {
            self.partnerFee = "0"
        }
        if let crypteriumGas = dataValue?.fees?.crypteriumGas {
            let crypteriumGasFeeValue: Double = {
                switch crypteriumGas {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.crypteriumGas = "\(crypteriumGasFeeValue)"
        } else {
            self.crypteriumGas = "0"
        }
        if let transactionFee = dataValue?.fees?.transactionFee {
            let transactionFeeValue: Double = {
                switch transactionFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.transactionFee = "\(transactionFeeValue)"
        } else {
            self.transactionFee = "0"
        }
        if let additionalFee = dataValue?.fees?.additionalFee {
            let additionalFeeValue: Double = {
                switch additionalFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.additionalFee = "\(additionalFeeValue)"
        } else {
            self.additionalFee = "0"
        }
        if let insuranceFee = dataValue?.fees?.insuranceFee {
            let insuranceFeeFeeValue: Double = {
                switch insuranceFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.insuranceFee = "\(insuranceFeeFeeValue)"
        } else {
            self.insuranceFee = "0"
        }
    }
    func updateFees(dataValue: PayInOtherDataList?) {
         DispatchQueue.main.async {
             var fromCurrency = ""
             if let pair = dataValue?.pairs?.first(where: { $0.currencyTo == self.lblType2.text }) {
                 if let pairRates = pair.rate {
                     let pairRatesValue: Double = {
                         switch pairRates {
                         case .int(let value):
                             return Double(value)
                         case .double(let value):
                             return value
                         }
                     }()
                     let rate = WalletData.shared.formatDecimalString("\(pairRatesValue)", decimalPlaces: 6)
                     self.lblRate.text = "\(rate) \(pair.currencyFrom ?? "")"
                 } else {
                     self.lblRate.text = "0"
                 }
                 self.lblRateTitle.text = "\(pair.currencyTo ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
                 self.toCurrency = pair.currencyFrom ?? ""
                 fromCurrency = pair.currencyTo ?? ""
                 self.fromCurrency = pair.currencyTo ?? ""
                
                 self.lblMaxTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: "")
                 self.lblMinTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.min, comment: "")
                
                 if let defaultMaxAmountFrom = dataValue?.defaultMaxAmountFrom {
                     let defaultMaxAmountFromValue: Double = {
                         switch defaultMaxAmountFrom {
                         case .int(let value):
                             return Double(value)
                         case .double(let value):
                             return value
                         }
                     }()
                     self.lblMax.text = "\(defaultMaxAmountFromValue)"
                     self.maxValue = "\(defaultMaxAmountFromValue)"
                 } else {
                     self.lblMax.text =  "0"
                     self.maxValue = ""
                 }
                 if let defaultMinAmountFrom = dataValue?.defaultMinAmountFrom {
                     let defaultMinAmountFromValue: Double = {
                         switch defaultMinAmountFrom {
                         case .int(let value):
                             return Double(value)
                         case .double(let value):
                             return value
                         }
                     }()
                     self.lblMin.text = "\(defaultMinAmountFromValue)"
                     self.minValue = "\(defaultMinAmountFromValue)"
                 } else {
                     self.lblMin.text =  "0"
                     self.minValue = ""
                 }
             } else {
                 self.lblRateTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
                 self.lblRate.text = "0"
                 self.lblTotal.text = ""
             }
             self.feesCalculation(dataValue: dataValue)
           
             if let partnerFeeValue = Double(self.partnerFee),
                let crypteriumGasValue = Double(self.crypteriumGas),
                let additionalFeeValue = Double(self.additionalFee),
                let transactionFeeValue = Double(self.transactionFee),
                let insuranceFeeValue = Double(self.insuranceFee) {
                 
                 // Calculate the total fee
                 self.totalFees = partnerFeeValue + crypteriumGasValue + additionalFeeValue + transactionFeeValue + insuranceFeeValue
                // print("Total Fee: \(self.totalFees )")
                 let total = (Double(self.txtGet.text ?? "0.0") ?? 0.0) + self.totalFees
                 _ = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 3)
                 self.lblTotal.text = "\("0.0") \(self.toCurrency)"
                 
             } else {
                // print("One or more values are invalid")
             }
             self.lblShipping.text = "0"
             
             let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
             let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: "\(fromCurrency)")
             self.btnContinue.setTitle(message, for: .normal)
         }
    }
    func getCardPayInData() {
        DGProgressView.shared.showLoader(to: view)
        bankCardPayInViewModel.getPayInOtherDataAPI(cardRequestId: "\(self.cardRequestId ?? 0)") { resStatus, msg,dataValue in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.arrPayInOtherData = dataValue
                self.arrCardList = dataValue?.cards ?? []
                if !self.arrCardList.isEmpty {

                    self.viewHaveCard.isHidden = false
                    self.viewAddCard.isHidden = true
                    self.cardNumber = self.arrCardList.first?.maskedPan ?? ""
                    self.lblType1.text = self.showLastFourDigits(of: self.arrCardList.first?.maskedPan ?? "")
                    self.cardName = self.lblType1.text ?? ""
                    self.cardId = "\(self.arrCardList.first?.cardID ?? 0)"
                    if self.arrCardList.first?.cardType == "VISA" {
                        self.ivPayCoin.image = UIImage(named: "visa")
                        self.selectedColor = UIColor.c2B5AF3
                        self.vwPayIcon.backgroundColor = self.selectedColor
                    } else {
                        self.ivPayCoin.image = UIImage(named: "ic_masterCard")
                        self.selectedColor = UIColor.clear
                        self.vwPayIcon.backgroundColor = self.selectedColor
                    }
                } else {
                    self.btnContinue.alpha = 0.5
                    self.btnContinue.isEnabled = false
                    self.viewHaveCard.isHidden = true
                    self.viewAddCard.isHidden = false
                }
                self.updateFees(dataValue: dataValue)
              
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    
    @IBAction func btnSelectPayAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPay.text = ""
        txtGet.text = ""
        lblPayError.text = ""
        lblGetError.text = ""
        let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
        let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: "")
        self.btnContinue.setTitle(message, for: .normal)
        let presentcardListVC = MasterCardListViewController()
        presentcardListVC.modalTransitionStyle = .crossDissolve
        presentcardListVC.modalPresentationStyle = .overFullScreen
        presentcardListVC.cardDelegate = self
        presentcardListVC.isFrom = "buyCrypto"
        presentcardListVC.cardName = self.cardName
        self.present(presentcardListVC, animated: true, completion: nil)
    }
    @IBAction func btnSelectGetAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPay.text = ""
        txtGet.text = ""
        lblPayError.text = ""
        lblGetError.text = ""
        let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
        let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: ")")
        self.btnContinue.setTitle(message, for: .normal)
        let tokenListVC = MyTokenViewController()
        let filteredData = self.arrWalletList.filter { $0.allowOperations?.contains("PAYIN_CARD") ?? false }
        self.arrWalletList = filteredData
        tokenListVC.arrWalletList = self.arrWalletList
        tokenListVC.arrWalletList = filteredData
        tokenListVC.isFrom = "buyCrypto"
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if (txtPay.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.payAmountRequiredMsg, comment: ""), font: AppFont.regular(15).value)
        } else if (txtGet.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleaseEnterGetAmount, comment: ""), font: AppFont.regular(15).value)
        } else if viewAddCard.isHidden == false {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleaseAddCard, comment: ""), font: AppFont.regular(15).value)
        } else {
            let popUpVc = BuyCardPopUpViewController()
            let totalAmountValue =  WalletData.shared.formatDecimalString(self.lblTotal.text ?? "", decimalPlaces: 6)
            let fromAmountValue =  WalletData.shared.formatDecimalString(self.txtPay.text ?? "", decimalPlaces: 6)
            let toAmountValue =  WalletData.shared.formatDecimalString(self.txtGet.text ?? "", decimalPlaces: 6)
            popUpVc.totalAmount = totalAmountValue
            popUpVc.fromAmount = fromAmountValue
            popUpVc.cardRequestId = self.cardRequestId ?? 0
            popUpVc.isFrom = "buyCrypto"
            popUpVc.toCurrency = self.toCurrency
            popUpVc.fromCurrency = self.fromCurrency
            popUpVc.toAmount = toAmountValue
            popUpVc.tokenRate = lblRate.text ?? ""
            popUpVc.tokenCurrency = lblRateTitle.text ?? ""
            popUpVc.address = self.cardNumber
            popUpVc.delegate = self
            popUpVc.showOtpDelegate = self
            popUpVc.isFromDashbord = self.isFrom
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            self.present(popUpVc, animated: false)
        }
    }
}
extension BuyCardDashboardViewController : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String,isFromToken1: String?) {
        DispatchQueue.main.async {
            self.getCardPayInData()
            self.lblType2.text = tokenName
            self.ivGetCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
            let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
           
            self.lblGetCoinBalance.text = "\(balance)"// \(tokenCurruncy)"
        }
    }
    
}
extension BuyCardDashboardViewController : SelectMasterCardDelegate {
    func selectedCard(cardNumber: String, cardType: String, tokenimage: String?, cardId: String?, cardFullNo: String, cardBackground: UIColor) {
        DispatchQueue.main.async {
            self.lblType1.text = cardNumber
            self.cardName = cardNumber
            self.ivPayCoin.image = UIImage(named: tokenimage ?? "")
            self.cardId = cardId ?? ""
            self.cardNumber = cardFullNo
            self.selectedColor = cardBackground
        }
    }
    
    func addNewCard() {
        let addCardVC = AddMasterCardViewController()
        addCardVC.isFrom = "addMasterCard"
        addCardVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCardVC, animated: false)
    }
}
extension BuyCardDashboardViewController : GotoDashBoardDelegate {
    func gotoPengingDashboard() {
        
    }
    
    func gotoDashBoard() {
        let topupSucesseVC = TopUpSuccessViewController()
        topupSucesseVC.cardPrice = self.txtGet.text ?? ""
        topupSucesseVC.cardCurrency = self.fromCurrency
        topupSucesseVC.cardNumber = self.cardNumber
        self.navigationController?.pushViewController(topupSucesseVC, animated: false)
    }
}
extension BuyCardDashboardViewController : ShowCVVDataDelegate {
    func showOtpVC(isFrom: String?) {
        let popUpVc = ShowOTPViewController()
        let fromAmountValue =  WalletData.shared.formatDecimalString(self.txtPay.text ?? "", decimalPlaces: 6)
        let toAmountValue =  WalletData.shared.formatDecimalString(self.txtGet.text ?? "", decimalPlaces: 6)
        popUpVc.fromAmount = fromAmountValue
        popUpVc.isFrom = "buyCrypto"
        popUpVc.toCurrency = self.toCurrency
        popUpVc.fromCurrency = self.fromCurrency
        popUpVc.toAmount = toAmountValue
        popUpVc.address = self.arrCardList.first?.maskedPan ?? ""
        popUpVc.isFromDashboard = isFrom ?? ""
        popUpVc.cardId = self.cardId
        popUpVc.isFromBuyCrypto = true
        
        self.navigationController?.pushViewController(popUpVc, animated: false)
    }
}
