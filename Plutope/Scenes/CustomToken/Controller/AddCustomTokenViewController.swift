//
//  AddCustomTokenViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import UIKit
import QRScanner
import CoreData
import AVFoundation
class AddCustomTokenViewController: UIViewController {
    
    @IBOutlet weak var btnSelectChain: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewContractAddress: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblChain: UILabel!
    @IBOutlet weak var txtDecimal: customTextField!
    @IBOutlet weak var txtTokenSymbol: customTextField!
    @IBOutlet weak var txtTokenName: customTextField!
    @IBOutlet weak var txtContractAddress: customTextField!
    @IBOutlet weak var viewNetwork: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnWhatIsCustomToken: UIButton!
    @IBOutlet weak var lblWarningAnyoneCan: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var btnPaste: UIButton!
    @IBOutlet weak var lblNetworkText: UILabel!
    @IBOutlet weak var viewWarning: UIView!
    @IBOutlet weak var lblNetworkHead: UILabel!
    var primaryWallet: Wallets?
    lazy var coinDetail: Token? = nil
    weak var enabledTokenDelegate: EnabledTokenDelegate?
    var tokenId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
      
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addcustomtoken, comment: ""))
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), for: .normal)
        self.btnSave.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.save, comment: ""), for: .normal)
//        self.btnWhatIsCustomToken.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.whatiscustomtoken, comment: ""), for: .normal)
        
        let dynamicColor = UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
                }
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.whatiscustomtoken, comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: dynamicColor
                ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)

        // Set the attributed title for the button
        self.btnWhatIsCustomToken.setAttributedTitle(attributedTitle, for: .normal)
        
        self.lblWarningAnyoneCan.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.anyOneCanCreateTokenIncludingFakeVersions, comment: "")
        self.txtDecimal.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokendecimals, comment: "")
        self.txtTokenName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokenname, comment: "")
        self.txtTokenSymbol.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokensymbol, comment: "")
        self.txtContractAddress.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokencontractAddress, comment: "")
        self.lblAdd.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.adddetails, comment: "")
       self.lblNetworkText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.network, comment: "")
        self.btnPaste.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paste, comment: ""), for: .normal)
        setTargetAndView()
        
//        let dynamicRedColor = UIColor { traitCollection in
//            return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 128/255, green: 0/255, blue: 2/255, alpha: 1.0) : UIColor(red: 255/255, green: 0/255, blue: 4/255, alpha: 1.0)
//        }
//        viewWarning.backgroundColor = dynamicRedColor
        
        lblNetworkHead.font = AppFont.violetRegular(16).value
        lblNetworkText.font = AppFont.violetRegular(15).value
        lblAdd.font = AppFont.violetRegular(15).value
        lblWarningAnyoneCan.font = AppFont.regular(12).value
        
        let dynamicRedColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 255/255, green: 0/255, blue: 4/255, alpha: 0.06) // Color for dark mode
                : UIColor(red: 255/255, green: 0/255, blue: 4/255, alpha: 0.06) // Color for light mode
        }

        viewWarning.backgroundColor = dynamicRedColor

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtDecimal.textAlignment = .right
            txtTokenName.textAlignment = .right
            txtTokenSymbol.textAlignment = .right
            txtContractAddress.textAlignment = .right
           // txtContractAddress.leftSpacing = 100
           // txtContractAddress.rightSpacing = 100
        } else {
            txtDecimal.textAlignment = .left
            txtTokenName.textAlignment = .left
            txtTokenSymbol.textAlignment = .left
            txtContractAddress.textAlignment = .left
           // txtContractAddress.leftSpacing = 14
           // txtContractAddress.rightSpacing = 100
        }
    }
    
    /// setTargetAndView
    internal func setTargetAndView() {
        btnSave.alpha = 0.5
        btnSave.isUserInteractionEnabled = false
        txtContractAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtTokenName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtTokenSymbol.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtDecimal.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        ///
        if coinDetail == nil {
            self.coinDetail = (DatabaseHelper.shared.retrieveData("Token") as? [Token])?.filter { $0.chain?.name == "Ethereum" }.first
            self.tokenId = self.coinDetail?.tokenId ?? ""
        }
    }
    
    /// checkIsAvailableInOurDatabase
    internal func checkIsAvailableInOurDatabase() {
        
        /// Will pick the token detail if it is exist in array
        var allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        allToken = allToken?.filter { $0.address?.lowercased() == txtContractAddress.text?.lowercased() && $0.type == coinDetail?.type }
        
        /// Will fill the data automatic if token is already exist
        if allToken?.count != 0 {
            self.coinDetail = allToken?.first
            self.txtTokenName.text = coinDetail?.name ?? ""
            self.txtDecimal.text = "\(coinDetail?.decimals ?? 0)"
            self.txtTokenSymbol.text = coinDetail?.symbol ?? ""
//            self.lblChain.text = coinDetail?.chain?.name ?? ""
            self.lblNetworkText.text = coinDetail?.chain?.name ?? ""
            for textFields in [self.txtTokenName,self.txtDecimal,self.txtTokenSymbol,self.txtContractAddress] {
                textFields?.isUserInteractionEnabled = false
                textFields?.alpha = 0.5
            }
            self.btnSave.alpha = 1
            self.btnSave.isUserInteractionEnabled = true
            self.viewContractAddress.isUserInteractionEnabled = false
            self.btnSelectChain.isUserInteractionEnabled = false
            DGProgressView.shared.hideLoader()
        } else {
            DGProgressView.shared.hideLoader()
        }
    }
    
    /// actionCustomToken
    @IBAction func actionWhatCustomToken(_ sender: Any) {
        HapticFeedback.generate(.light)
        // showWebView(for: URLs.customTokenUrl, onVC: self, title: StringConstants.whatIsCustomToken)
        showWebView(for: URLs.customTokenUrl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.whatiscustomtoken, comment: ""))
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
    @IBAction func actionCancel(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPaste(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtContractAddress.text = ""
        if let copiedText = UIPasteboard.general.string, copiedText.validateContractAddress() {
            DGProgressView.shared.showLoader(to: self.view)
            // Use the copied text here
            txtContractAddress.text = copiedText
            /// check if it contain in our dtatabase
            checkIsAvailableInOurDatabase()
            
        } else {
            self.showToast(message: "Invalid contract address", font: .systemFont(ofSize: 15))
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtContractAddress.text?.validateContractAddress() ?? false {
            
            if viewContractAddress.isUserInteractionEnabled {
                /// Will add custom token first time
                /// Token with the given address does not exist in any wallet, create a new WalletTokens entity
                let walletTokenEntity: WalletTokens
                let walletEntity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
                walletTokenEntity = WalletTokens(entity: walletEntity, insertInto: DatabaseHelper.shared.context)
                walletTokenEntity.id = UUID()
                walletTokenEntity.wallet_id = primaryWallet?.wallet_id
                
                // Create a new Token entity
                let tokenEntity = Token(context: DatabaseHelper.shared.context)
                tokenEntity.address = txtContractAddress.text?.lowercased() ?? ""
                tokenEntity.name = txtTokenName.text ?? ""
                tokenEntity.symbol = txtTokenSymbol.text
                tokenEntity.decimals = Int64(txtDecimal.text ?? "") ?? 0
                var logo = ""
                if coinDetail?.type ?? "" == "ERC20" {
                    logo = "ic_erc"
                } else if coinDetail?.type ?? "" == "BEP20" {
                    logo = "ic_bep"
                } else if coinDetail?.type ?? "" == "POLYGON" {
                    logo = "ic_polygon"
                } else if coinDetail?.type ?? "" == "KIP20" {
                    logo = "ic_kip"
                } else if coinDetail?.type ?? "" == "OP Mainnet" {
                    logo = "ic_op"
                } else if coinDetail?.type ?? "" == "Arbitrum" {
                    logo = "ic_arbitrum"
                } else if coinDetail?.type ?? "" == "Avalanche" {
                    logo = "ic_avalanche"
                } else if coinDetail?.type ?? "" == "Base" {
                    logo = "ic_base"
                }
                print(logo)
                tokenEntity.logoURI = logo
                tokenEntity.type = coinDetail?.type ?? ""
                tokenEntity.balance = "0"
                tokenEntity.price = "0"
                tokenEntity.lastPriceChangeImpact = "0"
                tokenEntity.isEnabled = false
                tokenEntity.tokenId = self.tokenId
                tokenEntity.isUserAdded = true
                
                walletTokenEntity.tokens = tokenEntity
                
                DatabaseHelper.shared.saveData(walletTokenEntity, completion: {_ in
                    let viewToNavigate = CoinDetailViewController()
                    viewToNavigate.coinDetail = tokenEntity
                    viewToNavigate.isCustomAdded = true
                    self.navigationController?.pushViewController(viewToNavigate, animated: true)
                })
                
            } else {
                
                /// will perform if token is already added to the network
                guard let allWalletTokens = DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens] else { return }
                
                if self.containsToken(withAddress: self.coinDetail?.address ?? "", in: allWalletTokens) {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.enabledTokenDelegate?.selectEnabledToken(self.coinDetail!)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                } else {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
                    let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
                    walletTokenEntity.id = UUID()
                    walletTokenEntity.wallet_id = primaryWallet?.wallet_id
                    walletTokenEntity.tokens = self.coinDetail
                    // walletTokenEntity.tokens = self.coinDetail
                    DatabaseHelper.shared.saveData(walletTokenEntity) { status in
                        if status {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true) {
                                    self.enabledTokenDelegate?.selectEnabledToken(self.coinDetail!)
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        } else {
                        }
                    }
                }
            }
        } else {
            self.showToast(message: "Invalid contract address", font: .systemFont(ofSize: 15))
        }
    }
    
    // Assuming walletTokens is an array of WalletTokens objects
    func containsToken(withAddress address: String, in walletTokens: [WalletTokens]) -> Bool {
        return walletTokens.contains { walletToken in
            if let token = walletToken.tokens, token.address == address {
                return true
            }
            return false
        }
    }
    
//    @IBAction func btnScanAction(_ sender: Any) {
//        let scanner = QRScannerViewController()
//        scanner.delegate = self
//        self.present(scanner, animated: true, completion: nil)
//    }
    @IBAction func btnScanAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            DispatchQueue.main.async {
            let scanner = QRScannerViewController()
            scanner.delegate = self
            self.present(scanner, animated: true, completion: nil)
            }
        case .denied, .restricted:
            self.showCameraSettingsAlert()
        case .notDetermined:
            // Request camera permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    let scanner = QRScannerViewController()
                    scanner.delegate = self
                    DispatchQueue.main.async {
                        self.present(scanner, animated: true, completion: nil)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    // showCameraSettingsAlert
    func showCameraSettingsAlert() {
        let alert = UIAlertController(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccessDenied, comment: ""))", message: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccess, comment: ""))", preferredStyle: .alert)
        // Add an action to open the app's settings
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.openSetting, comment: ""))", style: .default, handler: { action in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        // Add a cancel action
        // alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), style: .cancel, handler: nil))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    internal func updateButtonAvailability() {
        let allTextFieldsFilled = areAllTextFieldsFilled()
        btnSave.alpha = allTextFieldsFilled ? 1.0 : 0.5
        btnSave.isUserInteractionEnabled = allTextFieldsFilled
    }
    
    @IBAction func btnSelectChainAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let vcToPresent = BuyCoinListViewController()
        vcToPresent.isFrom = .addCustomToken
        vcToPresent.selectNetworkDelegate = self
        self.navigationController?.pushViewController(vcToPresent, animated: true)
    }
    
    internal func areAllTextFieldsFilled() -> Bool {
        guard let tokenName = txtTokenName?.text,
              let contractAddress = txtContractAddress?.text,
              let tokenSymbol = txtTokenSymbol?.text,
              let decimal = txtDecimal?.text else {
            return false
        }
        
        return !tokenName.isEmpty && !contractAddress.isEmpty && !tokenSymbol.isEmpty && !decimal.isEmpty
    }
    
} 
