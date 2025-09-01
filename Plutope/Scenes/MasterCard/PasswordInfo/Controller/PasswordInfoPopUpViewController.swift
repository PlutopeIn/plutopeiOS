//
//  PasswordInfoPopUpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/03/24.
//

import UIKit

class PasswordInfoPopUpViewController: UIViewController {
    @IBOutlet weak var lblMsg7: UILabel!
    @IBOutlet weak var lblMsg6: UILabel!
    @IBOutlet weak var lblMsg5: UILabel!
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

        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ok, comment: "")
                let font = AppFont.violetRegular(18).value
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font
                ]

                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        lblTitle.font = AppFont.violetRegular(20).value
        lblMsg1.font = AppFont.regular(15).value
        lblMsg2.font = AppFont.regular(15).value
        lblMsg3.font = AppFont.regular(15).value
        lblMsg4.font = AppFont.regular(15).value
        lblMsg5.font = AppFont.regular(15).value
        lblMsg6.font = AppFont.regular(15).value
        lblMsg7.font = AppFont.regular(15).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addTapGesture {
            HapticFeedback.generate(.light)
            self.navigationController?.popViewController(animated: false)
        }
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.navigationController?.popViewController(animated: false)
        }
        uiSetUp()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func btnContinueAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.navigationController?.popViewController(animated: false)
    }
    
}
