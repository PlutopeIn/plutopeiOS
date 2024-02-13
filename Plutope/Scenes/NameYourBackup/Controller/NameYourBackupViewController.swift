//
//  NameYourBackupViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
class NameYourBackupViewController: UIViewController, Reusable {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtWalletName: customTextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblNameYourBackUp: UILabel!
    @IBOutlet weak var lblBackUpName: UILabel!
    @IBOutlet weak var lblAtLeast: UILabel!
    @IBOutlet weak var lblDoNotDelete: UILabel!
    
    var wallet: Wallets?
    
    fileprivate func uiSetUp() {
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblNameYourBackUp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nameyourbackup, comment: "")
        self.lblBackUpName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.backupname, comment: "")
        self.lblAtLeast.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.includeatleast1character, comment: "")
        self.lblDoNotDelete.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.doNotDeleteThisBackupFileOnGoogle, comment: "")
        self.txtWalletName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.mainwallet, comment: "")
        
        txtWalletName.delegate = self
        
        self.txtWalletName.text = wallet?.wallet_name ?? ""
    }
   
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtWalletName.textAlignment = .right
              
            } else {
                txtWalletName.textAlignment = .left
               
            }
            
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "")
        /// UISetUps
        uiSetUp()

    }
    @IBAction func actionCancel(_ sender: Any) {
        txtWalletName.text = ""
        btnCancel.isHidden = true
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        if txtWalletName.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            self.showToast(message: "Please enter wallet backup name", font: .systemFont(ofSize: 15))
        } else {
            let viewToNavigate = EncryptionPasswordViewController()
            viewToNavigate.wallet = self.wallet
            viewToNavigate.backUpFileName = (txtWalletName.text ?? "") // .trimmingCharacters(in: .whitespaces)
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        }
    }
}

// MARK: Textfield Delegate
extension NameYourBackupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        btnCancel.isHidden = false
        return true
    }
    
}
