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
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourrecoveryphrase, comment: ""), btnBackAction: {
            if self.wallet != nil {
                if let walletRecoveryViewController = self.navigationController?.viewControllers.first(where: { $0 is WalletRecoveryViewController }) {
                    self.navigationController?.popToViewController(walletRecoveryViewController, animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblNeverShare.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nevershareyoursecretphrasewithanyone, comment: "")
        self.btnCopy.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.copy, comment: ""), for: .normal)
        self.lblNeverShareDetail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.neverShareSecretkeyWithAnyone, comment: "")
        
        /// Collection Register
        registerCollection()
        
        setupLongPressGestureRecognizer()
        
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

        self.viewMain.hideContentOnScreenCapture()
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
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        longPressGestureRecognizer.allowableMovement = 10
        longPressGestureRecognizer.minimumPressDuration = 0.5
        blurView.addGestureRecognizer(longPressGestureRecognizer)
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
        
        let viewToNavigate = VerifyRecoveryPhraseViewController()
        viewToNavigate.arrGuessSecretPhrase = self.arrSecretPhrase
        viewToNavigate.mnemonic = self.mnemonic
        viewToNavigate.wallet = self.wallet
        viewToNavigate.arrGuessSecretPhrase.shuffle()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
        
    }
    
    @IBAction func actionDeleteiCloudBackup(_ sender: Any) {
    
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


