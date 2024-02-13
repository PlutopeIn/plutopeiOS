//
//  BackupWalletViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
// import WalletCore
import CGWallet

class BackupWalletViewController: UIViewController, Reusable {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvWarnings: UITableView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var lblBackUpWallet: UILabel!
    @IBOutlet weak var lblInTheNextStep: UILabel!
    
    var mnemonicArray = [String]()
    var mnemonicKey: String? = ""
    
    /*var arrWarnings: [WarningModel] = [
        WarningModel(isChecked: false, warning: StringConstants.information1),
        WarningModel(isChecked: false, warning: StringConstants.information2),
        WarningModel(isChecked: false, warning: StringConstants.information3)
    ]*/
    var arrWarnings: [WarningModel] = [
        WarningModel(isChecked: false, warning:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.iflosemysecretphrasemyfundswillbelostforever, comment: "")),
        WarningModel(isChecked: false, warning:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ifexposeorsharemysecretphrasetoanybodymyfundscangetstolen, comment: "")),
        WarningModel(isChecked: false, warning:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plutopesupportwillneverreachouttoaskforit, comment: ""))
    ]
    
    var wallet: Wallets?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "")
        
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblBackUpWallet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.backupyourwalletnow, comment: "")
        self.lblInTheNextStep.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.inthenextstepyouwillsesecretphrase12wordsAllowRecoverWallet, comment: "")
        
        /// Table register
        tableRegister()
         
    }
    
    /// Table register
    func tableRegister() {
        tbvWarnings.delegate = self
        tbvWarnings.dataSource = self
        tbvWarnings.register(WarningViewCell.nib, forCellReuseIdentifier: WarningViewCell.reuseIdentifier)
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        let viewToNavigate = RecoveryPhraseViewController()
        if wallet == nil {
            let mnemonic = CGWalletGenerateMnemonic(12)
            self.mnemonicKey = mnemonic
            // self.mnemonicKey = HDWallet(strength: 128, passphrase: "")?.mnemonic
            print("mnemonicKey=",self.mnemonicKey ?? "")
        } else {
            self.mnemonicKey = wallet?.mnemonic ?? ""
        }
        self.mnemonicArray = self.mnemonicKey?.components(separatedBy: " ") ?? []
        
        viewToNavigate.mnemonic = self.mnemonicKey
        viewToNavigate.wallet = self.wallet
        for (idx, phrase) in mnemonicArray.enumerated() {
            viewToNavigate.arrSecretPhrase.append(SecretPhraseDataModel(number: idx + 1, phrase: phrase))
        }
        viewToNavigate.isFrom = .manual
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
}
