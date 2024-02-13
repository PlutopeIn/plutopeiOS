//
//  ImportWalletViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 19/06/23.
//
import UIKit
class ImportWalletViewController: UIViewController {
    @IBOutlet weak var txtWalletName: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtViewPhrase: PlaceholderTextView!
    @IBOutlet weak var lblTypically: UILabel!
    @IBOutlet weak var btnPaste: UIButton!
    @IBOutlet weak var btnWhatIsSecretPhase: UIButton!
    @IBOutlet weak var btnImport: GradientButton!
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
           // self.btnDone.HideLoader()
        }
    }()

    fileprivate func uiSetUp() {
        self.txtWalletName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.mainwallet, comment: "")
        self.lblTypically.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.typically12sometimes1824wordsseparatedbysinglespaces, comment: "")
        self.btnPaste.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paste, comment: ""), for: .normal)
        self.btnImport.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.imports, comment: ""), for: .normal)
        self.btnWhatIsSecretPhase.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.whatIsSecretPhrase, comment: ""), for: .normal)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtViewPhrase.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phrase, comment: "")
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtViewPhrase.textAlignment = .right
            txtWalletName.textAlignment = .right
        } else {
            txtViewPhrase.textAlignment = .left
            txtWalletName.textAlignment = .left
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
        //defineHeader(headerView: headerView, titleText: StringConstants.importMulticoinWalet)
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.importmulticoinwallet, comment: ""))
        // uiSetUp
        uiSetUp()
    }
    @IBAction func actionPaste(_ sender: Any) {
        
        if let copiedText = UIPasteboard.general.string {
            // Use the copied text here
            txtViewPhrase.text = copiedText
        }
        
    }
    
    fileprivate func walletCreation(_ coinList: [CoingechoCoinList]?,_ modifiedPhrase: String) {
        WalletData.shared.createWallet(walletName: self.txtWalletName.text ?? "", mnemonicKey: modifiedPhrase, isPrimary: true, isICloudBackup: false, isManualBackup: true,coinList: coinList) { success in
            if success {
                /// Root redirection, coinList:
                ///
                self.btnImport.HideLoader()
                guard let fcmtoken = UserDefaults.standard.object(forKey: "fcm_Token") as? String else {
                    return
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
                self.registerUserViewModel.registerAPI(walletAddress: WalletData.shared.myWallet?.address ?? "", appType: 1,deviceId: deviceId,fcmToken: fcmtoken) { resStatus, message in
                    //if resStatus == 1 {
                       
//                    } else {
//                        print("wallet not register")
//                    } // resstatus if condition end
                    
                }
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
                
//                if !(UserDefaults.standard.object(forKey: DefaultsKey.homeButtonTip) as? Bool ?? false) {
//                    let viewToNavigate = WelcomeViewController()
//                    self.navigationController?.pushViewController(viewToNavigate, animated: true)
//                    self.btnImport.HideLoader()
//                } else {
//                    guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//                    let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
//                    guard let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
//                    appDelegate.window?.makeKeyAndVisible()
//                    appDelegate.window?.rootViewController = tabBarVC
//                }
            } else {
                self.showToast(message: ToastMessages.invalidPhrase, font: UIFont.systemFont(ofSize: 15))
                self.btnImport.HideLoader()
            }
        }
    }
    
    @IBAction func actionImport(_ sender: Any) {
        
        guard let phrases = txtViewPhrase.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phrases.isEmpty else {
            showToast(message: ToastMessages.phraseError, font: AppFont.regular(15).value)
            return
        }
        
        let regex = try? NSRegularExpression(pattern: "\\s{2,}", options: .caseInsensitive)
        let modifiedPhrase = regex?.stringByReplacingMatches(in: phrases, options: [], range: NSMakeRange(0, phrases.count), withTemplate: " ")
        
        /// Will check that wallet exists or not and then create/import wallet
        let wallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
        if wallets?.contains(where: { $0.mnemonic == modifiedPhrase }) == true {
            showToast(message: ToastMessages.alreadyExists, font: AppFont.regular(15).value)
            txtViewPhrase.text = ""
        } else {
            self.btnImport.ShowLoader()
            if DatabaseHelper.shared.entityIsEmpty("Token") {
                viewModel.apiCoinList { status, _, coinList in
                    if status {
                        self.walletCreation(coinList,modifiedPhrase ?? "")
                    } else {
                        self.btnImport.HideLoader()
                    }
                }
            } else {
                self.walletCreation(nil, modifiedPhrase ?? "")
            }
        }
    }
    
    @IBAction func actionSecretPhrase(_ sender: Any) {
        showWebView(for: URLs.secretPhraseUrl, onVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.whatIsSecretPhrase, comment: ""))
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
    }
}

class PlaceholderTextView: UITextView {
    private let placeholderLabel = UILabel()
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        placeholderLabel.font = AppFont.regular(12).value
        placeholderLabel.textColor = UIColor.c75769D
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}
