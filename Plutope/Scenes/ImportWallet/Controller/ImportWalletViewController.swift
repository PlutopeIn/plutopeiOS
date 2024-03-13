//
//  ImportWalletViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 19/06/23.
//
import UIKit
import CoreData
import IQKeyboardManagerSwift
class ImportWalletViewController: UIViewController {
    @IBOutlet weak var txtWalletName: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtViewPhrase: PlaceholderTextView!
    @IBOutlet weak var lblTypically: UILabel!
    @IBOutlet weak var btnPaste: UIButton!
    @IBOutlet weak var btnWhatIsSecretPhase: UIButton!
    @IBOutlet weak var btnImport: GradientButton!
    var primaryWallet: Wallets?
    var tokensList: [Token]? = []
    var filterTokens: [Token]? = []
    var activeToken: [ActiveTokens]? = []
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    lazy var tokenListViewModel: TokenListViewModel = {
        TokenListViewModel { status,message in
            if status == false {
                //  self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    lazy var coinGraphViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            //  self.showToast(message: message, font: .systemFont(ofSize: 15))
            DGProgressView.shared.hide()
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            //            self.showToast(message: message, font: .systemFont(ofSize: 15))
            // self.btnDone.HideLoader()
        }
    }()
    
    fileprivate func uiSetUp() {
        self.txtWalletName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.mainwallet, comment: "")
        self.lblTypically.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.typically12sometimes1824wordsseparatedbysinglespaces, comment: "")
        self.btnPaste.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paste, comment: ""), for: .normal)
        self.btnImport.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.imports, comment: ""), for: .normal)
        self.btnWhatIsSecretPhase.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.whatIsSecretPhrase, comment: ""), for: .normal)
        txtViewPhrase.delegate = self
        
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
    func getActiveTokens(walletAddress : String){
        tokenListViewModel.apiGetActiveTokens(walletAddress: walletAddress) { data, status in
            self.activeToken = data
            //            print("Active token",self.activeToken)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
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
    
    fileprivate func activeTokenList() {
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        // Iterate over tokens and set balance to zero
        self.tokensList?.forEach { $0.balance = "0" }
        if let tokensList = self.tokensList, let activeTokens = self.activeToken {
            for enableToken in activeTokens {
            
                let token1 =  self.tokensList?.first(where: { $0.address == enableToken.tokenAddress })
                let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
                let enableTokens = getPrimaryWalletToken?.compactMap { $0.tokens  }
                let alreadyEnabled = enableTokens?.first(where: { $0.address == enableToken.tokenAddress })
                if(alreadyEnabled == nil ){
                    
                    let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
                    let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
                    walletTokenEntity.id = UUID()
                    walletTokenEntity.wallet_id = self.primaryWallet?.wallet_id
                    walletTokenEntity.tokens = token1
                    DatabaseHelper.shared.saveData(walletTokenEntity) { status in
                        if status {
                            print("true")
                        }
                    }
                }
                
            }
        }
    }
    
    fileprivate func walletCreation(_ coinList: [CoingechoCoinList]?,_ modifiedPhrase: String) {
        WalletData.shared.createWallet(walletName: self.txtWalletName.text ?? "", mnemonicKey: modifiedPhrase, isPrimary: true, isICloudBackup: false, isManualBackup: true,coinList: coinList) { success in
            if success {
                
                if self.primaryWallet == nil {
                              let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
                              self.primaryWallet = allWallet?.first(where: { $0.isPrimary })
                             
                          }
                          guard let primaryWallet = self.primaryWallet else {
                              // Handle the case when primaryWalletID is nil
                              return
                          }
                /// Root redirection, coinList:
                
                self.tokenListViewModel.apiGetActiveTokens(walletAddress: WalletData.shared.myWallet?.address ?? "" ) { data, status in
                    self.activeToken = data
                  self.activeTokenList()
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
                        if resStatus == 1 {
                            self.showToast(message: message, font: .systemFont(ofSize: 15))
                            print("wallet register")
                        } else {
                            print("wallet not register")
                        } // resstatus if condition end
                        
                    }
                    self.btnImport.HideLoader()
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
        placeholderLabel.font = AppFont.regular(15).value
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
struct TokenPair: Hashable {
    let tokenAddress1: String
    let tokenAddress2: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tokenAddress1)
        hasher.combine(tokenAddress2)
    }
    
    static func == (lhs: TokenPair, rhs: TokenPair) -> Bool {
        return lhs.tokenAddress1 == rhs.tokenAddress1 && lhs.tokenAddress2 == rhs.tokenAddress2
    }
}

extension ImportWalletViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
    func textViewDidChange(_ textView: UITextView) {
            guard let text = textView.text else {
                return
            }

            let newText = (text as NSString).replacingCharacters(in: NSRange(location: 0, length: text.utf16.count), with: text.lowercased())
            textView.text = newText
        }
}
