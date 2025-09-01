//
//  ExchangeCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/06/24.
//

import UIKit
struct CurrencyPair {
    var rate: PriceValue?
    var currencyFrom, currencyTo: String?
    var  minAmountFrom, maxAmountFrom : PriceValue?
    var allAmountFrom: PriceValue?
}
// swiftlint:disable type_body_length
class ExchangeCardViewController: UIViewController {
    
    @IBOutlet weak var lblGetError: UILabel!
    @IBOutlet weak var lblPayError: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMaxTitle: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMinTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblAllTitle: UILabel!
    /// Pay Coin Outlets
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
    
    @IBOutlet weak var viewAllFund: UIView!
    @IBOutlet weak var viewMinFund: UIView!
    @IBOutlet weak var btnSwap: UIButton!
    @IBOutlet weak var viewMin: UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var viewMax: UIView!
    
    @IBOutlet weak var lblYouGet: UILabel!
    @IBOutlet weak var lblYouPay: UILabel!
    var isFromSwap = false
    var arrCardList : [PayInCard] = []
    var arrWallet : Wallet?
    var arrPayWalletList : [Wallet] = []
    var arrGetWalletList : [Wallet] = []
    var supportedPayWalletTokenList: [Wallet] = []
    var supportedGetWalletTokenList: [Wallet] = []
    var arrCurrencyList : [String] = []
    var priceDataValueArr : [PriceDataValues] = []
    var priceDataValueSring : String = ""
    var cardRequestId : Int?
    var arrExchangeCurrencyList : ExchangeCurrencyList?
    var arrWalletPairs : [ExchangeCurrencyPair] = []
    var arrSelectedWalletPairs : ExchangeCurrencyPair?
    var arrGetWalletPairs : [ExchangeCurrencyPair] = []
    var partnerFee = ""
    var crypteriumGas = ""
    var additionalFee = ""
    var transactionFee  = ""
    var insuranceFee = ""
    var totalFees = 0.0
    var toCurrency = ""
    var minValue = ""
    var allValue = ""
    var maxValue = ""
    var cardType = ""
    var cardId = ""
    var fromCurrency = ""
    var cardNumber = ""
    var isFromDashboard = false
    var isSwap = false
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var exchangeCardViewModel: ExchangeCardViewModel = {
        ExchangeCardViewModel { _ ,_ in
        }
    }()
    
    fileprivate func uiSetUps() {
        lblYouPay.font = AppFont.regular(18.06).value
        lblYouGet.font = AppFont.regular(18.06).value
        txtGet.font = AppFont.violetRegular(16).value
        txtPay.font = AppFont.violetRegular(16).value
        lblMinTitle.font = AppFont.violetRegular(18.06).value
        lblAllTitle.font = AppFont.violetRegular(18.06).value
        lblMaxTitle.font = AppFont.violetRegular(18.06).value
        lblMin.font = AppFont.violetRegular(17.06).value
        lblMax.font = AppFont.violetRegular(17.06).value
        lblAll.font = AppFont.violetRegular(17.06).value
        lblRate.font = AppFont.violetRegular(15).value
        lblRateTitle.font = AppFont.violetRegular(15).value
        lblOperationTime.font = AppFont.violetRegular(15).value
        lblOperationTimeTitle.font = AppFont.violetRegular(15).value
        lblTotal.font = AppFont.violetRegular(15).value
        lblTotalTitle.font = AppFont.violetRegular(15).value
        lblShipping.font = AppFont.violetRegular(15).value
        lblShippingTitle.font = AppFont.violetRegular(15).value
        lblPayCoinBalance.font = AppFont.regular(17).value
        lblGetCoinBalance.font = AppFont.regular(17).value
        lblYouPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay, comment: "")
        lblYouGet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youget, comment: "")
        lblMinTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.min, comment: "")
        lblAllTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.all, comment: "")
        lblMaxTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: "")
        lblOperationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationtime, comment: "")
        lblOperationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: "")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.payWalletTokens()
        
        self.getWalletTokens()
        
        //        self.lblType1.text = arrWallet?.currency
        //        self.ivPayCoin.sd_setImage(with: URL(string: arrWallet?.image ?? ""), placeholderImage: UIImage.icBank)
        //
        //        let balance = WalletData.shared.formatDecimalString(arrWallet?.balanceString ?? "", decimalPlaces: 6)
        //        self.lblPayCoinBalance.text = balance
        //        self.getParingCurrencyData()
        
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchange, comment: ""), btnBackHidden: false)
        txtPay.delegate = self
        txtGet.delegate = self
        self.btnContinue.alpha = 0.5
        self.btnContinue.isEnabled = false
        uiSetUps()
        viewAllFund.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtPay.text = self.allValue
            self.textFieldDidChangeSelection(self.txtPay)
        }
        viewMin.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtPay.text = self.minValue
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
    @IBAction func btnSwapAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        UIView.animate(withDuration: 0.6, animations: {
            self.btnSwap.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.btnSwap.transform = CGAffineTransform.identity
            }  })
        
        self.swapValues()
    }
    
    fileprivate func swapValues() {
        DispatchQueue.main.async {
            // Swap lblType1 and lblType2 texts
            let tempTypeText = self.lblType1.text
            self.lblType1.text = self.lblType2.text
            self.lblType2.text = tempTypeText
            
            // Swap ivPayCoin and ivGetCoin images
            let tempCoinImage = self.ivPayCoin.image
            self.ivPayCoin.image = self.ivGetCoin.image
            self.ivGetCoin.image = tempCoinImage
            
            // Swap lblPayCoinBalance and lblGetCoinBalance texts
            let tempBalanceText = self.lblPayCoinBalance.text
            self.lblPayCoinBalance.text = self.lblGetCoinBalance.text
            self.lblGetCoinBalance.text = tempBalanceText
            
            // Swap arrPayWalletList and arrGetWalletList
            let tempWalletList = self.arrPayWalletList
            self.arrPayWalletList = self.arrGetWalletList
            self.arrGetWalletList = tempWalletList
            
            // Update the button title
            if let type1Text = self.lblType1.text, let type2Text = self.lblType2.text {
                let exchangeMessage =                LocalizationHelper.localizedMessageForExchange(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangBtnMessage, comment: ""), fromCurrency: type1Text, toCurrency: type2Text)
                
                self.btnContinue.setTitle(exchangeMessage, for: .normal)
//                self.btnContinue.setTitle("Exchange \(type1Text) -> \(type2Text)", for: .normal)
            }
            
            // Call additional method if needed
            self.getParingCurrencyData(isFromSwap:true)
        }
    }
    
    @objc func refreshData() {
        self.payWalletTokens()
        print("Refresh data called")
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshBuyDashBoard"), object: nil)
    }
    
    func getWalletTokens() {
        myTokenViewModel.getTokenAPINew { status, data,fiat ,msg in
            if status == 1 {
                let filteredData = data?.filter { $0.allowOperations?.contains("EXCHANGE") ?? false }
                self.arrGetWalletList = filteredData ?? []
                self.getParingCurrencyData()
                
                DispatchQueue.main.async {
                        
                        self.lblType2.text = "\(self.arrGetWalletList.last?.currency ?? "")"
                        
                        self.ivGetCoin.sd_setImage(with: URL(string: self.arrGetWalletList.last?.iconUrl ?? ""), placeholderImage: UIImage.icBank)
                        
                        let balance = WalletData.shared.formatDecimalString(self.arrGetWalletList.last?.balanceString ?? "", decimalPlaces: 6)
                        self.lblGetCoinBalance.text = balance
                        
                        //                    self.getParingCurrencyData()
                }
            } else {
            }
        }
    }
    func payWalletTokens() {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.getTokenAPINew { status, data,fiat,msg in
            if status == 1 {
                
                let filteredData = data?.filter { $0.allowOperations?.contains("EXCHANGE") ?? false }
                self.arrPayWalletList = filteredData ?? []
                self.getParingCurrencyData()
                DispatchQueue.main.async {
                    // Check if arrWallet exists and is part of arrWalletList
                    if let arrWallet = self.arrWallet, self.arrPayWalletList.contains(where: { $0.isEqualTo(arrWallet) }) {
                        // Use arrWallet data if it exists in arrWalletList
                        self.lblType1.text = arrWallet.currency
                        self.ivPayCoin.sd_setImage(with: URL(string: "\(arrWallet.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                        
                        if let balanceString = arrWallet.balanceString {
                            let balance = WalletData.shared.formatDecimalString(balanceString, decimalPlaces: 6)
                            self.lblPayCoinBalance.text = balance
                        }
                    } else {
                        // Otherwise, use the first element from arrWalletList
                        self.lblType1.text = self.arrPayWalletList.first?.currency
                        self.ivPayCoin.sd_setImage(with: URL(string: "\(self.arrPayWalletList.first?.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                        
                        if let balanceString = self.arrPayWalletList.first?.balanceString {
                            let balance = WalletData.shared.formatDecimalString(balanceString, decimalPlaces: 6)
                            self.lblPayCoinBalance.text = balance
                        }
                    }
                   
                }

            } else {
                DGProgressView.shared.hideLoader()
            }
        }
    }
    
    //    func getWalletTokensNew() {
    //        DGProgressView.shared.showLoader(to: view)
    //        myTokenViewModel.getTokenAPINew { status,msg, data,fiat  in
    //            if status == 1 {
    //                self.arrPayWalletList = data ?? []
    //                DispatchQueue.main.async {
    //                    self.getParingCurrencyData()
    //                    guard let arrWallet = self.arrWallet else { return }
    //                    // Find the wallet with the same name in arrPayWalletList
    //                    if let matchingWallet = self.arrPayWalletList.first(where: { $0.currency == arrWallet.currency }) {
    //                        // Update the UI elements with the matching wallet data
    //                        self.lblType1.text = matchingWallet.currency
    //                        self.ivPayCoin.sd_setImage(with: URL(string: matchingWallet.image ?? ""), placeholderImage: UIImage.icBank)
    //
    //                        let balance = WalletData.shared.formatDecimalString(matchingWallet.balanceString ?? "", decimalPlaces: 6)
    //                        self.lblPayCoinBalance.text = balance
    //                    }
    //                }
    //            } else {
    //                DGProgressView.shared.hideLoader()
    //                self.showToast(message: msg, font: AppFont.regular(15).value)
    //            }
    //        }
    //    }
    
    func updateFees(dataValue: ExchangeCurrencyList?) {
        //  DispatchQueue.main.async {
        if let pair = dataValue?.pairs?.first(where: { $0.currencyFrom == self.lblType1.text ?? "" && $0.currencyTo == self.lblType2.text ?? "" }) {
            if let pairRates = pair.rateValue {
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
            self.toCurrency = pair.currencyTo ?? ""
            self.fromCurrency = pair.currencyFrom ?? ""
            // Extract maxAmountFrom value
            let maxAmountsFrom = pair.maxAmountFrom
            
            if let defaultMaxAmountFrom = maxAmountsFrom {
                let defaultMaxAmountFromValue: Double = {
                    switch defaultMaxAmountFrom {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                let maxAmount = WalletData.shared.formatDecimalString("\(defaultMaxAmountFromValue)", decimalPlaces: 3)
                self.lblMax.text = "\(maxAmount)"
                self.maxValue = "\(maxAmount)"
            } else {
                self.lblMax.text =  "0"
                self.maxValue = ""
            }
            let minAmountsFrom = pair.minAmountFrom
            if let defaultMinAmountFrom = minAmountsFrom {
                let defaultMinAmountFromValue: Double = {
                    switch defaultMinAmountFrom {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                let minAmount = WalletData.shared.formatDecimalString("\(defaultMinAmountFromValue)", decimalPlaces: 8)
                self.lblMin.text = "\(minAmount)"
                self.minValue = "\(defaultMinAmountFromValue)"
            } else {
                self.lblMin.text =  "0"
                self.minValue = ""
            }
            let allAmountsFrom = pair.allAmountFrom
            if let allAmountsFromValue = allAmountsFrom {
                let allAmountsFromValue: Double = {
                    switch allAmountsFromValue {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
              var allValue  = WalletData.shared.formatDecimalString("\(allAmountsFromValue)", decimalPlaces: 6)
                self.lblAll.text = "\(allValue)"
                self.allValue = "\(allValue)"
            } else {
                self.lblAll.text =  "0"
                self.allValue = ""
            }
            
        } else {
            self.lblRateTitle.text = "Rate"
            self.lblRate.text = ""
            self.lblTotal.text = ""
        }
        
    }
    fileprivate func updateUIAfterFetchingData(isFromSelected:Bool? = false) {
        
        if isFromSelected == true {
            
        } else {
            if let firstGetWallet = self.arrGetWalletList.last {
                self.lblType2.text = firstGetWallet.currency
                self.ivGetCoin.sd_setImage(with: URL(string: firstGetWallet.iconUrl ?? ""), placeholderImage: UIImage.icBank)
                let tokenBalance = firstGetWallet.balanceString ?? ""
                let balance = WalletData.shared.formatDecimalString(tokenBalance, decimalPlaces: 6)
                self.lblGetCoinBalance.text = "\(balance)"
            }
            
            let exchangeMessage =                LocalizationHelper.localizedMessageForExchange(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangBtnMessage, comment: ""), fromCurrency: self.lblType1.text ?? "", toCurrency: self.lblType2.text ?? "")
            self.btnContinue.setTitle(exchangeMessage, for: .normal)

        }
    }
    
    func selectCurrencyFromWallets(currencyName: String, wallets: [Wallet]) -> String? {
        // Find the wallet with matching currency name
        if let selectedWallet = wallets.first(where: { $0.currency == currencyName }) {
            return selectedWallet.currency
        } else {
            print("Currency not found: \(currencyName)")
            return nil
        }
    }
    func getParingCurrencyData(isFromSwap:Bool? = false,selectedToken:String? = "",isFromToken1:Bool? = false,isFromToken2:Bool? = false) {
        DGProgressView.shared.showLoader(to: view)
        exchangeCardViewModel.getExchangeCurrencyAPI { resStatus, dataValue, resMessage in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.arrExchangeCurrencyList = dataValue
                self.arrWalletPairs = dataValue?.pairs ?? []
                var selectedCurrencys = ""
                if isFromSwap == true {
                    guard let selectedCurrency = self.selectCurrencyFromWallets(currencyName: self.lblType1.text ?? "", wallets: self.arrPayWalletList) else {
                        print("No selected currency found.")
                        return
                    }
                    selectedCurrencys = selectedCurrency
                    
                } else if isFromToken1 == true {
                    selectedCurrencys = selectedToken ?? ""
                } else if isFromToken2 == true {
                    selectedCurrencys = selectedToken ?? ""
                } else {
                    selectedCurrencys = self.arrWallet?.currency ?? ""
                }
                // Clear the lists before populating
                self.supportedPayWalletTokenList.removeAll()
                self.supportedGetWalletTokenList.removeAll()
                // Filter wallet tokens that allow "EXCHANGE"
                let exchangeTokens = self.arrPayWalletList.filter { token in
                    token.allowOperations?.contains("EXCHANGE") == true
                }
                // Iterate over the filtered tokens
                for token in exchangeTokens {
                    // Filter pairs where currencyFrom matches the selected wallet currency
                    let matchingPairs = self.arrWalletPairs.filter { pair in
                        pair.currencyFrom == selectedCurrencys
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
                        if pair.currencyTo == modifiedToken.currency {
                            modifiedToken.currency = pair.currencyTo
                            self.supportedGetWalletTokenList.append(modifiedToken)
                            
                        }
                        var tocurrencyValue = ""
                        if isFromSwap == true {
                            tocurrencyValue = self.lblType2.text ?? ""
                        } else if isFromToken1 == true ||  isFromToken2 == true {
                            tocurrencyValue = selectedToken ?? ""
                        } else {
                            tocurrencyValue = self.supportedGetWalletTokenList.first?.currency ?? ""
                        }
                    }
                }
                self.arrGetWalletList = self.supportedGetWalletTokenList
                DispatchQueue.main.async {
                    
                    if isFromSwap ?? false {
                    } else if isFromToken1 == true {
                        
                    } else if isFromToken2 == true {
                        
                    } else {
                        self.updateUIAfterFetchingData(isFromSelected:false)
                    }
                    self.updateFees(dataValue: self.arrExchangeCurrencyList)
                }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: resMessage, font: AppFont.regular(15).value)
            }
        }
    }
    
    @IBAction func btnSelectPayAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPay.text = ""
        txtGet.text = ""
        self.lblPayError.text = ""
        self.lblGetError.text = ""
        let exchangeMessage =                LocalizationHelper.localizedMessageForExchange(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangBtnMessage, comment: ""), fromCurrency: self.lblType1.text ?? "", toCurrency: self.lblType2.text ?? "")
        self.btnContinue.setTitle(exchangeMessage, for: .normal)

        let tokenListVC = MyTokenViewController()
        tokenListVC.arrWalletList = self.arrPayWalletList
        tokenListVC.isFrom = "exchnageCrypto"
        tokenListVC.isFromToken1 = true
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
    }
    @IBAction func btnSelectGetAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPay.text = ""
        txtGet.text = ""
        self.lblPayError.text = ""
        self.lblGetError.text = ""
        let exchangeMessage =                LocalizationHelper.localizedMessageForExchange(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangBtnMessage, comment: ""), fromCurrency: self.lblType1.text ?? "", toCurrency: self.lblType2.text ?? "")
        self.btnContinue.setTitle(exchangeMessage, for: .normal)

        let tokenListVC = MyTokenViewController()
        
        myTokenViewModel.getTokenAPINew { status, data,fiat,msg in
            if status == 1 {
                let filteredData = data?.filter { $0.allowOperations?.contains("EXCHANGE") ?? false }
                self.arrGetWalletList = filteredData ?? []
                
                tokenListVC.arrWalletList = self.arrGetWalletList
                tokenListVC.isFrom = "exchnageCrypto"
                tokenListVC.isFromToken1 = false
                tokenListVC.delegate = self
                self.navigationController?.present(tokenListVC, animated: true)
            } else {
            }
        }
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
            popUpVc.fromAmount = fromAmountValue
            popUpVc.isFrom = "exchnageCrypto"
            popUpVc.toCurrency = self.toCurrency
            popUpVc.fromCurrency = self.fromCurrency
            popUpVc.toAmount = toAmountValue
            popUpVc.tokenRate = lblRate.text ?? ""
            popUpVc.tokenCurrency = lblRateTitle.text ?? ""
            popUpVc.address = self.cardNumber
            popUpVc.delegate = self
            //  popUpVc.showOtpDelegate = self
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            self.present(popUpVc, animated: false)
        }
    }
}
extension ExchangeCardViewController : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String, isFromToken1: String?) {
        DispatchQueue.main.async {
            
            if isFromToken1 == "true" {
                
                guard let tokenName = tokenArr?.currency,
                      tokenName != self.lblType2.text ?? "" else {
                    self.showToast(message: ToastMessages.samecoinError, font: AppFont.regular(15).value)
                    return
                }
                self.getParingCurrencyData(selectedToken:tokenName,isFromToken1:true)
                self.lblType1.text = tokenName
                self.ivPayCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
                let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
                
                self.lblPayCoinBalance.text = "\(balance)"
            } else {
                guard let tokenName = tokenArr?.currency,
                      tokenName != self.lblType1.text ?? "" else {
                    self.showToast(message: ToastMessages.samecoinError, font: AppFont.regular(15).value)
                    return
                }
                self.getParingCurrencyData(selectedToken:tokenName,isFromToken2:true)
                self.lblType2.text = tokenName
                self.ivGetCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
                let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
                
                self.lblGetCoinBalance.text = "\(balance)"// \(tokenCurruncy)"
                let exchangeMessage =                LocalizationHelper.localizedMessageForExchange(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangBtnMessage, comment: ""), fromCurrency: self.lblType1.text ?? "", toCurrency: self.lblType2.text ?? "")
                
                self.btnContinue.setTitle(exchangeMessage, for: .normal)
            }
        }
    }
    
}
// swiftlint:enable type_body_length
extension ExchangeCardViewController : GotoDashBoardDelegate {
    func gotoPengingDashboard() {
        
    }
    
    func gotoDashBoard() {
        let topupSucesseVC = TopUpSuccessViewController()
        topupSucesseVC.cardPrice = txtGet.text ?? ""
        topupSucesseVC.cardCurrency = self.fromCurrency
        topupSucesseVC.cardToCurrency = self.toCurrency
        topupSucesseVC.isFrom = "exchnageCrypto"
        topupSucesseVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(topupSucesseVC, animated: false)
    }
}
