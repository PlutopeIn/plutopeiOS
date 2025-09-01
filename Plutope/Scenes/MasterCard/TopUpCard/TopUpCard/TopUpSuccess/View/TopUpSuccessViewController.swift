//
//  TopUpSuccessViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/05/24.
//

import UIKit

class TopUpSuccessViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblBalance: DesignableLabel!
    @IBOutlet weak var btnDone: GradientButton!
    var cardNumber = ""
    var cardPrice = ""
    var cardCurrency = ""
    var cardToCurrency = ""
    var phonenumber = ""
    var isFrom = ""
    var isFromDashboard = ""
    var isFailer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.backgroundColor = UIColor.c24BE74
        print("cardNumber =",cardNumber)
        if isFrom == "sendCardWallet" {
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendSuccessMsg, comment: "")
            // "You've successfully sent the crypto"
            let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
            lblCardNumber.text = "- \(balance) \(cardCurrency)"
            lblBalance.text = phonenumber
            lblBalance.font = AppFont.regular(22).value
        } else if isFrom == "buyCryptoWallet" {
            if isFailer == false {
                lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buySuccessMsg, comment: "") // "You've successfully bought the crypto"
                lblCardNumber.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardNumber, comment: "")) \(cardNumber)"
                lblBalance.font = AppFont.regular(22).value
                let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
                lblBalance.text = "+ \(balance) \(cardCurrency)"
            } else {
                lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionFailed, comment: "")
                lblCardNumber.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardNumber, comment: "")) \(cardNumber)"
                lblBalance.font = AppFont.regular(22).value
                let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
                lblBalance.text = "\(balance) \(cardCurrency)"
                self.mainView.backgroundColor = UIColor.cED4337
            }
        } else if isFrom == "exchnageCrypto" {
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchangedSuccessMsg, comment: "") // "You've successfully exchanged a crypto"
           // let cardNumber =  UserDefaults.standard.value(forKey: cryptoCardNumber) as? String ?? ""
            
            lblCardNumber.text = "\(cardCurrency) -> \(cardToCurrency)"
            lblBalance.font = AppFont.regular(22).value
            let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
            lblBalance.text = "+ \(balance) \(cardToCurrency)"
        } else if isFrom == "topupVC" {
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.toppedUpSuccessMsg, comment: "") // "You've successfully topped up your card"
            let cardNumber =  UserDefaults.standard.value(forKey: cryptoCardNumber) as? String ?? ""
            let cardNumber1 = showLastFourDigits(of: cardNumber)
            lblCardNumber.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardNumber, comment: "")) \(cardNumber1)"
            lblBalance.font = AppFont.regular(22).value
            let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
            lblBalance.text = "+ \(balance) \(cardCurrency)"
            
        } else if isFrom == "withdrawCrypto" {
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.withdrawnSuccessMsg, comment: "")
            //let cardNumber =  UserDefaults.standard.value(forKey: cryptoCardNumber) as? String ?? ""
            let cardNumber1 = showLastFourDigits(of: self.cardNumber)
            lblCardNumber.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardNumber, comment: "")) \(cardNumber1)"
            lblBalance.font = AppFont.regular(22).value
            let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
            lblBalance.text = "- \(balance) \(cardCurrency)"
        } else {
            
        }
        let todayDateString = getTodayDateString()
        lblDateTime.text = todayDateString
        print(todayDateString)
    }
    func getTodayDateString() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm" // You can customize the format as needed
        return dateFormatter.string(from: today)
    }
    @IBAction func btnDoneAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        if isFrom == "buyCrypto" {
//            
//            if isFromDashboard == "dashboard" {
//                if let navigationController = self.navigationController {
//                    for viewController in navigationController.viewControllers {
//                        if viewController is CardDashBoardViewController {
//                             NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
//                            navigationController.popToViewController(viewController, animated: true)
//                            break
//                        }
//                    }
//                }
//            } else {
//                if let navigationController = self.navigationController {
//                    for viewController in navigationController.viewControllers {
//                        if viewController is TokenDashboardViewController {
//                            // NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
//                            navigationController.popToViewController(viewController, animated: true)
//                            break
//                        }
//                    }
//                }
//            }
//        } else {
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is CardDashBoardViewController {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
                        navigationController.popToViewController(viewController, animated: true)
                        break
                    }
                }
            }
        // }
    }
}
extension TopUpSuccessViewController {
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
