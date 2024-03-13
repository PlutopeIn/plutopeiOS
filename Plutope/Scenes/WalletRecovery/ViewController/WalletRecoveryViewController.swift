//
//  WalletRecoveryViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 02/08/23.
//

import UIKit

class WalletRecoveryViewController: UIViewController {
    
    @IBOutlet weak var viewManual: UIView!
    @IBOutlet weak var viewiCloud: UIView!
    @IBOutlet weak var btnWalletDelete: UIButton!
    @IBOutlet weak var btnSaveChanges: GradientButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtWalletName: customTextField!
    @IBOutlet weak var lblManualActive: UILabel!
    @IBOutlet weak var lblIcloudActive: UILabel!
    @IBOutlet weak var lblManualBackup: UILabel!
    @IBOutlet weak var lblICloudBackup: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblBackUpOptions: UILabel!
    
    var wallet: Wallets?
    var walletsList: [Wallets]?
    
    fileprivate func uiSetUp() {
        self.lblName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.name, comment: "")
        self.btnWalletDelete.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.deletewallet, comment: ""), for: .normal)
        self.lblIcloudActive.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.active, comment: "")
        self.lblManualActive.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.active, comment: "")
        self.lblManualBackup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.manualbackup, comment: "")
        self.lblICloudBackup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.manualbackup, comment: "")
        self.lblBackUpOptions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.backupoptions, comment: "")
        
        self.txtWalletName.text = wallet?.wallet_name ?? ""
        self.txtWalletName.delegate = self
        self.btnSaveChanges.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Header Configuration
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallets, comment: ""))
        // uiSetUp
        uiSetUp()
        // checkWalletDeletion
        self.checkWalletDeletion()
        // backUpOptionTapAction
        self.backUpOptionTapAction()
    }
    // checkWalletDeletion
    func checkWalletDeletion() {
        let walletsList = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
        if (walletsList?.count ?? 0) > 1 {
            self.btnWalletDelete.isHidden = false
        } else {
            self.btnWalletDelete.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtWalletName.textAlignment = .right
        } else {
            txtWalletName.textAlignment = .left
        }
        setView()
    }
    // setView
    fileprivate func setView() {
        let isCloudBackupActive = wallet?.isCloudBackup ?? false
        let isManualBackupActive = wallet?.isManualBackup ?? false
        let isCloudBackup = wallet?.fileName
        
        // lblIcloudActive.text = isCloudBackupActive ? StringConstants.backUpActive : StringConstants.backUpNotActive
        // lblManualActive.text = isManualBackupActive ? StringConstants.backUpActive : StringConstants.backUpNotActive
        lblIcloudActive.text = isCloudBackupActive ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.active, comment: "") : LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.notactive, comment: "")
        lblManualActive.text = isManualBackupActive ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.active, comment: "") : LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.notactive, comment: "")
        lblIcloudActive.textColor = isCloudBackupActive ? .c00C6FB : .c75769D
        lblManualActive.textColor = isManualBackupActive ? .c00C6FB : .c75769D
    }
    // backUpOptionTapAction
    fileprivate func backUpOptionTapAction() {
        /// iCloud Backup Tap Action
        viewiCloud.addTapGesture {
            let isCloudBackupActive = self.wallet?.isCloudBackup ?? false
            if isCloudBackupActive {
                let viewToNavigate = RecoveryPhraseViewController()
                viewToNavigate.wallet = self.wallet
                viewToNavigate.mnemonic = self.wallet?.mnemonic ?? ""
                let mnemonicArray = (self.wallet?.mnemonic ?? "").components(separatedBy: " ")
                for (idx, phrase) in mnemonicArray.enumerated() {
                    viewToNavigate.arrSecretPhrase.append(SecretPhraseDataModel(number: idx + 1, phrase: phrase))
                }
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            } else {
                let viewToNavigate = NameYourBackupViewController()
                viewToNavigate.wallet = self.wallet
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            }
        }
        
        /// Manual Backup Tap Action
        viewManual.addTapGesture {
            if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) != nil {
                guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                guard let viewController = sceneDelegate.window?.rootViewController else { return }
                AppPasscodeHelper().handleAppPasscodeIfNeeded(in: self, completion: { status in
                    if status {
                        let viewToNavigate = BackupWalletViewController()
                        viewToNavigate.wallet = self.wallet
                        self.navigationController?.pushViewController(viewToNavigate, animated: true)
                    }
                })
            } else {
                let viewToNavigate = BackupWalletViewController()
                viewToNavigate.wallet = self.wallet
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            }
        }
    }
  // btnCancelAction
    @IBAction func btnCancelAction(_ sender: Any) {
        txtWalletName.text = ""
        btnCancel.isHidden = true

    }
    
    // MARK: btnDeleteWalletAction
    @IBAction func btnDeleteWalletAction(_ sender: Any) {
        let presentVC = PushNotificationViewController()
        presentVC.modalTransitionStyle = .crossDissolve
        presentVC.modalPresentationStyle = .overFullScreen
        presentVC.alertData = .deleteWallet
        /// Delete wallet action
        presentVC.deleteAction = {
            let walletObject = self.wallet
            let format = "wallet_id == %@"
            let entityName = "Wallets"
            DatabaseHelper.shared.deleteEntity(withFormat: format, entityName: entityName, identifier: walletObject?.wallet_id?.uuidString ?? "")
            self.dismiss(animated: true)
            /// Set primary wallet if user is deleting primary wallet
            self.walletsList = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            for wallet in self.walletsList ?? [] {
                wallet.isPrimary = false
            }
            
            DatabaseHelper.shared.updateData(entityName: "Wallets", predicateFormat: "wallet_id == %@", predicateArgs: [self.walletsList?.first?.wallet_id ?? 0]) { object in
                if let object = object as? Wallets {
                    object.isPrimary = true
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        self.present(presentVC, animated: true)
    }
    // btnSaveChangesAction
    @IBAction func btnSaveChangesAction(_ sender: Any) {
        DatabaseHelper.shared.updateData(entityName: "Wallets", predicateFormat: "wallet_id == %@", predicateArgs: [self.wallet?.wallet_id ?? ""]) { object in
            if let wallet = object as? Wallets {
                wallet.wallet_name = self.txtWalletName.text ?? ""
                self.wallet = wallet
                self.btnSaveChanges.isHidden = true
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Textfield Delegate
extension WalletRecoveryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        btnCancel.isHidden = false
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (txtWalletName.text ?? "") != wallet?.wallet_name ?? "" {
            self.btnSaveChanges.isHidden = false
        } else {
            self.btnSaveChanges.isHidden = true
        }
    }
}
