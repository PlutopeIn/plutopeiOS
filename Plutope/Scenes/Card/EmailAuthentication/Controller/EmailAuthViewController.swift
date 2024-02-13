//
//  EmailAuthViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 01/08/23.
//

import UIKit

class EmailAuthViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtEmail: customTextField!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblBackUpName: UILabel!
    @IBOutlet weak var lblSignUpLogin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "")
        
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblForgotPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.forgotpassword, comment: "")
        self.lblBackUpName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.backupname, comment: "")
        self.txtEmail.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.email, comment: "")
        self.lblSignUpLogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.signuplogin, comment: "")
        
        /// Action Forgot Password
        lblForgotPassword.addTapGesture {
            // Code for action
        }
       
    }

    @IBAction func actionContinue(_ sender: Any) {
        let cardDetailVC = AddCardDetailViewController()
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
    }
}
