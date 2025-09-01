//
//  CardPaymentViewControllerNew.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/05/24.
//

import UIKit
import SDWebImage
class CardPaymentViewControllerNew: UIViewController {

    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var ivCardType: UIImageView!
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var headerVieww: UIView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var lblPayCoinName: UILabel!
    @IBOutlet weak var lblPayCoinBalance: UILabel!
    
    @IBOutlet weak var txtBalance: LoadingTextField!
    @IBOutlet weak var lblType1: DesignableLabel!
    
    @IBOutlet weak var lblCardRateTitle: UILabel!
    
    @IBOutlet weak var lblCardRate: UILabel!
    
    @IBOutlet weak var btnPayment: GradientButton!
    @IBOutlet weak var lblAddressTitle: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCardTitle: UILabel!
    
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblDiliveryTitle: UILabel!
    
    @IBOutlet weak var lblDilivery: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    
    @IBOutlet weak var stackDelivery: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblWarning: UILabel!
    var cardRequestId = 0
    var arrWalletList : [Wallet] = []
    var arrSingleWallet : Wallet?
    var address = ""
    var cardType = ""
    var currency = ""
    var isFrom = ""
    var cardCurrency = ""
    var rateValue = ""
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,message in
        }
    }()
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    lazy var coinGeckoViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,_ in
           // self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.getWalletTokens()
        // Navigation header
        defineHeader(headerView: headerVieww, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.payment, comment: ""), btnBackHidden: true)
        let cardTypes = UserDefaults.standard.value(forKey: cardTypes) as? String ?? ""
        lblTotalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.total, comment: "")
        lblDiliveryTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.delivery, comment: "")
        lblCardTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: "")
        lblAddressTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourAddress, comment: "")
        lblWarning.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paymentWarning, comment: "")
        
        txtBalance.isUserInteractionEnabled = false
        lblCardType.text = "\(cardTypes) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
        if cardTypes == "Virtual" {
            stackDelivery.isHidden = true
        } else {
            stackDelivery.isHidden = false
        }
        btnBack.addTapGesture {
            HapticFeedback.generate(.light)
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is CardDashBoardViewController {
                        navigationController.popToViewController(viewController, animated: true)
                       
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtBalance.textAlignment = .right
        } else {
            txtBalance.textAlignment = .left
        }
    }
    @IBAction func btnPaymentAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let popUpVc = BuyCardPopUpViewController()
        popUpVc.cardType = self.cardType
        popUpVc.totalAmount = self.lblTotal.text ?? ""
        popUpVc.isFrom = "payment"
        popUpVc.delegate = self
        popUpVc.address = self.lblAddress.text ?? ""
        popUpVc.currency = self.currency
        popUpVc.cardRequestId = self.cardRequestId
        popUpVc.modalTransitionStyle = .crossDissolve
        popUpVc.modalPresentationStyle = .overFullScreen
        self.present(popUpVc, animated: true)
    }
    
    func getWalletTokens() {
        myTokenViewModel.getTokenAPINew { status, data ,fiat,arg  in
            if status == 1 {
                self.arrWalletList = data ?? []
                print(self.arrWalletList)
                self.lblType1.text = self.arrWalletList.first?.currency
                
                self.ivPayCoin.sd_setImage(with: URL(string: "\(self.arrWalletList.first?.image ?? "")"), placeholderImage: UIImage.icBank)
                self.txtBalance.text = "\(self.arrWalletList.first?.balanceString ?? "")"// \(self.arrWalletList.first?.currency ?? "")"
                self.currency = self.arrWalletList.first?.currency ?? ""
                if let rate = self.arrWalletList.first?.fiat?.rate {
                    let rateValue: Double = {
                        switch rate {
                        case .int(let value):
                            return Double(value)
                        case .double(let value):
                            return value
                        }
                    }()
                    self.rateValue = "\(rateValue) \(self.arrWalletList.first?.fiat?.customerCurrency ?? "")"
                    
                } else {
                    self.rateValue = "0"
                }
                self.getCardRequestPrice(currency: self.currency)
            } else {
            }
        }
    }
    func getCardRequestPrice(currency:String) {
        myCardViewModel.apiGetCardRequestPriceNew(cardRequestId: self.cardRequestId, currency: currency) { status, msg ,data in
            var amount = ""
            var dilivery = ""
            if status == 1 {
                DispatchQueue.main.async {
                    // rate
                    self.lblCardRateTitle.text = "\(data?.cryptoPrice?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.rate, comment: ""))"
                    self.lblCardRate.text = "\(self.rateValue)" //\(data?.fiatPrice?.currency ?? "")"
                    self.cardCurrency = data?.fiatPrice?.currency ?? ""
                    //            let rateCalculation =
                    /// card
                    if let cardprice = data?.card?.crypto?.value {
                        let cardpriceValue: Double = {
                            switch cardprice {
                            case .int(let value):
                                return Double(value)
                            case .double(let value):
                                return value
                            }
                        }()
                        self.lblCard.text = "\(cardpriceValue) \(data?.card?.crypto?.currency ?? "")"
                        amount = "\(cardpriceValue)"
                    } else {
                        self.lblCard.text = "0"
                    }
                    // deliverry
                    if let price2 = data?.delivery?.crypto?.value {
                        let price2Value: Double = {
                            switch price2 {
                            case .int(let value):
                                return Double(value)
                            case .double(let value):
                                return value
                            }
                        }()
                        self.lblDilivery.text = "\(price2Value) \(data?.delivery?.crypto?.currency ?? "")"
                        dilivery = "\(price2Value)"
                    } else {
                        self.lblDilivery.text = "0"
                    }
                    // total
                    let total = (Double(amount) ?? 0.0) + (Double(dilivery) ?? 0.0)
                    let totaltax = WalletData.shared.formatDecimalString("\(total)", decimalPlaces: 8)
                    self.lblTotal.text = "\(totaltax) \(data?.card?.crypto?.currency ?? "")"
                    let amount = Double(self.lblTotal.text ?? "0.0") ?? 0.0
                    let message = LocalizationHelper.localizedMessageForGet(key: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pay, comment: ""), amount: amount, currency: "")
                    self.btnPayment.setTitle(message, for: .normal)
                    // Concatenate the address components into a single string
                    
                    if data?.address == nil {
                        print(self.address)
                        self.lblAddress.text = self.address
                    } else {
                    if let country = data?.address?.country,
                       let city = data?.address?.city,
                       let streetAddress = data?.address?.address,
                       let postalCode = data?.address?.postalCode {
                        let fullAddress = "\(streetAddress), \(city), \(postalCode), \(country)"
                        print(fullAddress)
                        self.lblAddress.text = fullAddress
                    }
                }
            }
        }
        }
            
    }
    
    @IBAction func btnSelectWalletAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let tokenListVC = MyTokenViewController()
        tokenListVC.isFrom = "payment"
        let filteredData = self.arrWalletList.filter { $0.allowOperations?.contains("CP_2_PAYLOAD") ?? false }
        self.arrWalletList = filteredData
        tokenListVC.arrWalletList = filteredData
        tokenListVC.delegate = self
        self.navigationController?.present(tokenListVC, animated: true)
    }
}
extension CardPaymentViewControllerNew : TopupWalletDelegate {
    func selectedToken(tokenName: String, tokenimage: String?, tokenbalance: String, tokenAmount: String, tokenCurruncy: String, tokenArr: Wallet?, currency: String,isFromToken1: String?) {
        DispatchQueue.main.async {
            self.lblType1.text = tokenName
//            self.ivPayCoin.image = UIImage.icOkc
            self.ivPayCoin.sd_setImage(with: URL(string: "\(tokenimage ?? "")"), placeholderImage: UIImage.icBank)
            self.txtBalance.text = "\(tokenbalance)"
            self.arrSingleWallet = tokenArr
            self.currency = currency
            if let rate = tokenArr?.fiat?.rate {
                let rateValue: Double = {
                    switch rate {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                self.rateValue = "\(rateValue) \(tokenArr?.fiat?.customerCurrency ?? "")"
                
            } else {
                self.rateValue = "0"
            }

            self.getCardRequestPrice(currency: currency)
        }
     
    }
}

extension CardPaymentViewControllerNew : GotoDashBoardDelegate {
    func gotoPengingDashboard() {
        
    }
    
//    func gotoDashBoard() {
//        if let navigationController = self.navigationController {
//            for viewController in navigationController.viewControllers {
//                if viewController is CardDashBoardViewController {
//                    NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
//                    navigationController.popToViewController(viewController, animated: true)
//                   break
//                }
//            }
//        }
//    }
    
    func gotoDashBoard() {
        let orderSucesseVC = CardOrderSucessPopupViewController()
        orderSucesseVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(orderSucesseVC, animated: false)
    }
}
