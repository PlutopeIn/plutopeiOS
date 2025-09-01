//
//  TopUpCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/05/24.
//

import UIKit
// swiftlint:disable type_body_length
class TopUpCardViewController: UIViewController ,Reusable {
   
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lblAllTitle: UILabel!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblYouGetTitle: UILabel!
    @IBOutlet weak var lblYouPayTitle: UILabel!
    
    @IBOutlet weak var ivCardCompany: UIImageView!
    @IBOutlet weak var viewCard: UIView!
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
    @IBOutlet weak var lblPayCoinName: UILabel!
    @IBOutlet weak var lblPayCoinBalance: UILabel!
    @IBOutlet weak var txtPay: LoadingTextField!
    @IBOutlet weak var lblType1: DesignableLabel!
    
    /// Get Coin Outlets
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var lblGetCoinName: UILabel!
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
    @IBOutlet weak var vwMin: UIView!
    @IBOutlet weak var vwMax: UIView!
    
    var arrCardList : [Card] = []
    var arrWalletList : [Wallet] = []
    var arrCurrencyList : [String] = []
    var priceDataValueArr : [PriceDataValues] = []
    var priceDataValueSring : String = ""
    var cardRequestId : Int?
    var arrPayloadOtherData : PayloadOtherList?
    var supplierFee = ""
    var transactionFee = ""
    var additionalFee = ""
    var vaultFee  = ""
    var clientMarkUpFee = ""
    var totalFees = 0.0
    var toCurrency = ""
    var balance = ""
    var isFromCollectionView = false
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,_ in
        }
    }()
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var topUpViewModel: TopUpCardViewwModel = {
        TopUpCardViewwModel { _ ,_ in
        }
    }()
    fileprivate func uiSetUp() {
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.topUpCard, comment: ""), btnBackHidden: false)
        lblYouPayTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay, comment: "")
        
        lblYouGetTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youget, comment: "")
        lblTotalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalFees, comment: "")
        txtPay.delegate = self
        txtGet.delegate = self
        txtGet.placeHolderColor = UIColor.secondaryLabel
        txtPay.placeHolderColor = UIColor.secondaryLabel
        clvPrice.isMultipleTouchEnabled = false
        self.btnContinue.alpha = 0.5
        self.btnContinue.isEnabled = false
        self.txtGet.font = AppFont.regular(16).value
        self.lblYouGetTitle.font = AppFont.regular(15).value
        self.lblYouPayTitle.font = AppFont.regular(15).value
        self.txtPay.font = AppFont.regular(16).value
        self.lblPayCoinBalance.font = AppFont.regular(15).value
        self.lblGetError.font = AppFont.regular(9).value
        self.lblPayError.font = AppFont.regular(9).value
        self.lblRate.font = AppFont.violetRegular(15).value
        self.lblTotalTitle.font = AppFont.violetRegular(15).value
        self.lblTotal.font = AppFont.violetRegular(15).value
        self.lblTotalTitle.font = AppFont.violetRegular(15).value
        self.lblOperationTime.font = AppFont.violetRegular(15).value
        self.lblOperationTimeTitle.font = AppFont.violetRegular(15).value
        self.lblType1.font = AppFont.violetRegular(15).value
        self.lblType2.font = AppFont.violetRegular(15).value
        self.lblMaxTitle.font = AppFont.regular(14).value
        self.lblMax.font = AppFont.regular(14).value
        self.lblMinTitle.font = AppFont.regular(14).value
        self.lblMin.font = AppFont.regular(14).value
        self.lblAllTitle.font = AppFont.regular(14).value
        self.lblAll.font = AppFont.regular(14).value
        btnContinue.titleLabel?.font = AppFont.violetRegular(18).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCard()
        loadNibs()
        uiSetUp()
        
        vwMin.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtGet.text = self.lblMin.text
            self.isFromCollectionView = false
            self.textFieldDidChangeSelection(self.txtGet)
        }
        vwMax.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtGet.text = self.lblMax.text
            self.isFromCollectionView = false
            self.textFieldDidChangeSelection(self.txtGet)
        }
        viewAll.addTapGesture {
            HapticFeedback.generate(.light)
            self.txtGet.text = self.lblAll.text
            self.isFromCollectionView = false
            self.textFieldDidChangeSelection(self.txtGet)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtGet.textAlignment = .left
            txtPay.textAlignment = .left
        } else {
            txtGet.textAlignment = .right //.left
            txtPay.textAlignment = .right //.left
        }
        self.getCardPayloadCurrencies()
        self.getWalletTokens()
        
    }
    func loadNibs() {
        clvPrice.register(WalletPriceClvCell.nib, forCellWithReuseIdentifier: WalletPriceClvCell.reuseIdentifier)
        clvPrice.delegate = self
        clvPrice.dataSource = self

    }
    func getCard() {
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.getCardAPINew { status,msg,data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                 
                let filteredWalletList = data?.filter { $0.status == "ACTIVE" }
                self.arrCardList = filteredWalletList ?? []
                let cardNo = self.showLastFourDigits(of: self.arrCardList.first?.number ?? "")
                self.lblType2.text = self.arrCardList.first?.number ?? ""  //cardNo
                if self.arrCardList.first?.cardCompany == "VISA" {
                    self.ivCardCompany.image = UIImage(named: "visa")
                } else {
                    self.ivCardCompany.image = UIImage(named: "ic_masterCard1")
                }
                if self.arrCardList.first?.cardDesignID == "BLUE" {
                    self.viewCard.backgroundColor = UIColor.c2B5AF3
                } else if self.arrCardList.first?.cardDesignID == "ORANGE" {
                    self.viewCard.backgroundColor = UIColor.cffa500
                } else if self.arrCardList.first?.cardDesignID == "BLACK" {
                    self.viewCard.backgroundColor = UIColor.black
                } else if self.arrCardList.first?.cardDesignID == "GOLD" {
                    self.viewCard.backgroundColor = UIColor.cCBB28B
                } else if self.arrCardList.first?.cardDesignID == "PURPLE" {
                    self.viewCard.backgroundColor = UIColor.c800080
                }
//                self.ivGetCoin.image = UIImage(named: "ic_visa")
                if let price = self.arrCardList.first?.balance?.value {
                               let priceValue: Double = {
                                   switch price {
                                   case .int(let value):
                                       return Double(value)
                                   case .double(let value):
                                       return value
                                   }
                               }()
                    
                    self.lblGetCoinBalance.text = "\(priceValue) \(self.arrCardList.first?.balance?.currency ?? "")"
                           } else {
                               self.lblGetCoinBalance.text = "0"
                           }
               // completion()
            } else {
                DGProgressView.shared.hideLoader()
            }
        }
    }

    func getCardPayloadCurrencies() {
        self.topUpViewModel.getCardPayloadCurrenciesAPI { resStatus,msg, dataValue in
            if resStatus == 1 {
                self.arrCurrencyList = dataValue?.currencies ?? []
//                self.lblType1.text = self.arrCurrencyList.first
              //  completion()
            } else {
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
        
    }

    func getCardPayloadData() {
        topUpViewModel.getCardPayloadOtherData(cardRequestId: "\(self.cardRequestId ?? 0)") { resStatus,msg, dataValue in
            if resStatus == 1 {
                self.arrPayloadOtherData = dataValue
               // DispatchQueue.main.async {
                    self.updateFees(dataValue: dataValue)
               // }
            } else {
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    fileprivate func feesCalculation(dataValue: PayloadOtherList?) {
        if let supplierFee = dataValue?.fees?.supplierFee {
            let supplierValue: Double = {
                switch supplierFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.supplierFee = "\(supplierValue)"
        } else {
            self.supplierFee = "0"
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
        if let vaultFee = dataValue?.fees?.vaultFee {
            let vaultFeeValue: Double = {
                switch vaultFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.vaultFee = "\(vaultFeeValue)"
        } else {
            self.vaultFee = "0"
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
        if let clientMarkUpFee = dataValue?.fees?.clientMarkUpFee {
            let clientMarkUpFeeValue: Double = {
                switch clientMarkUpFee {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.clientMarkUpFee = "\(clientMarkUpFeeValue)"
        } else {
            self.clientMarkUpFee = "0"
        }
    }
    
    func updateFees(dataValue: PayloadOtherList?) {
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
                     self.lblRate.text = "\(pairRatesValue) \(pair.currencyTo ?? "")"
                 } else {
                     self.lblRate.text = "0"
                 }
                 self.lblRateTitle.text = "\(pair.currencyFrom ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
                 self.toCurrency = pair.currencyTo ?? ""
                 fromCurrency = pair.currencyFrom ?? ""
                 self.lblOperationTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly, comment: "")
                 self.lblOperationTimeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationtime, comment: "")
                 self.lblMaxTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: "")
                 self.lblMinTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.min, comment: "")
                 self.lblAllTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.all, comment: "")
                
                 if let defaultMaxAmountFrom = pair.fromLimits?.max {
                     let defaultMaxAmountFromValue: Double = {
                         switch defaultMaxAmountFrom {
                         case .int(let value):
                             return Double(value)
                         case .double(let value):
                             return value
                         }
                     }()
                     self.lblMax.text = "\(defaultMaxAmountFromValue)"
                     // self.maxValue = "\(defaultMaxAmountFromValue)"
                 } else {
                     self.lblMax.text =  "0"
                     // self.maxValue = ""
                 }
                 if let defaultMinAmountFrom = pair.fromLimits?.min {
                     let defaultMinAmountFromValue: Double = {
                         switch defaultMinAmountFrom {
                         case .int(let value):
                             return Double(value)
                         case .double(let value):
                             return value
                         }
                     }()
                     self.lblMin.text = "\(defaultMinAmountFromValue)"
                     // self.minValue = "\(defaultMinAmountFromValue)"
                 } else {
                     self.lblMin.text =  "0"
                    // self.minValue = ""
                 }
                 if let defaultAllAmountFrom = pair.fromLimits?.all {
                     let defaultAllAmountFromValue: Double = {
                         switch defaultAllAmountFrom {
                         case .int(let value):
                             return Double(value)
                         case .double(let value):
                             return value
                         }
                     }()
                     let all = WalletData.shared.formatDecimalString("\(defaultAllAmountFromValue)", decimalPlaces: 6)
                     self.lblAll.text = "\(all)"
                     
                     // self.minValue = "\(defaultMinAmountFromValue)"
                 } else {
                     self.lblAll.text =  "0"
                    // self.minValue = ""
                 }
                 self.priceDataValueArr = [PriceDataValues(description: "50 \(self.toCurrency)", isSelected: false),PriceDataValues(description: "100 \(self.toCurrency)", isSelected: false),PriceDataValues(description: "300 \(self.toCurrency)", isSelected: false),PriceDataValues(description: "500 \(self.toCurrency)", isSelected: false),PriceDataValues(description: "1000 \(self.toCurrency)", isSelected: false)]
                 self.clvPrice.reloadData()
             } else {
                 self.lblRateTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: "")
                 self.lblRate.text = ""
                 self.lblTotal.text = ""
             }
             self.feesCalculation(dataValue: dataValue)
            
             if let supplierFeeValue = Double(self.supplierFee),
                let transactionFeeValue = Double(self.transactionFee),
                let additionalFeeValue = Double(self.additionalFee),
                let vaultFeeValue = Double(self.vaultFee),
                let clientMarkUpFeeValue = Double(self.clientMarkUpFee) {
                 
                 // Calculate the total fee
                 self.totalFees = supplierFeeValue + transactionFeeValue + additionalFeeValue + vaultFeeValue + clientMarkUpFeeValue
             //    print("Total Fee: \(self.totalFees )")
                 let total = (Double(self.txtPay.text ?? "0.0") ?? 0.0) + self.totalFees
                 let totalBalance = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 6)
                 self.lblTotal.text = "\("0.0") \(fromCurrency)"
                 
             } else {
                 print("One or more values are invalid")
             }
             self.lblShipping.text = "0"
             let amount = Double(self.txtGet.text ?? "0.0") ?? 0.0
             let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getAmount, comment: ""), amount: amount, currency: self.toCurrency)
             self.btnContinue.setTitle(message, for: .normal)
         }
    }

    func getWalletTokens() {
        myTokenViewModel.getTokenAPINew { status, data ,fiat ,msg in
            if status == 1 {
                DispatchQueue.main.async {
//                    self.arrWalletList = data ?? []
                    
                    let filteredWallets = data?.filter { wallet in
                        if let name = wallet.currency {
                            return self.arrCurrencyList.contains(name)
                        }
                        return false
                    }
                    self.getCardPayloadData()
                    self.arrWalletList = filteredWallets ?? []
                    self.lblType1.text = self.arrWalletList.first?.currency
                    print("self.arrWalletList.first?.image",self.arrWalletList.first?.iconUrl ?? "")
                    self.ivPayCoin.sd_setImage(with: URL(string: "\(self.arrWalletList.first?.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
                    let balance = WalletData.shared.formatDecimalString(self.arrWalletList.first?.balanceString ?? "", decimalPlaces: 6)
                    print("walletBalance==",balance)
//                    self.lblPayCoinBalance.text = balance
                    self.lblPayCoinBalance.text = balance
                    self.balance = balance
                }
            } else {
            }
            
        }
    }
    @IBAction func btnSelectPayAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPay.text = ""
        txtGet.text = ""
        lblGetError.text = ""
        lblPayError.text = ""
        let tokenListVC = MyTokenViewController()
        tokenListVC.isFrom = "topupVC"
        
        let filteredArray = self.arrWalletList.filter { dict in
            if let name = dict.currency {
                return self.arrCurrencyList.contains(dict.currency ?? "")
            }
            return false
        }
       // print(filteredArray)
        tokenListVC.arrCurrencyList = self.arrCurrencyList
        tokenListVC.arrWalletList = filteredArray
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
    }
    @IBAction func btnContinueAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if (txtPay.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyPayAmount, comment: ""), font: AppFont.regular(15).value)
        } else if (txtGet.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyGetAmount, comment: ""), font: AppFont.regular(15).value)
        } else {
            let popUpVc = BuyCardPopUpViewController()
            let fromAmountValue =  WalletData.shared.formatDecimalString(self.txtPay.text ?? "", decimalPlaces: 6)
            let toAmountValue =  WalletData.shared.formatDecimalString(self.txtGet.text ?? "", decimalPlaces: 6)
            popUpVc.fromAmount = fromAmountValue
            popUpVc.cardRequestId = self.cardRequestId ?? 0
            popUpVc.isFrom = "topupVC"
            popUpVc.fromCurrency = lblType1.text ?? ""
            popUpVc.toCurrency = self.toCurrency
            popUpVc.toAmount = toAmountValue
            popUpVc.tokenRate = lblRate.text ?? ""
            popUpVc.tokenCurrency = lblRateTitle.text ?? ""
            popUpVc.delegate = self
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            self.present(popUpVc, animated: true)
        }
            
    }
    @IBAction func btnSelectGetAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPay.text = ""
        txtGet.text = ""
        lblGetError.text = ""
        lblPayError.text = ""
        let cardListVC = MyCardViewController()
        cardListVC.isFrom = "topupVC"
        let filteredWalletList = self.arrCardList.filter { $0.status == "ACTIVE" }
        cardListVC.arrCardList = filteredWalletList
        cardListVC.carddelegate = self
        self.navigationController?.present(cardListVC, animated: true)
    }
    
}
// swiftlint:enable type_body_length
extension TopUpCardViewController : TopupCardDelegate {
    func selectedCard(tokenName: String, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, cardDesignId: String, cardType: String) {
        DispatchQueue.main.async {
            self.lblType2.text = tokenName
//            self.ivGetCoin.image = UIImage(named: "ic_visa")
            if cardType == "VISA" {
                self.ivCardCompany.image = UIImage(named: "visa")
            } else {
                self.ivCardCompany.image = UIImage(named: "ic_masterCard1")
            }
            if cardDesignId == "BLUE" {
                self.viewCard.backgroundColor = UIColor.c2B5AF3
            } else if cardDesignId == "ORANGE" {
                self.viewCard.backgroundColor = UIColor.cffa500
            } else if cardDesignId == "BLACK" {
                self.viewCard.backgroundColor = UIColor.black
            } else if cardDesignId == "GOLD" {
                self.viewCard.backgroundColor = UIColor.cCBB28B
            } else if cardDesignId == "PURPLE" {
                self.viewCard.backgroundColor = UIColor.c800080
            }
            self.lblGetCoinBalance.text = "\(tokenbalance) \(tokenCurruncy)"
        }
    }
    
}
extension TopUpCardViewController : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String,isFromToken1: String?) {
        DispatchQueue.main.async {
            self.getCardPayloadData()
            self.lblType1.text = tokenName
            self.ivPayCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
            let balance = WalletData.shared.formatDecimalString(tokenbalance, decimalPlaces: 6)
//            self.lblPayCoinBalance.text = "\(balance)"// \(tokenCurruncy)"
            self.lblPayCoinBalance.text = balance
            self.balance = balance
            print("selectedWalletBalance == ",balance)
        }
    }
    
}
extension TopUpCardViewController {
    func showLastFourDigits(of input: String) -> String {
        let length = input.count
        guard length > 4 else {
            return input
        }
        let start = input.index(input.endIndex, offsetBy: -4)
        let lastFour = input[start..<input.endIndex]
        return "***" + lastFour
    }
}

extension TopUpCardViewController : SelectedCurrencyDelegate {
    func getSelectedCurrency(name: String) {
        DispatchQueue.main.async {
            self.lblType1.text = name
        }
    }
}
extension TopUpCardViewController : GotoDashBoardDelegate {
    func gotoPengingDashboard() {
        
    }
    
    func gotoDashBoard() {
        let topupSucesseVC = TopUpSuccessViewController()
        topupSucesseVC.isFrom = "topupVC"
        topupSucesseVC.cardPrice = self.txtGet.text ?? ""
        topupSucesseVC.cardCurrency = self.toCurrency
        topupSucesseVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(topupSucesseVC, animated: false)
    }
}
