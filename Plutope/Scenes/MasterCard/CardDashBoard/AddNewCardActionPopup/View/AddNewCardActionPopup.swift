//
//  AddNewCardActionPopup.swift
//  Plutope
//
//  Created by Trupti Mistry on 03/07/24.
//

import UIKit

class AddNewCardActionPopup: UIViewController {

    @IBOutlet weak var ivOrderCard: UIImageView!
    @IBOutlet weak var ivClose: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblMag: UILabel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cryptoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMag.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addCryptoCardmsg, comment: "")
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cryptoCard, comment: "")
        self.cryptoView.addTapGesture {
            HapticFeedback.generate(.light)
            let vcToPresent = AddNewCardViewController()
            vcToPresent.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
    }
}
