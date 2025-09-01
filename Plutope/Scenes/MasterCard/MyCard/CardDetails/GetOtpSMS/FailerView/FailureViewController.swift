//
//  FailureViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/07/24.
//

import UIKit

class FailureViewController: UIViewController {

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
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionFailed, comment: "")
        
        lblCardNumber.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardNumber, comment: "")) \(cardNumber)"
        lblBalance.font = AppFont.regular(22).value
        let balance = WalletData.shared.formatDecimalString(cardPrice, decimalPlaces: 5)
        lblBalance.text = "\(balance) \(cardCurrency)"
        btnDone.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.done, comment: ""), for: .normal)
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
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is CardDashBoardViewController {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
                        navigationController.popToViewController(viewController, animated: true)
                        break
                    }
                }
            }
        //}
    }
}
extension FailureViewController {
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
