//
//  WalletDashboardViewController.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//

import UIKit
import CoreData
import SwiftUI
import MaterialShowcase
import CGWallet
import CryptoSwift
import QRScanner
import AVFoundation
import Combine
// import WalletConnectSign
import ReownWalletKit
// import Auth
class WalletDashboardViewController: UIViewController, Reusable ,UINavigationControllerDelegate {
    
    @IBOutlet weak var btnAddCustomToken: UIButton!
    @IBOutlet weak var clvNftHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var clvActions: UICollectionView!
    @IBOutlet weak var btnScan: DesignableButton!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnSearch: DesignableButton!
    @IBOutlet weak var btnPlutoPe: DesignableButton!
    @IBOutlet weak var mainScrollview: UIScrollView!
    @IBOutlet weak var ivCopyWalletAddress: UIImageView!
    @IBOutlet weak var lblWalletAddress: UILabel!
    @IBOutlet weak var ringView: UIView!
    @IBOutlet weak var constClvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCurruntWalletName: UILabel!
    @IBOutlet weak var lblMainBal: UILabel!
    @IBOutlet weak var btnShowHideBal: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var tbvAssets: UITableView!
    @IBOutlet weak var clvNFTs: UICollectionView!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    @IBOutlet weak var viewNullNFT: UIView!
    @IBOutlet weak var scrollViewNft: UIScrollView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var lblLearnMore: UILabel!
    @IBOutlet weak var lblNoNFTS: UILabel!
    @IBOutlet weak var btnReceiveNFTS: UIButton!
    @IBOutlet weak var btnReceive: UIButton!
    @IBOutlet weak var viewBalanceTop: UIView!
    
    @IBOutlet weak var btnAssets: UIButton!
    @IBOutlet weak var btnNFTs: UIButton!
    
    @IBOutlet weak var imgSend: UIImageView!
    @IBOutlet weak var imgReceive: UIImageView!
    
    @IBOutlet weak var vwCopyWalletAdd: UIView!
    var viewControllerToPresent: UIViewController?
    weak var delegate: PushViewControllerDelegate?
    let coinListVC = BuyCoinListViewController()
    var sendAddress = ""
    var sendCoinQuantity = ""
    var coinType = ""
    var primaryWalletName = ""
    var ethPrice: Double = 0.0
    var ethPriceChange: Double = 0.0
    var ethLogoURI = ""
    var ethSymbol = ""
    var sceneDelegate: SceneDelegate?
    var isFromUpdate = false
    lazy var viewModel: TokenListViewModel = {
        TokenListViewModel { status,_ in
            if status == false {
              //  self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    var isHideShow = false
    lazy var nftViewModel: NFTListViewModel = {
        NFTListViewModel { status, _ in
            if status == false {
               // self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    lazy var currencyViewModel: CurrencyViewModel = {
        CurrencyViewModel { status, _ in
            if status == false {
               // self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    lazy var coinGeckoViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,_ in
           // self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    
    var currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
    var primaryCurrency: Currencies?
    var chainTokenList: [Token]? = []
    var tokenList: [Token]? = []
    var arrNftData: [NFTList]? = []
    var arrNftDataNew: [NFTDataNewElement]? = []
    var activeToken: [ActiveTokens]? = []
    var primaryWallet: Wallets?
    var curruntWallet : String?
    var nftDescription: String = String()
    var imageUrl: URL = URL(fileURLWithPath: "")
    var isImport = false
    var coinDetail : Token?
    private var isPairingTimer: Timer?
    let importAccount: ImportAccount
    var disposeBag = Set<AnyCancellable>()
    var transctionsValueArr  = [DashboardTrnsactions]()
    var url: String?
    var showError = false
    var errorMessage = "Error"
    enum Errors: LocalizedError {
        case invalidUri(uri: String)
    }
    let interactor : WalletInteractor
    var app: Application
    let mainInteractor : MainInteractor
    let configurationService: ConfigurationService
    init(importAccount: ImportAccount,interactor: WalletInteractor? = nil,app:Application,mainInteractor:MainInteractor,configurationService:ConfigurationService) {

     // Assign default values to properties
        defer { setupInitialState() }
        self.app = app
        self.importAccount = importAccount
        self.interactor = interactor ?? WalletInteractor()
        self.mainInteractor = mainInteractor
        self.configurationService = configurationService
        super.init(nibName: nil, bundle: nil)
   }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func multiLanguageSetUp() {

        self.btnAssets.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.assets, comment: ""), for: .normal)
        self.btnNFTs.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nfts, comment: ""), for: .normal)
        self.lblNoNFTS.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nonftsyet, comment: "")
        self.lblLearnMore.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.learnmore, comment: "")
        self.lblWalletName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalBalance, comment: "")
        self.btnReceiveNFTS.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receivenft, comment: ""), for: .normal)
        self.btnReceive.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: ""), for: .normal)
        transctionsValueArr =  [DashboardTrnsactions(image: UIImage.receive, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: "")),DashboardTrnsactions(image: UIImage.send, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")),DashboardTrnsactions(image: UIImage.buy1, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")),DashboardTrnsactions(image: UIImage.swap, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")),DashboardTrnsactions(image: UIImage.icSell, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""))]
        
    }
    fileprivate func updateVersion() {
        print("updateVersion")
        let isFromUserUpdate = UserDefaults.standard.value(forKey: isFromAppUpdated) as? String ?? ""
        
//        if isFromUserUpdate != "true" {
            coinGeckoViewModel.checkTokenVersion { status, msg, data in
                let userTokenkey = UserDefaults.standard.value(forKey: DefaultsKey.tokenString) as? String ?? ""
                if status == 1 {
                    if data?.isUpdate == true && data?.platform != "android" {
                        if data?.tokenString != userTokenkey {
                            let updateVc = UpdateVersionViewController()
                            updateVc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(updateVc, animated: true)
                        } else {
                            print("no deed to update Tokens")
                        }

                    }
                    
                } else {
                    print("updateTokenApiError:\(msg)")
                }
            }
//        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        configureNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDashboardData), name: NSNotification.Name("RefreshDashBoard"), object: nil)
        /// Table Register
        tableRegister()
        self.multiLanguageSetUp()
        nftViewRegister()
        /// Default card view will appear
        tbvAssets.isHidden = false
        btnReceiveNFTS.isHidden = true
        loader.hidesWhenStopped = true
        clvNFTs.isHidden = true
        viewNullNFT.isHidden = true
      
        mainScrollview.addRefreshControl(target: self, action: #selector(refreshCoinList))
        
        /// Currency set up
        currencySetUp()
        btnScan.bringSubviewToFront(headerView)
        btnScan.isUserInteractionEnabled = true
        vwCopyWalletAdd.addTapGesture {
            HapticFeedback.generate(.light)
            UIPasteboard.general.string = self.lblWalletAddress.text
            self.showToast(message: "\(StringConstants.copied): \(self.lblWalletAddress.text ?? "")", font: AppFont.regular(15).value)
        }
      
        btnNFTs.titleLabel?.font = AppFont.violetRegular(14).value
        btnAssets.titleLabel?.font = AppFont.violetRegular(14).value
        btnReceiveNFTS.titleLabel?.font = AppFont.violetRegular(14).value
        self.lblWalletName.font = AppFont.regular(17.39).value
        self.lblMainBal.font = AppFont.violetRegular(40.96).value
        self.lblCurruntWalletName.font = AppFont.violetRegular(17).value
        
        self.btnAssets.backgroundColor = UIColor.label
                btnAssets.titleLabel?.textColor = UIColor.systemBackground
                self.btnNFTs.backgroundColor = UIColor.secondarySystemFill
                btnNFTs.titleLabel?.textColor = UIColor.label
       
    }
    func getActiveTokens(walletAddress : String) {
        viewModel.apiGetActiveTokens(walletAddress: walletAddress) { data, status in
            self.activeToken = data
            //            print("Active token",self.activeToken)
        }
    }
    @objc func refreshDashboardData() {
            print("Refresh data called")
        getChainList()
      }
    deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshDashBoard"), object: nil)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.tintColor = UIColor.clear
        tabBarController?.tabBar.backgroundColor = UIColor.clear
        UserDefaults.standard.removeObject(forKey: "sendAddress")
        UserDefaults.standard.removeObject(forKey: "sendCoinQuantity")
        
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { _ in
            self.btnAssets.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.assets, comment: ""), for: .normal)
            self.btnNFTs.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nfts, comment: ""), for: .normal)
            self.multiLanguageSetUp()
            self.clvActions.reloadData()
           
        }
        updateVersion()
        tbvAssets.isHidden = false
        btnReceiveNFTS.isHidden = true
        clvNFTs.isHidden = true
        viewNullNFT.isHidden = true
        self.btnAssets.backgroundColor = UIColor.label
        btnAssets.titleLabel?.textColor = UIColor.systemBackground
        self.btnNFTs.backgroundColor = UIColor.secondarySystemFill
        btnNFTs.titleLabel?.textColor = UIColor.label
        self.clvActions.reloadData()
        lblWalletAddress.setCenteredEllipsisText(WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? "")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// show tip on home button
        if !(UserDefaults.standard.object(forKey: DefaultsKey.homeButtonTip) as? Bool ?? false) {
           
            UserDefaults.standard.set(true, forKey: DefaultsKey.homeButtonTip)
           
            self.clvNFTs.reloadData()
             self.clvNFTs.restore()

        }
//        if !(UserDefaults.standard.object(forKey: DefaultsKey.homeButtonTip) as? Bool ?? false) {
//        } else {
//
//        }
       
    }
    @IBAction func btnShowHideBal(_ sender: Any) {
        HapticFeedback.generate(.light)
        isHideShow.toggle()
        if isHideShow {
            let closeEyeImage = UIImage.closeEye
            let templateImage = closeEyeImage.withRenderingMode(.alwaysTemplate)
            btnShowHideBal.setImage(templateImage, for: .normal)
            btnShowHideBal.tintColor = UIColor.white
            updateTotalBal()
        } else {
            let openEyeImage = UIImage.eye
            let templateImage = openEyeImage.withRenderingMode(.alwaysTemplate)
            btnShowHideBal.setImage(templateImage, for: .normal)
            btnShowHideBal.tintColor = UIColor.white
            updateTotalBal()
        }
    }
    @IBAction func btnActionAssets(_ sender: Any) {
        HapticFeedback.generate(.light)
        loader.stopAnimating()
        btnAddCustomToken.isHidden = false
        self.btnAssets.backgroundColor = UIColor.label
        btnAssets.titleLabel?.textColor = UIColor.systemBackground
        self.btnNFTs.backgroundColor = UIColor.secondarySystemFill
        btnNFTs.titleLabel?.textColor = UIColor.label
        tbvAssets.isHidden = false
        clvNFTs.isHidden = true
        btnReceiveNFTS.isHidden = true
        viewNullNFT.isHidden = true
        mainScrollview.isScrollEnabled = true
       
    }
    @IBAction func btnActionNFTs(_ sender: Any) {
        loader.stopAnimating()
        HapticFeedback.generate(.light)
        btnAddCustomToken.isHidden = true
        self.btnNFTs.backgroundColor = UIColor.label
        btnNFTs.setTitleColor(UIColor.systemBackground, for: .normal)
        self.btnAssets.backgroundColor = UIColor.secondarySystemFill
        btnAssets.titleLabel?.textColor = UIColor.label
        clvNFTs.isHidden = false
       
        mainScrollview.isScrollEnabled = true
        tbvAssets.isHidden = true
       
        getNFTList()
    
    }
    
    @IBAction func btnScanAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.coinType = ""
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
                    DispatchQueue.main.async {
                        let scanner = QRScannerViewController()
                        scanner.delegate = self
                        self.present(scanner, animated: true, completion: nil)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    func exploreNew() {
//        DGProgressView.shared.show(to: self.tbvAssets)
//        self.tbvAssets.showLoader()
        self.loader.startAnimating()
        viewModel.apiGetActiveTokens(walletAddress: WalletData.shared.myWallet?.address ?? "") { data, status in
            self.activeToken = data
            self.activeTokenList()
        }
    }
    @objc func refreshCoinList() {
        
        if clvNFTs.isHidden == false {
            getNFTList()
            tbvAssets.isHidden = true
            btnReceiveNFTS.isHidden = false
            clvNFTs.isHidden = false
            viewNullNFT.isHidden = true
        } else {
            tbvAssets.isHidden = false
            btnReceiveNFTS.isHidden = true
            clvNFTs.isHidden = true
            //  scrollViewNft.isHidden = true
            viewNullNFT.isHidden = true
            exploreNew()
//            getChainList()
        }
       // getNFTList()
       // let button = UIButton()
        // exploreNewTapped(button)
        mainScrollview.endRefreshing()
    }
    @objc func refreshNFTs() {
        getNFTList()
        clvNFTs.endRefreshing()
    }
    @IBAction func actionReceive(_ sender: Any) {
        HapticFeedback.generate(.light)
        let viewToNavigate = BuyCoinListViewController()
        viewToNavigate.primaryWallet = self.primaryWallet
        viewToNavigate.isFrom = .receiveNFT
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    @IBAction func actionAddCustomToken(_ sender: Any) {
        HapticFeedback.generate(.light)
        let viewToNavigate = AddCustomTokenViewController()
        viewToNavigate.enabledTokenDelegate = self
        viewToNavigate.primaryWallet = self.primaryWallet
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
   
    @IBAction func btnPlutoPeAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let viewToNavigate = SettingsViewController(importAccount: importAccount)
        viewToNavigate.hidesBottomBarWhenPushed = true
        viewToNavigate.primaryWallet = self.primaryWallet
       // viewToNavigate.primaryWalletDelegate = self
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    @IBAction func btnSearchAction(_ sender: Any) {
//        let vcToPresent = CoinListViewController()
//        vcToPresent.enabledTokenDelegate = self
//        vcToPresent.primaryWallet = self.primaryWallet
//        vcToPresent.isFromDash = true
//        self.present(vcToPresent, animated: true)
        HapticFeedback.generate(.light)
        let vcToPresent = BuyCoinListViewController()
        vcToPresent.isFrom = .search
        vcToPresent.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vcToPresent, animated: true)
    }
    /// Navigation bar configuration
    private func configureNavigationBar() {
        /// Navigation Header
        var header = self.primaryWalletName
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /// Table Register
    private func tableRegister() {
        tbvAssets.delegate = self
        tbvAssets.dataSource = self
        tbvAssets.register(PurchasedCoinViewCell.nib, forCellReuseIdentifier: PurchasedCoinViewCell.reuseIdentifier)
        tbvAssets.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
    }
    
    /// NFT collection register
    private func nftViewRegister() {
        clvNFTs.delegate = self
        clvNFTs.dataSource = self
        clvNFTs.register(NFTsViewCell.nib, forCellWithReuseIdentifier: NFTsViewCell.reuseIdentifier)
        clvActions.delegate = self
        clvActions.dataSource = self
        clvActions.register(WalletDashboardCell.nib, forCellWithReuseIdentifier: WalletDashboardCell.reuseIdentifier)
        
    }

    private func currencySetUp() {
        let dispatchGroup = DispatchGroup()
        let isEmpty = DatabaseHelper.shared.entityIsEmpty("Currencies")
        if isEmpty {
            currencyViewModel.apiGet { currencyData, status, message in
                if status {
                    let arrCurrency = currencyData ?? []
                    print(message)
                    arrCurrency.forEach({ data in
                        dispatchGroup.enter()
                        let entity = NSEntityDescription.entity(forEntityName: "Currencies", in: DatabaseHelper.shared.context)!
                        let currencyEntity = Currencies(entity: entity, insertInto: DatabaseHelper.shared.context)
                        currencyEntity.id = UUID()
                        currencyEntity.name = data.name
                        currencyEntity.sign = data.sign
                        currencyEntity.symbol = data.symbol
                        if currencyEntity.symbol == "INR" {
                            currencyEntity.isPrimary = true
                        } else {
                            currencyEntity.isPrimary = false
                        }
                        DatabaseHelper.shared.saveData(currencyEntity) { _ in
                        }
                    })
                    
                    /// To get assets list
                    self.getChainList()
                    
                } else {
                    self.showToast(message: "Currency data failure", font: AppFont.regular(15).value)
                }
            }
        } else {
            /// To get assets list
            getChainList()
        }
    }
}

// MARK: Get price and bal
extension WalletDashboardViewController {
    func getNFTList() {

        self.arrNftDataNew?.removeAll()
//        clvNFTs.showLoader()
        loader.startAnimating()
        nftViewModel.apiGetAllNFTList(detail: (WalletData.shared.myWallet?.address ?? "")) { data, status, message in
            print("NFTres\(status)",data)
           if status {
               self.arrNftDataNew = data
               print("self.arrNftDataNew",self.arrNftDataNew)
               if !(self.arrNftDataNew?.isEmpty ?? false) {
                   
                   self.tbvAssets.isHidden = true
                   self.clvNFTs.isHidden = false
                   self.viewNullNFT.isHidden = true
                   self.btnReceiveNFTS.isHidden = false
                   DispatchQueue.main.async {
                       let number = Double(Float(self.arrNftDataNew?.count ?? 0) / Float(2)).rounded(.up)
                       self.constClvHeight.constant = CGFloat(number * 180)
                       self.loader.stopAnimating()
//                       self.clvNFTs.hideLoader()
                       self.clvNFTs.reloadData()
                       self.clvNFTs.restore()
                       
                   }
               } else {
                   self.tbvAssets.isHidden = true
                   self.btnReceiveNFTS.isHidden = true
                   self.clvNFTs.isHidden = true
                   self.viewNullNFT.isHidden = false
                   self.loader.stopAnimating()
//                   self.clvNFTs.hideLoader()
                   
               }
           } else {
   
               self.tbvAssets.isHidden = true
               self.clvNFTs.isHidden = true
               self.btnReceiveNFTS.isHidden = true
               self.viewNullNFT.isHidden = false
               self.loader.stopAnimating()
//               self.clvNFTs.hideLoader()
           }
       }
   }
    internal func getBalance(_ chainList: [Token], completion: @escaping () -> Void) {
        
        print("Counter = ",chainList.count)
        
        let sortedTokens = chainList.sorted { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") }
        
        var counter = sortedTokens.count
        for token in sortedTokens {
            // print("Tokens ==",token.name)
            token.callFunction.getBalance { bal in
                DispatchQueue.main.async {
                  //  print("token.address", token.address ?? "")
                    if token.address != "" {
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "address == %@", predicateArgs: [token.address ?? ""]) { object in
                            if let token = object as? Token {
                                token.balance = bal ?? "0"
                                counter -= 1
                            } else {
                                
                            }
                            
                            if counter == 0 {
                                completion()
                            }
                        }
                    } else {
                        
                        let toknsymbol = token.symbol ?? ""
//                        print("toknsymbol =",toknsymbol)
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "tokenId == %@ AND address == %@  AND symbol == %@", predicateArgs: [token.tokenId ?? "", "",toknsymbol]) { object in
                            if let token = object as? Token {
                                let cleanAddress = token.address?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                let balanceValue = bal ?? "0"

                                token.balance = balanceValue

                                switch (token.name?.lowercased(), token.tokenId?.lowercased(), cleanAddress.isEmpty) {
                                case ("optimism", "optimism", _):
                                    print("OptimismBal =", balanceValue)

                                case ("arbitrum", "arbitrum", true):
                                    print("arbitrumBal =", balanceValue)

                                case ("base", "base", true):
                                    print("baseBal =", balanceValue)

                                default:
                                    print("Bal =", balanceValue)
                                }

                                counter -= 1
                            } else {
                                
                            }
                            
                            if counter == 0 {
                                completion()
                            }
                        }
                        
                    }
                }
            }
     // implement BTC Chain Get Balance 6-12-13
            if token.type == "BTC" {
                // "bc1q4ce2w4z6q8m6v7fehau640dpp0fpqqzjqzpgsk"  "n1TKu4ZX7vkyjfvo7RCbjeUZB6Zub8N3fN"token.address
                let btcAddress = WalletData.shared.getPublicWalletAddress(coinType: .bitcoin) ?? ""
                self.viewModel.getBitcoinBalanceAPI(walletAddress: btcAddress, completion: { balance in
                  //  print("token.address", token.address ?? "")
                 //   print("balance",balance)
                    
                    if token.address != "" {
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "address == %@", predicateArgs: [token.address ?? ""]) { object in
                            if let token = object as? Token {
                                token.balance = "\(balance)"
                            }
                            completion()
                        }
                    } else {
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "symbol == %@ AND address == %@", predicateArgs: [token.symbol ?? "", ""]) { object in
                            if let token = object as? Token {
                                token.balance = "\(balance)"
                            }
                            completion()
                        }
                    }
                })
            }
        }
    }
    
    
    func getPrice(_ allChainToken: [Token], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        // Ensure primaryCurrency is set
        if primaryCurrency == nil {
            if let symbol = currencyData?.first(where: { $0.isPrimary }) {
                self.primaryCurrency = symbol
                WalletData.shared.primaryCurrency = symbol
            }
        }

        // Sort Ethereum first, then alphabetically by name
        let sortedTokens = allChainToken.sorted {
            if $0.tokenId == "ethereum" { return true }
            if $1.tokenId == "ethereum" { return false }
            return ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "")
        }

        for token in sortedTokens {
            guard let tokenId = token.tokenId, !tokenId.isEmpty else { continue }
            dispatchGroup.enter()

            coinGeckoViewModel.apiMarketVolumeData(primaryCurrency?.symbol ?? "", ids: tokenId) { status, _, data in
                defer { dispatchGroup.leave() }

                guard status, let data = data else { return }

                let sortedAssets = data.sorted { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") }

                // ✅ First apply ETH data if this token is Ethereum
                if tokenId == "ethereum" {
                    self.applyETHDataIfNeeded(from: sortedAssets)
                }

                for asset in sortedAssets {
                    DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "tokenId == %@", predicateArgs: [asset.id ?? ""]) { object in
                        guard let token = object as? Token else { return }

                        let roundVal = WalletData.shared.formatDecimalString("\(asset.priceChangePercentage24H ?? 0.0)", decimalPlaces: 2)
                        token.price = "\(asset.currentPrice ?? 0.0)"
                        token.logoURI = asset.image ?? ""
                        token.lastPriceChangeImpact = roundVal

                        // ✅ This will now work correctly since ETH data is already available
                        self.applyETHDerivedIfNeeded(to: token)
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    func applyETHDataIfNeeded(from assets: [MarketData]) {
        if let ethAsset = assets.first(where: { $0.id == "ethereum" && $0.name == "Ethereum" }) {
            self.ethPrice = ethAsset.currentPrice ?? 0.0
            self.ethLogoURI = ethAsset.image ?? ""
            self.ethPriceChange = ethAsset.priceChangePercentage24H ?? 0.0
            self.ethSymbol = ethAsset.symbol?.uppercased() ?? ""
        }
    }

    func applyETHDerivedIfNeeded(to token: Token) {
        let isEmptyAddress = (token.address ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let roundVal = WalletData.shared.formatDecimalString("\(self.ethPriceChange)", decimalPlaces: 2)

        if (token.name == "Arbitrum" && token.tokenId == "arbitrum" && isEmptyAddress)
            || (token.name == "Optimism" && token.tokenId == "optimism")
            || (token.name?.lowercased() == "base" && token.tokenId?.lowercased() == "base" && isEmptyAddress) {

            token.symbol = self.ethSymbol
            token.price = "\(self.ethPrice)"
            token.logoURI = self.ethLogoURI
            token.lastPriceChangeImpact = roundVal
        }
    }

    fileprivate func updateTableViewData() {
//        DGProgressView.shared.hideLoader()
       // DispatchQueue.main.async {
       
        self.updateTotalBal()
       // }
    }
    
    internal func getChainList() {
              //  self.lblMainBal.text = ""
        if currencyData?.count == 0 {
            currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
        }
        
        if primaryWallet == nil {
            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            primaryWallet = allWallet?.first(where: { $0.isPrimary })
            // WalletData.shared.wallet = HDWallet(mnemonic: primaryWallet?.mnemonic ?? "", passphrase: "")
            WalletData.shared.myWallet = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainETH, nil))
            WalletData.shared.walletBTC = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainBTC, nil))
//            WalletData.shared.importAccountFromMnemonicAction(mnemonic: primaryWallet?.mnemonic ?? "") { _ in
//                
//            }
        }
        
        guard let primaryWallet = primaryWallet else {
            // Handle the case when primaryWalletID is nil
            return
        }
       // print(primaryWallet.wallet_id?.uuidString ?? "")
//        self.tbvAssets.showLoader()
        self.loader.startAnimating()
        let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: primaryWallet.wallet_id?.uuidString ?? "")
        
       
//        let allChainToken = getPrimaryWalletToken?.compactMap { $0.tokens  }
        let allChainToken = getPrimaryWalletToken?
            .compactMap { $0.tokens }  // Extract tokens (array of arrays)
            .flatMap { $0 }            // Flatten into a single array
            .sorted { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") } // Sort by name
        if allChainToken?.count == 0 {
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    // Simulated network delay
                    DispatchQueue.main.async {
//                        self.self.tbvAssets.hideLoader()
                        self.loader.stopAnimating()
                        self.tbvAssets.reloadData()
                    }
                }
           
            return
        }
        
//        updateBaseAddress {
//            //print("Base token addresses updated.")
//        }
        
        if(self.chainTokenList?.isEmpty ?? false) {
            
            self.chainTokenList = allChainToken
            
            self.chainTokenList = self.chainTokenList?.filter { token in
                (token.address != "0x0000000000000000000000000000000000001010" && token.symbol != "bnry".uppercased())
            }
            
            self.chainTokenList?.sort { (token1, token2) -> Bool in
                // Assuming price is a string that needs to be converted to a numeric value
                if token1.tokenId == "PLT".lowercased() {
                        return true // PLT comes first
                } else if token2.tokenId == "PLT".lowercased() {
                        return false // PLT should precede token2
                    }
                let balance1 = Double(token1.balance ?? "") ?? 0.0
                let balance2 = Double(token2.balance ?? "") ?? 0.0
                let bal1 = balance1 * (Double(token1.price ?? "") ?? 0.0)
                let bal2 = balance2 * (Double(token2.price ?? "") ?? 0.0)
                // Sort in descending order (highest price first)
                return bal1 > bal2

            }
            print("data reloaded.......")
            self.updateTableViewData()
        }
        getPrice(allChainToken ?? []) {
            self.getBalance(allChainToken ?? []) {
              
                    self.chainTokenList = allChainToken
                    let addressToRemove = "0x0000000000000000000000000000000000001010"

                    // Filter out the addressToRemove
                    self.chainTokenList = self.chainTokenList?.filter { token in
                        return token.address != addressToRemove
                    }
                self.chainTokenList = self.chainTokenList?.filter({ token1 in
                    token1.symbol != "bnry".uppercased()
                })
                    self.chainTokenList?.sort { (token1, token2) -> Bool in
                        // Assuming price is a string that needs to be converted to a numeric value
                        if token1.tokenId == "PLT".lowercased() {
                                return true // PLT comes first
                        } else if token2.tokenId == "PLT".lowercased() {
                                return false // PLT should precede token2
                            }
                        let balance1 = Double(token1.balance ?? "") ?? 0.0
                        let balance2 = Double(token2.balance ?? "") ?? 0.0
                        let bal1 = balance1 * (Double(token1.price ?? "") ?? 0.0)
                        let bal2 = balance2 * (Double(token2.price ?? "") ?? 0.0)
                        // Sort in descending order (highest price first)
                        return bal1 > bal2

                    }
                   // print("data reloaded")
                    self.updateTableViewData()
                
            }
        }
    }
//    internal func getChainList() {
//        if currencyData?.isEmpty ?? true {
//            currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
//        }
//
//        if primaryWallet == nil {
//            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
//            primaryWallet = allWallet?.first(where: { $0.isPrimary })
//
//            guard let mnemonic = primaryWallet?.mnemonic else { return }
//            WalletData.shared.myWallet = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, WalletData.shared.chainETH, nil))
//            WalletData.shared.walletBTC = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, WalletData.shared.chainBTC, nil))
//        }
//
//        guard let primaryWallet = primaryWallet else { return }
//
//        DGProgressView.shared.showLoader(to: self.view)
//
//        let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: primaryWallet.wallet_id?.uuidString ?? "")
//        let allChainToken = getPrimaryWalletToken?
//            .compactMap { $0.tokens }
//            .flatMap { $0 }
//            .sorted { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") }
//
//        guard let tokens = allChainToken, !tokens.isEmpty else {
//            DGProgressView.shared.hideLoader()
//            return
//        }
//
//        self.chainTokenList = filterAndSortTokens(tokens)
//
//        getPrice(tokens) {
//            self.getBalance(tokens) {
//                self.chainTokenList = self.filterAndSortTokens(tokens)
//                self.updateTableViewData()
//                self.updateTotalBal()
//            }
//        }
//    }
    private func filterAndSortTokens(_ tokens: [Token]) -> [Token] {
        return tokens
            .filter { token in
                token.address != "0x0000000000000000000000000000000000001010" &&
                token.symbol?.uppercased() != "BNRY"
            }
            .sorted { t1, t2 in
                if t1.tokenId?.lowercased() == "plt" { return true }
                if t2.tokenId?.lowercased() == "plt" { return false }

                let balance1 = Double(t1.balance ?? "") ?? 0.0
                let price1 = Double(t1.price ?? "") ?? 0.0
                let value1 = balance1 * price1

                let balance2 = Double(t2.balance ?? "") ?? 0.0
                let price2 = Double(t2.price ?? "") ?? 0.0
                let value2 = balance2 * price2

                return value1 > value2
            }
    }

    func updateBaseAddress(completion: @escaping () -> Void) {
        let namesToUpdate = ["Base"]
        
        for name in namesToUpdate {
            let symbol = "BASE"
           let newAddress = ""
//           let newAddress = "0xd07379a755a8f11b57610154861d694b2a0f615a"
                
            
            DatabaseHelper.shared.updateData(
                entityName: "Token",
                predicateFormat: "symbol == %@ AND name == %@",
                predicateArgs: [symbol, name]
            ) { object in
                if let tokenToUpdate = object as? Token {
                    if tokenToUpdate.address?.lowercased() != newAddress.lowercased() {
                        tokenToUpdate.address = newAddress
                    }
                }
            }
        }
        
        completion()
    }

      /// update Total Balance
    fileprivate func updateTotalBal() {
       
        guard let chainTokenList = self.chainTokenList else { return }
        
        let sumOfTotalMainBal = chainTokenList.reduce(0.0) { (result, value) in
            guard let price = Double(value.price ?? ""), let balance = Double(value.balance ?? "") else {
                return result
            }
            
            let currencyBal = (balance * price)
            return result + currencyBal
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let sumOfTotal = WalletData.shared.formatDecimalString("\(sumOfTotalMainBal)", decimalPlaces: 2)
            if !self.isHideShow {
                self.lblMainBal.text = "\(self.primaryCurrency?.sign ?? "")\(sumOfTotal)"
            } else {
                self.lblMainBal.text = "*****"
            }
            self.primaryWalletName = self.primaryWallet?.wallet_name ?? ""
            /// Navigation bar configuration
            self.configureNavigationBar()
             self.lblCurruntWalletName.text = self.primaryWalletName
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    // Simulated network delay
                    DispatchQueue.main.async {
                        self.loader.stopAnimating()
//                        self.self.tbvAssets.hideLoader()
                        self.tbvAssets.reloadData()
                        self.tbvAssets.restore()
                    }
                }
           
           
        }
    }
}
extension WalletDashboardViewController {
    
    func initialLetterString(_ text: String) -> String? {
        // Get the first letter of the string
        let initial = String(text.prefix(1))
        return initial
    }
}
extension WalletDashboardViewController {
    // MARK: - Private functions
  
    func setupInitialState() {
        
        guard let importAccount = app.accountStorage.importAccount else { return }
      
       configurationService.configure(importAccount: importAccount)
     
        mainInteractor.sessionProposalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] session in
                let viewController: UIViewController = SessionProposalModule.create(app: app, importAccount: importAccount, proposal: session.proposal, context: session.context)
                self.navigationController?.present(viewController, animated: true)

            }
            .store(in: &disposeBag)
        mainInteractor.sessionRequestPublisher
           .receive(on: DispatchQueue.main)
           .sink { [unowned self] request, context in
               
               let viewController: UIViewController = SessionRequestModule.create(app: app, sessionRequest: request, importAccount: importAccount, sessionContext: context)
               self.navigationController?.present(viewController, animated: true)
//                        .presentFullScreen(from: self, transparentBackground: false)
           }.store(in: &disposeBag)
        
//        mainInteractor.authenticateRequestPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [unowned self] result in
//                let requestedChains: Set<Blockchain> = Set(result.request.payload.chains.compactMap { Blockchain($0) })
//                let supportedChains: Set<Blockchain> = [Blockchain("eip155:1")!, Blockchain("eip155:137")!,Blockchain("eip155:66")!,Blockchain("eip155:56")!,Blockchain("eip155:97")!,Blockchain("eip155:10")!,Blockchain("eip155:42161")!,Blockchain("eip155:43114")!,Blockchain("eip155:8453")!]
//                // Check if there's an intersection between the requestedChains and supportedChains
//                let commonChains = requestedChains.intersection(supportedChains)
//                guard !commonChains.isEmpty else {
//                    AlertPresenter.present(message: "No common chains", type: .error)
//                    return
//                }
//                let viewController: UIViewController =  AuthRequestModule.create(app: app, request: result.request, importAccount: importAccount, context: result.context)
//                self.navigationController?.present(viewController, animated: true)
//             
//            }
//            .store(in: &disposeBag)
       
//            interactor.requestPublisher
//                .receive(on: DispatchQueue.main)
//                .sink { [unowned self] result in
//                    AuthRequestModule.create(app: app, request: result.request, importAccount: importAccount, context: result.context)
//                        .presentFullScreen(from: self, transparentBackground: true)
//                }
//                .store(in: &disposeBag)
   }
}
