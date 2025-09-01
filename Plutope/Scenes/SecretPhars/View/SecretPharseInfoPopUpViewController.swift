//
//  SecretPharseInfoPopUpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/12/23.
//

import UIKit

class SecretPharseInfoPopUpViewController: UIViewController {

    @IBOutlet weak var lblMsg4: UILabel!
    @IBOutlet weak var lblMsg3: UILabel!
    @IBOutlet weak var lblMsg2: UILabel!
    @IBOutlet weak var lblMsg1: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var ivClose: UIImageView!
    fileprivate func uiSetUp() {
        mainView.clipsToBounds = true
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mainView.layer.cornerRadius = 20
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.neverShareSecretPhrase, comment: "")
        lblMsg1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.secretPhraseMsg1, comment: "")
        lblMsg2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.secretPhraseMsg2, comment: "")
        lblMsg3.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.secretPhraseMsg3, comment: "")
        lblMsg4.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.secretPhraseMsg4, comment: "")
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        lblTitle.font = AppFont.violetRegular(22).value
        lblMsg1.font = AppFont.regular(14).value
        lblMsg2.font = AppFont.regular(14).value
        lblMsg3.font = AppFont.regular(14).value
        lblMsg4.font = AppFont.regular(14).value
        btnContinue.titleLabel?.font = AppFont.violetRegular(20).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
        uiSetUp()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func btnContinueAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true)
    }
    
}
