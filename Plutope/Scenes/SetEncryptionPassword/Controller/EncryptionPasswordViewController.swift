//
//  EncryptionPasswordViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
//import WalletCore

class EncryptionPasswordViewController: UIViewController, Reusable {
    @IBOutlet weak var btnSetPassword: GradientButton!
    @IBOutlet weak var lblTitlePassword: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var txtPassword: customTextField!
    @IBOutlet weak var lblDoNotLose: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblPasswordRequired: UILabel!
    
    var backUpFileName: String? = ""
    var walletName: String? = ""
    var isRestoreWallet = false
    var wallet: Wallets?
    
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            self.btnSetPassword.HideLoader()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPasswordTitle()
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "")
        
        self.btnSetPassword.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.setencryptionpassword, comment: ""), for: .normal)
        self.lblDoNotLose.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.donotlosethispasswordasplutopecannotresetitforyou, comment: "")
        self.lblTitlePassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.setencryptionpassword, comment: "")
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
    // setPassword title according to restore or manually
    fileprivate func setPasswordTitle() {
        txtPassword.delegate = self
        btnSetPassword.alpha = 0.5
        btnSetPassword.isUserInteractionEnabled = false
        if isRestoreWallet {
            lblTitlePassword.text = StringConstants.enterEncryption
        } else {
            //lblTitlePassword.text = StringConstants.setEncryption
            lblTitlePassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.setencryptionpassword, comment: "")
        }
    }
    
    fileprivate func walletCreation(_ data: MyWallet,_ coinList: [CoingechoCoinList]?) {
        WalletData.shared.createWallet(walletName: self.walletName ?? "", mnemonicKey: WalletData.shared.mnemonic, isPrimary: true, isICloudBackup: true, isManualBackup: false,coinList: coinList, iCloudFileName: self.backUpFileName) { status in
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.btnSetPassword.HideLoader()
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
                }

            } else {
                self.btnSetPassword.HideLoader()
            }
        }
    }
    
    @IBAction func actionSetEncryptionPassword(_ sender: Any) {

        if txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            self.showToast(message: ToastMessages.passwordRequired, font: .systemFont(ofSize: 15))
        } else {

            if isRestoreWallet {

                btnSetPassword.ShowLoader()

                BackupWallet.shared.restoreWallet(fromFile: backUpFileName ?? "", password: txtPassword.text ?? "") { result in
                    switch result {
                    case .success(let data):
                        print(data)

                        /// Will check that wallet exists or not and then create/import wallet
                        let wallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
                        if wallets?.contains(where: { $0.mnemonic == WalletData.shared.mnemonic }) == true {
                            self.showToast(message: ToastMessages.alreadyExists, font: AppFont.regular(15).value)
                            self.txtPassword.text = ""
                            self.btnSetPassword.HideLoader()
                        } else {

                            if DatabaseHelper.shared.entityIsEmpty("Token") {
                                self.viewModel.apiCoinList { status, _, coinList in
                                    if status {
                                      //  self.walletCreation(data,coinList ?? [])
                                    } else {
                                        self.btnSetPassword.HideLoader()
                                    }
                                }
                            } else {
                              //  self.walletCreation(data,[])
                            }
                        }

                    case .failure(let error):
                        self.btnSetPassword.HideLoader()
                        self.showToast(message: ToastMessages.incorrectPassword, font: AppFont.regular(15).value)
                        print(error)
                    }
                }

            } else {
                if wallet != nil {
                    let viewToNavigate = ConfirmEncryptionPasscodeViewController()
                    viewToNavigate.confirmPassword = txtPassword.text ?? ""
                    viewToNavigate.fileName = self.backUpFileName ?? ""
                    viewToNavigate.wallet = self.wallet
                    self.navigationController?.pushViewController(viewToNavigate, animated: true)

                } else {
                    let viewToNavigate = PhraseInstructionViewController()
                    viewToNavigate.delegate = self
                    viewToNavigate.modalTransitionStyle = .crossDissolve
                    viewToNavigate.modalPresentationStyle = .fullScreen
                    self.present(viewToNavigate, animated: true)
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
    
}
// MARK: PushViewControllerDelegate
// Dismiss presented screen and push forward
extension EncryptionPasswordViewController: PushViewControllerDelegate {
    
    func pushViewController(_ controller: UIViewController) {
        if let viewToNavigate = controller as? ConfirmEncryptionPasscodeViewController {
            viewToNavigate.confirmPassword = txtPassword.text ?? ""
            viewToNavigate.fileName = self.backUpFileName ?? ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: UITextFieldDelegate
extension EncryptionPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.validatePassword() {
            btnSetPassword.alpha = 1
            btnSetPassword.isUserInteractionEnabled = true
        } else {
            btnSetPassword.alpha = 0.5
            btnSetPassword.isUserInteractionEnabled = false
        }
    }
}
