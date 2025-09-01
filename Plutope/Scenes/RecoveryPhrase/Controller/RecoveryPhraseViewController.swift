//
//  RecoveryPhraseViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
import Security
import CloudKit

class RecoveryPhraseViewController: UIViewController, Reusable {
    
    @IBOutlet weak var lblReferalCode: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackSecretKey: UIStackView!
    @IBOutlet weak var btnDeleteBackup: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHideShowPhrase: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clvPhrase: UICollectionView!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var lblHideshow: UILabel!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var lblNeverShare: UILabel!
    @IBOutlet weak var lblNeverShareDetail: UILabel!
   
    var mnemonic: String? = ""
    var arrSecretPhrase: [SecretPhraseDataModel] = []
    var wallet: Wallets?
    var isFrom: BackupFrom = .wallets
    private var holdTimer: Timer?
    
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
//            self.btnContinue.HideLoader()
            DGProgressView.shared.hideLoader()
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
           // self.btnDone.HideLoader()
            DGProgressView.shared.hideLoader()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        /*defineHeader(headerView: headerView, titleText: StringConstants.recoveryPhrase, btnBackAction: {
            if self.wallet != nil {
                if let walletRecoveryViewController = self.navigationController?.viewControllers.first(where: { $0 is WalletRecoveryViewController }) {
                    self.navigationController?.popToViewController(walletRecoveryViewController, animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })*/
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selectPhrase, comment: ""), btnBackAction: {
            if self.wallet != nil {
                if let walletRecoveryViewController = self.navigationController?.viewControllers.first(where: { $0 is WalletRecoveryViewController }) {
                    self.navigationController?.popToViewController(walletRecoveryViewController, animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
       
//        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")
                let font = AppFont.violetRegular(18).value
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font
                ]

                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        self.lblNeverShare.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nevershareyoursecretphrasewithanyone, comment: "")
        self.btnCopy.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.copy, comment: ""), for: .normal)
        self.lblNeverShareDetail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.neverShareSecretkeyWithAnyone, comment: "")
        
        /// Collection Register
        registerCollection()
        
//        setupLongPressGestureRecognizer()
        
        stackSecretKey.addTapGesture {
            let viewToNavigate = SecretPharseInfoPopUpViewController()
           // viewToNavigate.delegate = self
            viewToNavigate.modalTransitionStyle = .coverVertical
            viewToNavigate.modalPresentationStyle = .overFullScreen
            self.present(viewToNavigate, animated: true)
        }
        if let wallet = wallet {
            if isFrom == .manual {
                if wallet.isManualBackup == false {
                    self.btnContinue.isHidden = false
                    self.btnCopy.isHidden = false
                } else {
                    self.btnContinue.isHidden = true
                    self.btnCopy.isHidden = true
                }
                self.btnDeleteBackup.isHidden = true
            } else {
                self.btnContinue.isHidden = true
                self.btnCopy.isHidden = true
                self.btnDeleteBackup.isHidden = false
            }
        }

      //  self.viewMain.hideContentOnScreenCapture()
        lblNeverShare.font = AppFont.regular(11.98).value
        lblHideshow.font = AppFont.violetRegular(14).value
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
        clvPhrase.layer.borderWidth = 1
        clvPhrase.layer.shadowOffset = CGSize(width: 0, height: 3)
        clvPhrase.layer.shadowOpacity = 1
        clvPhrase.layer.shadowRadius = 17
        clvPhrase.layer.shadowColor = UIColor.cDF71E229.cgColor
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let referralCode = UserDefaults.standard.string(forKey: "referralCode") {
            
            NSLog("referralCode: %@", referralCode)
           // self.lblReferalCode.text = "\(referralCode)"
        }
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        longPressGestureRecognizer.allowableMovement = 10
        longPressGestureRecognizer.minimumPressDuration = 0.5
        blurView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    fileprivate func walletCreation(_ coinList: [CoingechoCoinList]?,alreadyAddStaticToken:Bool) {
        if wallet == nil {
            let walletCount = (DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] ?? []).count + 1
            print("walletCount =",walletCount)
            var walletName = ""
            if walletCount >= 0 {
                walletName = "Main Wallet \(walletCount)"
            } else {
                walletName = "Main Wallet"
            }
            WalletData.shared.createWallet(walletName: walletName , mnemonicKey: mnemonic, isPrimary: true, isICloudBackup: false, isManualBackup: true,coinList: coinList,alreadyAddStaticToken: alreadyAddStaticToken) { status in

                DGProgressView.shared.hideLoader()
                if status {
                    let fcmtoken = UserDefaults.standard.object(forKey: "fcm_Token") as? String ?? ""
                    
                    var deviceId = ""
                    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                       print("Device ID: \(uuid)")
                        deviceId = uuid
                    } else {
                       print("Unable to retrieve device ID.")
                    }
                    UserDefaults.standard.setValue(true, forKey: DefaultsKey.isTransactionSignin)
                    
                    print("isTransactionSignin",UserDefaults.standard.string(forKey: DefaultsKey.isTransactionSignin) ?? false)
                 
                    self.registerUserViewModel.registerAPI(walletAddress: WalletData.shared.myWallet?.address ?? "", appType: 1,deviceId: deviceId,fcmToken: fcmtoken, type: "create", referralCode:self.lblReferalCode.text ?? "" ) { resStatus, message in
                        
                        UserDefaults.standard.removeObject(forKey: "referralCode")
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
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            blurView.isHidden = true
            lblHideshow.isHidden = true
            startHoldTimer()
        case .ended, .cancelled, .failed:
            lblHideshow.isHidden = false
            blurView.isHidden = false
            cancelHoldTimer()
        default:
            break
        }
    }
    
    private func startHoldTimer() {
        holdTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.blurView.isHidden = true
        }
    }
    
    private func cancelHoldTimer() {
        holdTimer?.invalidate()
    }
    
    /// Collection Register
    func registerCollection() {
        clvPhrase.delegate = self
        clvPhrase.dataSource = self
        clvPhrase.register(PhraseViewCell.nib, forCellWithReuseIdentifier: PhraseViewCell.reuseIdentifier)
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        HapticFeedback.generate(.light)
       /* let viewToNavigate = VerifyRecoveryPhraseViewController()
        viewToNavigate.arrGuessSecretPhrase = self.arrSecretPhrase
        viewToNavigate.mnemonic = self.mnemonic
        viewToNavigate.wallet = self.wallet
        viewToNavigate.arrGuessSecretPhrase.shuffle()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)*/
        
        if DatabaseHelper.shared.entityIsEmpty("Token") {
//            self.btnContinue.ShowLoader()
            DGProgressView.shared.showLoader(to: view)
            viewModel.apiCoinList { status, _, coinList in
                if status {
                    guard var coinListD = coinList else { return } // Unwrap optional and make it mutable

                       // Remove items where symbol == "bnry"
                    coinListD.removeAll { $0.symbol == "bnry" }
                    self.walletCreation(coinListD, alreadyAddStaticToken: false)
                } else {
//                    self.btnContinue.HideLoader()
                    DGProgressView.shared.hideLoader()
                }
            }
        } else {
            walletCreation([], alreadyAddStaticToken: true)
        }
        
    }
    @IBAction func actionDeleteiCloudBackup(_ sender: Any) {
        HapticFeedback.generate(.light)
        guard let iCloudContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            let error = NSError(domain: "com.trustwallet.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get iCloud container URL"])
            self.showICloudPopup()
            return
        }

        let fileName = (wallet?.fileName ?? "") + ".json"
        let jsonFilePath = iCloudContainerURL.appendingPathComponent(fileName)

        if let isManualBackup = self.wallet?.isManualBackup, isManualBackup {
            let alert = PushNotificationViewController()
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen
            alert.alertData = .deleteIcloud
            alert.deleteAction = {
                /// Delete iCloud Backup
                BackupWallet.shared.deleteFile(atPath: jsonFilePath) { error in
                    self.dismiss(animated: true)
                    if let err = error {
                        self.showToast(message: "File not found", font: AppFont.regular(15).value)
                    } else {
                        if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) != nil {
                            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: self, completion: { status in
                                if status {
                                    self.handlePasscodeAnndNavigate()
                                }
                            })
                        } else {
                            self.handlePasscodeAnndNavigate()
                        }
                    }
                    print("DEBUG: iCloud backup deleted successfully")
                }
            }
            self.present(alert, animated: true)
        } else {
            /// Ask to take manual backup first
            let alert = PushNotificationViewController()
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen
            alert.alertData = .manualBackupWarning
            self.present(alert, animated: true)

            /// Go for manual backup
            alert.deleteAction = {
                self.dismiss(animated: true)
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
        
    }
    
    @IBAction func actionCopy(_ sender: Any) {
        /// Copy recovery phrase to the clipboard
        HapticFeedback.generate(.light)
        UIPasteboard.general.string = arrSecretPhrase.map({ $0.phrase }).joined(separator: " ")
        showToast(message: StringConstants.copied, font: AppFont.regular(15).value)
    }
    
    internal func handlePasscodeAnndNavigate() {
        guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else {
            return
        }
        guard let viewController = sceneDelegate.window?.rootViewController else {
            return
        }
        
        DatabaseHelper.shared.updateData(entityName: "Wallets", predicateFormat: "wallet_id == %@", predicateArgs: [self.wallet?.wallet_id ?? 0]) { object in
            if let wallet = object as? Wallets {
                wallet.isCloudBackup = false
                wallet.fileName = ""
                self.showToast(message: "icloud backup deleted successfully.", font: AppFont.regular(15).value)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
