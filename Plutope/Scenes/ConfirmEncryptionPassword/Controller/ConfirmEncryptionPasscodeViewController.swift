//
//  ConfirmEncryptionPasscodeViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import CGWallet
//import WalletCore
class ConfirmEncryptionPasscodeViewController: UIViewController, Reusable {
    @IBOutlet weak var tbvInstruction: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtPassword: customTextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnConfirm: GradientButton!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblPasswordRequired: UILabel!
    @IBOutlet weak var lblConfirmEncryptionPassword: UILabel!
   
    var arrWarnings: [WarningModel] = [
        WarningModel(isChecked: false, warning: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.iflosemysecretphrasemyfundswillbelostforever, comment: "")),
        WarningModel(isChecked: false, warning: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ifexposeorsharemysecretphrasetoanybodymyfundscangetstolen, comment: ""))
    ]
    
    var confirmPassword: String? = ""
    var fileName: String? = ""
    var wallet: Wallets?
    
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            self.btnConfirm.HideLoader()
        }
    }()
    
    fileprivate func uiSetUp() {
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        self.lblConfirmEncryptionPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmencryptionpassword, comment: "")
        self.lblPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.password, comment: "")
        self.lblPasswordRequired.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.atleast8CharacterIncludinGoneUpperCaseletter, comment: "")
       
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtPassword.textAlignment = .right
              
            } else {
                txtPassword.textAlignment = .left
               
            }
            
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "")
        
        uiSetUp()
       
        /// Tableview Register
        tableRegister()
    }
    fileprivate func walletCreation(_ walletForBackup: MyWallet, _ mnemonicKey: String,_ coinList: [CoingechoCoinList]) {
        var recoverWalletForBackup = MyWallet(address: "", privateKey: "")
        if self.wallet != nil {
           
            let coinType: CoinType = .bitcoin
            if coinType == .bitcoin {
                guard let walletForBackup =  WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(wallet?.mnemonic ?? "" , WalletData.shared.chainBTC, nil)) else { return  }
                recoverWalletForBackup = walletForBackup
                
            } else {
                guard let walletForBackup =  WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(wallet?.mnemonic ?? "" , WalletData.shared.chainETH, nil)) else { return  }
                recoverWalletForBackup = walletForBackup
                }
            
            
//            guard let recoverWalletForBackup = HDWallet(mnemonic: wallet?.mnemonic ?? "", passphrase: "") else { return }
            BackupWallet.shared.backupWallet(wallet: recoverWalletForBackup, password: txtPassword.text ?? "", fileName: fileName ?? "") { error in
                if error == nil {
                    DatabaseHelper.shared.updateData(entityName: "Wallets", predicateFormat: "wallet_id == %@", predicateArgs: [self.wallet?.wallet_id ?? ""]) { object in
                        if let wallet = object as? Wallets {
                            wallet.isCloudBackup = true
                            wallet.fileName = self.fileName
                            if let walletRecoveryViewController = self.navigationController?.viewControllers.first(where: { $0 is WalletRecoveryViewController }) {
                                self.navigationController?.popToViewController(walletRecoveryViewController, animated: true)
                            }
                        }
                    }
                } else {
                    self.showICloudPopup()
                }
                self.btnConfirm.HideLoader()
            }
        } else {
            BackupWallet.shared.backupWallet(wallet: walletForBackup, password: txtPassword.text ?? "", fileName: fileName ?? "") { error in

                if error == nil {

                    WalletData.shared.createWallet(walletName: self.fileName ?? "" , mnemonicKey: mnemonicKey, isPrimary: true, isICloudBackup: true, isManualBackup: false, coinList: coinList, iCloudFileName: self.fileName) { status in
                        if status {
                            if !(UserDefaults.standard.object(forKey: DefaultsKey.homeButtonTip) as? Bool ?? false) {
                                let viewToNavigate = WelcomeViewController()
                                self.navigationController?.pushViewController(viewToNavigate, animated: true)
                            } else {
                                guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                                let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
                                guard let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
                                appDelegate.window?.makeKeyAndVisible()
                                appDelegate.window?.rootViewController = tabBarVC
                            }
                        } else {

                        }

                    }
                    self.btnConfirm.HideLoader()
                } else {
                    self.btnConfirm.HideLoader()
                    self.showICloudPopup()
                }
            }
        }
    }

    @IBAction func actionConfirm(_ sender: Any) {
        
        if txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            self.showToast(message: "Please enter confirm encryption password", font: .systemFont(ofSize: 15))
        } else if txtPassword.text != confirmPassword {
            showToast(message: StringConstants.confirmPasscodeErrorMessage , font: .systemFont(ofSize: 15))
            
        } else {
            var mnemonic = CGWalletGenerateMnemonic(12)
            var walletForBackup = MyWallet(address: "", privateKey: "")
             let mnemonicKey = mnemonic
            
            let coinType: CoinType = .bitcoin
            if coinType == .bitcoin {
                guard let wallet =  WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic , WalletData.shared.chainBTC, nil)) else { return  }
                walletForBackup = wallet
              
            } else {
                guard let wallet =  WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic , WalletData.shared.chainETH, nil)) else { return  }
                walletForBackup = wallet
                }
          //  guard let walletForBackup = HDWallet(mnemonic: mnemonicKey, passphrase: "") else { return }
            
            /// Will check that wallet exists or not and then create/import wallet
            let wallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            if wallets?.contains(where: { $0.mnemonic == mnemonicKey }) == true {
                showToast(message: ToastMessages.alreadyExists, font: AppFont.regular(15).value)
            } else {
                if DatabaseHelper.shared.entityIsEmpty("Token") {
                    self.btnConfirm.ShowLoader()
                    viewModel.apiCoinList { status, _,coinList in
                        if status {
                            self.walletCreation(walletForBackup, mnemonicKey,coinList ?? [])
                        } else {
                            self.btnConfirm.HideLoader()
                        }
                    }
                } else {
                    walletCreation(walletForBackup, mnemonicKey,[])
                }
            }
        }
    }
    
    @IBAction func actionEye(_ sender: Any) {
        
        txtPassword.isSecureTextEntry.toggle()
        
        if !txtPassword.isSecureTextEntry {
            btnEye.setImage(UIImage.eye, for: .normal)
        } else {
            btnEye.setImage(UIImage.closeEye, for: .normal)
        }
        
    }
    func tableRegister() {
        tbvInstruction.delegate = self
        tbvInstruction.dataSource = self
        tbvInstruction.register(UINib(nibName: "WarningViewCell", bundle: nil), forCellReuseIdentifier: "WarningViewCell")
    }
}
