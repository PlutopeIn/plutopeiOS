//
//  WithdrowViewController.swift
//  Plutope
//
//  Created by sonoma on 02/07/24.
//

import UIKit
// swiftlint:disable type_body_length
class WithdrowViewController: UIViewController {
    
    @IBOutlet weak var viewMax: UIView!
   
    @IBOutlet weak var viewMin: UIView!
    @IBOutlet weak var ivCardCompany: UIImageView!
    
    @IBOutlet weak var viewHaveCard: UIView!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var viewAddCard: UIView!
    
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMinTitle: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMaxTitle: UILabel!
    @IBOutlet weak var lblPayError: UILabel!
    @IBOutlet weak var lblGetError: UILabel!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var headerView: UIView!
    /// Pay Coin Outlets
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var lblPayCoinBalance: UILabel!
    @IBOutlet weak var txtPay: LoadingTextField!
    @IBOutlet weak var lblType1: DesignableLabel!
    
    /// Get Coin Outlets
    @IBOutlet weak var vwGetIcon: UIView!
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var lblGetCoinBalance: UILabel!
    @IBOutlet weak var txtGet: LoadingTextField!
    @IBOutlet weak var clvPrice: UICollectionView!
    @IBOutlet weak var lblType2: DesignableLabel!
    /// ratings
    @IBOutlet weak var lblRateTitle: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblOperationTimeTitle: UILabel!
    @IBOutlet weak var lblOperationTime: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblShippingTitle: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblAllTitle: UILabel!
    //    var collectionListArray = ["50","100","300","500","1000"]
    
    @IBOutlet weak var lblYouGet: UILabel!
    @IBOutlet weak var lblYouPay: UILabel!
    @IBOutlet weak var viewAll: UIView!
   // var arrCardList : [PayInCard] = []
    var arrCardList : [PayOutCard] = []
    var arrWallet : Wallet?
    var arrWalletList : [Wallet] = []
    var arrCurrencyList : [String] = []
    var priceDataValueArr : [PriceDataValues] = []
    var priceDataValueSring : String = ""
    var cardRequestId : Int?
    var arrPayInOtherData : PayInOtherDataList?
    var arrPayOutOtherData : PayOutOtherDataList?
    var partnerFee = ""
    var crypteriumGas = ""
    var additionalFee = ""
    var transactionFee  = ""
    var insuranceFee = ""
    var totalFees = 0.0
    var toCurrency = ""
    var minValue = ""
    var maxValue = ""
    var allValue = ""
    var cardType = ""
    var cardId = ""
    var fromCurrency = ""
    var cardNumber = ""
    var isChecked: Bool = false
    var isFrom = ""
    var cardName = ""
    var selectedColor = UIColor()
    var supportedPayWalletTokenList: [Wallet] = []
    var arrWalletPairs : [PayOutPair] = []
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
    lazy var bankCardPayOutViewModel: BankCardPayOutViewModel = {
        BankCardPayOutViewModel { _ ,_ in
        }
    }()
    
    fileprivate func uiSetUp() {
        lblType1.font = AppFont.violetRegular(16).value
        lblMinTitle.font = AppFont.violetRegular(12.03).value
        lblMin.font = AppFont.violetRegular(15).value
        lblAll.font = AppFont.violetRegular(15).value
        lblMax.font = AppFont.violetRegular(15).value
        lblOperationTimeTitle.font = AppFont.violetRegular(15).value
        lblTotalTitle.font = AppFont.violetRegular(15).value
        lblShippingTitle.font = AppFont.violetRegular(15).value
        lblShipping.font = AppFont.violetRegular(15).value
        lblTotal.font = AppFont.violetRegular(15).value
        lblAllTitle.font = AppFont.violetRegular(12.03).value
        lblMaxTitle.font = AppFont.violetRegular(12.03).value
        lblYouGet.font = AppFont.regular(18.16).value
        lblYouPay.font = AppFont.regular(18.16).value
        lblPayCoinBalance.font = AppFont.regular(18.16).value
        lblPayError.font = AppFont.regular(9).value
        lblGetError.font = AppFont.regular(9).value
        btnContinue.titleLabel?.font = AppFont.violetRegular(17).value
        txtGet.placeHolderColor = UIColor.secondaryLabel
        txtPay.placeHolderColor = UIColor.secondaryLabel
        lblYouGet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youget, comment: "")
        lblYouPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay, comment: "")
        lblAllTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.all, comment: "")
        lblMinTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.min, comment: "")
        lblMaxTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: "")
        lblShippingTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.shipping, comment: "")
        lblTotalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalFees, comment: "")
        lblOperationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationtime, comment: "")
        btnAddCard.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.Addbankcard, comment: ""), for: .normal)
        lblOperationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.definedbybank, comment: "")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPay.delegate = self
        
        self.getWalletTokens()
        
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.withdraw, comment: ""))
        self.btnContinue.alpha = 0.5
        self.btnContinue.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("RefreshWithdrawDashBoard"), object: nil)
               
        uiSetUp()
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
        viewAll.isUserInteractionEnabled = false
        viewAll.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtPay.text = self.allValue
            self.textFieldDidChangeSelection(self.txtPay)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtGet.textAlignment = .left
            txtPay.textAlignment = .left
            
        } else {
            txtGet.textAlignment = .right
            txtPay.textAlignment = .right
        }
    }
    @IBAction func btnAddCardAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let addCardVC = AddMasterCardViewController()
        addCardVC.isFromCard = "payout"
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }
    
    @IBAction func btnSelectGetAction(_ sender: Any) {
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
        presentcardListVC.isFrom = "withdrawCrypto"
        presentcardListVC.cardName = self.cardName
        presentcardListVC.cardDelegate = self
        self.present(presentcardListVC, animated: true, completion: nil)
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
        let tokenListVC = MyTokenViewController()
        tokenListVC.arrWalletList = self.arrWalletList
        tokenListVC.isFrom = "withdrawCrypto"
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
      
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if (txtPay.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.payAmountRequiredMsg, comment: ""), font: AppFont.regular(15).value)
        } else if (txtGet.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleaseEnterGetAmount, comment: ""), font: AppFont.regular(15).value)
        } else {
            let popUpVc = BuyCardPopUpViewController()
            let fromAmountValue =  WalletData.shared.formatDecimalString(self.txtPay.text ?? "", decimalPlaces: 6)
            let toAmountValue =  WalletData.shared.formatDecimalString(self.txtGet.text ?? "", decimalPlaces: 6)
            popUpVc.fromAmount = self.txtPay.text ?? ""
            popUpVc.cardRequestId = self.cardRequestId ?? 0
            popUpVc.isFrom = "withdrawCrypto"
            popUpVc.toCurrency = self.toCurrency
            popUpVc.fromCurrency = self.fromCurrency
            popUpVc.toAmount = toAmountValue
            popUpVc.tokenRate = lblRate.text ?? ""
            popUpVc.tokenCurrency = lblRateTitle.text ?? ""
            popUpVc.address = self.cardNumber
            popUpVc.cardId = self.cardId
            popUpVc.delegate = self
            popUpVc.showOtpDelegate = self
            popUpVc.isFromDashbord = self.isFrom
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            self.present(popUpVc, animated: false)
        }
    }
    
    @objc func refreshData() {
        self.getWalletTokens()
        print("Refresh data called")
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshWithdrawDashBoard"), object: nil)
    }
    func getWalletTokens() {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.getTokenAPINew { status, data ,fiat,msg  in
            if status == 1 {
                let filteredData = data?.filter { $0.allowOperations?.contains("PAYOUT_CRYPTO") ?? false }
                self.arrWalletList = filteredData ?? []
                
                DispatchQueue.main.async {
                    self.getCardPayOutData()
                }
            } else {
                print(msg)
            }
            
        }
    }
    
    fileprivate func feesCalculation(dataValue: PayOutOtherDataList?) {
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
        if let insuranceFee = dataValue?.fees?.fixFee {
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
    func updateFees(dataValue: PayOutOtherDataList?) {
        DispatchQueue.main.async {
            var fromCurrency = ""
            if let pair = dataValue?.pairs?.first(where: { $0.currencyFrom == self.lblType1.text }) {
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
                    self.lblRate.text = "\(rate) \(pair.currencyTo ?? "")"
                } else {
                    self.lblRate.text = "0"
                }
                self.lblRateTitle.text = "\(pair.currencyFrom ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
                self.toCurrency = pair.currencyFrom ?? ""
                fromCurrency = pair.currencyTo ?? ""
                self.fromCurrency = pair.currencyTo ?? ""
                self.lblMaxTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: "")
                self.lblMinTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.min, comment: "")
                self.lblAllTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.all, comment: "")
            } else {
                self.lblRateTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: "")
                self.lblRate.text = "0"
                self.lblTotal.text = ""
            }
            if let pairLimit = dataValue?.cards?.compactMap({ $0.pairsLimits }).flatMap({ $0 }).first(where: { $0.currencyFrom == self.lblType1.text }) {
           
                if let defaultMaxAmountFrom = pairLimit.maxAmountFrom {
                    let defaultMaxAmountFromValue: Double = {
                        switch defaultMaxAmountFrom {
                        case .int(let value):
                            return Double(value)
                        case .double(let value):
                            return value
                        }
                    }()
                    let max = WalletData.shared.formatDecimalString("\(defaultMaxAmountFromValue)", decimalPlaces: 6)
                    self.lblMax.text = "\(max)"
                    self.maxValue = "\(max)"
                } else {
                    self.lblMax.text =  "0"
                    self.maxValue = ""
                }
                if let defaultMinAmountFrom = pairLimit.minAmountFrom {
                    let defaultMinAmountFromValue: Double = {
                        switch defaultMinAmountFrom {
                        case .int(let value):
                            return Double(value)
                        case .double(let value):
                            return value
                        }
                    }()
                    let min = WalletData.shared.formatDecimalString("\(defaultMinAmountFromValue)", decimalPlaces: 6)
                    self.lblMin.text = "\(min)"
                    self.minValue = "\(min)"
                } else {
                    self.lblMin.text =  "0"
                    self.minValue = ""
                }
                let all = WalletData.shared.formatDecimalString("\(self.lblPayCoinBalance.text ?? "")", decimalPlaces: 6)
                self.lblAll.text = "\(all)"
                self.allValue = "\(all)"
            } else {
               
            }

            self.feesCalculation(dataValue: dataValue)
            
            if let partnerFeeValue = Double(self.partnerFee),
               let crypteriumGasValue = Double(self.crypteriumGas),
               let additionalFeeValue = Double(self.additionalFee),
               let transactionFeeValue = Double(self.transactionFee),
               let insuranceFeeValue = Double(self.insuranceFee) {
                
                // Calculate the total fee
                self.totalFees = partnerFeeValue + crypteriumGasValue + additionalFeeValue + transactionFeeValue + insuranceFeeValue
                let total = (Double(self.txtGet.text ?? "0.0") ?? 0.0) + self.totalFees
                _ = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 3)
                self.lblTotal.text = "\("0.0") \(self.toCurrency)"
                
            } else {
                print("One or more values are invalid")
            }
            self.lblShipping.text = "0"
            let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
            let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: "\(fromCurrency)")
            self.btnContinue.setTitle(message, for: .normal)

        }
    }
    
    func getCardPayOutData() {
//        DGProgressView.shared.showLoader(to: view)
        bankCardPayOutViewModel.getPayOutOtherDataLive(cardRequestId: "\(self.cardRequestId ?? 0)") { resStatus, dataValue, msg in
         if resStatus == 1 {
             
             self.arrPayOutOtherData = dataValue
             self.arrCardList = dataValue?.cards ?? []
             self.arrWalletPairs = dataValue?.pairs ?? []
             if !self.arrCardList.isEmpty {
                 self.btnContinue.alpha = 1
                 self.btnContinue.isEnabled = true
                 self.viewHaveCard.isHidden = false
                 self.viewAddCard.isHidden = true
                 self.cardNumber = self.arrCardList.first?.maskedPan ?? ""
                 self.lblType2.text = self.showLastFourDigits(of: self.arrCardList.first?.maskedPan ?? "")
                 self.cardName = self.lblType2.text ?? ""
                 self.cardId = "\(self.arrCardList.first?.cardID ?? 0)"
                 self.ivGetCoin.image = UIImage(named: "visa")
                 self.selectedColor = UIColor.c2B5AF3
                 self.vwGetIcon.backgroundColor = self.selectedColor
                 
                 self.supportedPayWalletTokenList.removeAll()
                 let withdrawTokens = self.arrWalletList.filter { token in
                     token.allowOperations?.contains("PAYOUT_CRYPTO") == true
                 }
                 for token in withdrawTokens {
                     // Filter pairs where currencyFrom matches the selected wallet currency
                     let matchingPairs = self.arrWalletPairs.filter { pair in
                         pair.currencyFrom == token.currency
                     }
                     // Update properties of the token based on matching pairs
                     for (index, pair) in matchingPairs.enumerated() {
                         var modifiedToken = token // Make a mutable copy of the token
                         
                         if pair.currencyFrom == modifiedToken.currency {
                             if index == 0 {
                                // modifiedToken.fiat?.amount = pair.rate
                             }
                             modifiedToken.currency = pair.currencyFrom
                             // Add additional properties if necessary
                             self.supportedPayWalletTokenList.append(modifiedToken)
                             
                         }
                     }
                 }
                 self.arrWalletList = self.supportedPayWalletTokenList
                 DispatchQueue.main.async {
                     // Check if arrWallet exists and is part of arrWalletList
                     if let arrWallet = self.arrWallet, self.arrWalletList.contains(where: { $0.isEqualTo(arrWallet) }) {
                         // Use arrWallet data if it exists in arrWalletList
                         self.lblType1.text = arrWallet.currency
                         self.ivPayCoin.sd_setImage(with: URL(string: "\(arrWallet.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                         
                         if let balanceString = arrWallet.balanceString {
                             let balance = WalletData.shared.formatDecimalString(balanceString, decimalPlaces: 6)
                             self.lblPayCoinBalance.text = balance
                         }
                     } else {
                         // Otherwise, use the first element from arrWalletList
                         self.lblType1.text = self.arrWalletList.first?.currency
                         self.ivPayCoin.sd_setImage(with: URL(string: "\(self.arrWalletList.first?.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                         
                         if let balanceString = self.arrWalletList.first?.balanceString {
                             let balance = WalletData.shared.formatDecimalString(balanceString, decimalPlaces: 6)
                             self.lblPayCoinBalance.text = balance
                         }
                     }
                     DGProgressView.shared.hideLoader()
                 }

             } else {
                 self.btnContinue.alpha = 0.5
                 self.btnContinue.isEnabled = false
                 self.viewHaveCard.isHidden = true
                 self.viewAddCard.isHidden = false
                 DGProgressView.shared.hideLoader()
             }
             
             self.updateFees(dataValue: dataValue)
             
         } else {
             DGProgressView.shared.hideLoader()
             self.showToast(message: msg, font: AppFont.regular(15).value)
         }

     }
     
    }
}
extension WithdrowViewController : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String,isFromToken1: String?) {
        DispatchQueue.main.async {
//            self.getCardPayOutData()
            self.lblType1.text = tokenName
            self.ivPayCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
            let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
            
            self.lblPayCoinBalance.text = "\(balance)"// \(tokenCurruncy)"
        }
    }
    
}
extension WithdrowViewController : SelectMasterCardDelegate {
    func selectedCard(cardNumber: String, cardType: String, tokenimage: String?, cardId: String?, cardFullNo: String, cardBackground: UIColor) {
        DispatchQueue.main.async {
            self.lblType2.text = cardNumber
            self.cardName = cardNumber
            self.ivGetCoin.image = UIImage(named: tokenimage ?? "")
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
extension WithdrowViewController : GotoDashBoardDelegate {
    func gotoPengingDashboard() {
        
    }
    
    func gotoDashBoard() {
                let topupSucesseVC = TopUpSuccessViewController()
                topupSucesseVC.cardPrice = self.txtGet.text ?? ""
                topupSucesseVC.cardCurrency = self.fromCurrency
                topupSucesseVC.cardNumber = self.cardNumber
                 topupSucesseVC.isFrom = "withdrawCrypto"
        
                self.navigationController?.pushViewController(topupSucesseVC, animated: false)
    }
}
extension WithdrowViewController : ShowCVVDataDelegate {
    func showOtpVC(isFrom: String?) {
        let popUpVc = ShowOTPViewController()
        let fromAmountValue =  WalletData.shared.formatDecimalString(self.txtPay.text ?? "", decimalPlaces: 6)
        let toAmountValue =  WalletData.shared.formatDecimalString(self.txtGet.text ?? "", decimalPlaces: 6)
        popUpVc.fromAmount = fromAmountValue
        popUpVc.isFrom = "withdrawCrypto"
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
// swiftlint:enable type_body_length
extension Wallet {
    func isEqualTo(_ other: Wallet) -> Bool {
        return self.currency == other.currency &&
               self.image == other.image &&
               self.balanceString == other.balanceString &&
               self.allowOperations == other.allowOperations
    }
}
