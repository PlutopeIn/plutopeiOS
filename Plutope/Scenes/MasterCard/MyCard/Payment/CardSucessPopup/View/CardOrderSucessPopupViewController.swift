//
//  CardOrderSucessPopupViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/06/24.
//

import UIKit

class CardOrderSucessPopupViewController: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.congratualtions, comment: "")
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.orderComplete, comment: "")
        btnDone.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.done, comment: ""), for: .normal)
        
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
    }
}
