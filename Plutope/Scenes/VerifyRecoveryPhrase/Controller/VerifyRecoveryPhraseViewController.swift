//
//  VerifyRecoveryPhraseViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
//import CloudKit

class VerifyRecoveryPhraseViewController: UIViewController, Reusable {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clvVerifyPhrase: UICollectionView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnDone: GradientButton!
    @IBOutlet weak var clvGuessCorrectPhrase: UICollectionView!
    @IBOutlet weak var lblTapTheWords: UILabel!
    
    @IBOutlet weak var lblMsg: UILabel!
    var wallet: Wallets?
    var mnemonic: String?
    var arrSecretPhrase: [SecretPhraseDataModel] = []
    var arrGuessSecretPhrase: [SecretPhraseDataModel] = []
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            self.btnDone.HideLoader()
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
           // self.btnDone.HideLoader()
        }
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        self.lblTapTheWords.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tapthewordstoputthemnexttoeachotherinthecorrectorder, comment: "")
        self.lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tapthewordstoputthemnexttoeachotherinthecorrectorder, comment: "")
        self.btnDone.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.done, comment: ""), for: .normal)
        registerCollectionViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureClvVerifyPhraseAppearance()
    }
    
    fileprivate func walletCreation(_ coinList: [CoingechoCoinList]?,alreadyAddStaticToken:Bool) {
        if wallet == nil {
            let walletCount = (DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] ?? []).count + 1
            WalletData.shared.createWallet(walletName: "Main Wallet \(walletCount)" , mnemonicKey: mnemonic, isPrimary: true, isICloudBackup: false, isManualBackup: true,coinList: coinList,alreadyAddStaticToken: alreadyAddStaticToken) { status in
                self.btnDone.HideLoader()
                if status {
                    guard let fcmtoken = UserDefaults.standard.object(forKey: "fcm_Token") as? String else {
                        return
                    }
                    self.viewModel.checkTokenVersion { status, msg, data in
                        if status == 1 {
                            UserDefaults.standard.set(data?.tokenString, forKey: DefaultsKey.tokenString)
                        }
                    }
                    
                    var deviceId = ""
                    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                       print("Device ID: \(uuid)")
                        deviceId = uuid
                    } else {
                       print("Unable to retrieve device ID.")
                    }
                    UserDefaults.standard.setValue(true, forKey: DefaultsKey.isTransactionSignin)
                    
                    print("isTransactionSignin",UserDefaults.standard.string(forKey: DefaultsKey.isTransactionSignin) ?? false)
                    self.registerUserViewModel.registerAPI(walletAddress: WalletData.shared.myWallet?.address ?? "", appType: 1,deviceId: deviceId,fcmToken: fcmtoken, type: "create", referralCode: "") { resStatus, message in
                      //  if resStatus == 1 {
                            if !(UserDefaults.standard.object(forKey: DefaultsKey.homeButtonTip) as? Bool ?? false) {

                                let viewToNavigate = WelcomeViewController()
                                self.navigationController?.pushViewController(viewToNavigate, animated: true)
                               
                            } else {
                                guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                                                      
                                                      let tabBarVC = TabBarViewController(interactor: appDelegate.interactor, app: appDelegate.app, configurationService: appDelegate.app.configurationService)
                                                      window?.rootViewController = tabBarVC
                                                      window?.makeKeyAndVisible()
                            }
//                        } else {
//                            print("wallet not register")
//                        } // resstatus if condition end
                    }
                }
            }
        } else {
            DatabaseHelper.shared.updateData(entityName: "Wallets", predicateFormat: "wallet_id == %@", predicateArgs: [wallet?.wallet_id ?? ""]) { object in
                if let wallet = object as? Wallets {
                    wallet.isManualBackup = true
                    if let walletRecoveryViewController = self.navigationController?.viewControllers.first(where: { $0 is WalletRecoveryViewController }) {
                        self.navigationController?.popToViewController(walletRecoveryViewController, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        HapticFeedback.generate(.light)
        if DatabaseHelper.shared.entityIsEmpty("Token") {
            self.btnDone.ShowLoader()
            viewModel.apiCoinList { status, _, coinList in
                if status {
                    guard var coinListD = coinList else { return } // Unwrap optional and make it mutable

                       // Remove items where symbol == "bnry"
                    coinListD.removeAll { $0.symbol == "bnry" }
                    self.walletCreation(coinListD, alreadyAddStaticToken: false)
                } else {
                    self.btnDone.HideLoader()
                }
            }
        } else {
            walletCreation([], alreadyAddStaticToken: true)
        }
    }
    
    /// Header setup
    private func setupHeaderView() {
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.verifySecretPhrase, comment: ""))
        btnDone.alpha = 0.5
        btnDone.isEnabled = false
    }
    
    /// Collection Register
    private func registerCollectionViews() {
        clvVerifyPhrase.register(PhraseViewCell.nib, forCellWithReuseIdentifier: PhraseViewCell.reuseIdentifier)
        clvVerifyPhrase.delegate = self
        clvVerifyPhrase.dataSource = self
        
        clvGuessCorrectPhrase.register(PhraseViewCell.nib, forCellWithReuseIdentifier: PhraseViewCell.reuseIdentifier)
        clvGuessCorrectPhrase.delegate = self
        clvGuessCorrectPhrase.dataSource = self
    }
    
    /// Collection appearance
    private func configureClvVerifyPhraseAppearance() {
        clvVerifyPhrase.layer.borderWidth = 1
        clvVerifyPhrase.layer.shadowOffset = CGSize(width: 0, height: 3)
        clvVerifyPhrase.layer.shadowOpacity = 1
        clvVerifyPhrase.layer.shadowRadius = 17
        clvVerifyPhrase.layer.shadowColor = UIColor.cDF71E229.cgColor
    }
    
}
