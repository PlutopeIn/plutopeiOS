//
//  WalletDashboardViewController.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//

import UIKit
//import WalletCore
import CoreData
import SwiftUI
import MaterialShowcase
import CGWallet
import CryptoSwift
class WalletDashboardViewController: UIViewController, Reusable {
    
    @IBOutlet weak var ringView: UIView!
    @IBOutlet weak var constClvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var lblMainBal: UILabel!
    @IBOutlet weak var headerView: UIView!
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
 
   
    lazy var viewModel: TokenListViewModel = {
        TokenListViewModel { status,message in
            if status == false {
              //  self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    lazy var nftViewModel: NFTListViewModel = {
        NFTListViewModel { status, message in
            if status == false {
               // self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    lazy var currencyViewModel: CurrencyViewModel = {
        CurrencyViewModel { status, message in
            if status == false {
               // self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    lazy var coinGeckoViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
           // self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    
    var currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
    var primaryCurrency: Currencies?
    var chainTokenList: [Token]? = []
    var arrNftData: [NFTList]? = []
    var primaryWallet: Wallets?
    var nftDescription: String = String()
    var imageUrl: URL = URL(fileURLWithPath: "")
    /// Ring hostingview swiftUI
    var hostingView: UIHostingController<GradientRingView>?
    
    fileprivate func multiLanguageSetUp() {
      //  self.lblWalletName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.currentbalance, comment: "")
        self.segmentControl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.assets, comment: ""), forSegmentAt: 0)
        self.segmentControl.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nfts, comment: ""), forSegmentAt: 1)
        self.lblNoNFTS.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nonftsyet, comment: "")
        self.lblLearnMore.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.learnmore, comment: "")
        self.btnReceiveNFTS.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receivenft, comment: ""), for: .normal)
        self.btnReceive.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: ""), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /// Navigation bar configuration
        configureNavigationBar()
        
        /// Table Register
        tableRegister()
        getChainList()
        /// NFT Collection Register
        nftViewRegister()
        
        /// Default card view will appear
        tbvAssets.isHidden = false
        scrollViewNft.isHidden = true
        viewNullNFT.isHidden = true
        
        clvNFTs.addRefreshControl(target: self, action: #selector(refreshNFTs))
        tbvAssets.addRefreshControl(target: self, action: #selector(refreshCoinList))
        /// Currency set up
        currencySetUp()
        /// Segment Setup
        segmentSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { (notification) in
            (self.headerView.subviews.first as? NavigationView)?.lblTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: "")
            self.tbvAssets.reloadData()
        }
        multiLanguageSetUp()
        updateTableViewData()
        // MARK: Ring Animation
        if #available(iOS 15.0, *) {
            /// Check if the subRingView already exists
            if let existingSubRingView = hostingView {
                existingSubRingView.view.removeFromSuperview()
                existingSubRingView.removeFromParent()
            }
            
            let subRingView = UIHostingController(rootView: GradientRingView(gradientColor: [
                Color(uiColor: UIColor.cC693FE),
                Color(uiColor: UIColor.c9654D9),
                Color(uiColor: UIColor.c5ABEF8),
                Color(uiColor: UIColor.c00C6FB),
                Color(uiColor: UIColor.cFA71CD),
                Color(uiColor: UIColor.cC471F5),
                Color(uiColor: UIColor.c6F86D6),
                Color(uiColor: UIColor.c48C6EF)
            ], lineWidth: 8))
            
            subRingView.view.frame = ringView.bounds
            subRingView.view.backgroundColor = .clear
            ringView.addNibView(nibView: subRingView.view)
            hostingView = subRingView
        } else { }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// show tip on home button
        if !(UserDefaults.standard.object(forKey: DefaultsKey.homeButtonTip) as? Bool ?? false) {
            showHomeTip()
        }
    }
    
    // show tip view
    fileprivate func showHomeTip() {
        let showcase = MaterialShowcase()
        // UIButton
        showcase.setTargetView(view: btnHome) // always required to set targetView
        showcase.primaryText = "Home"
        showcase.secondaryText = StringConstants.homeTip
        
        showcase.primaryTextAlignment = .right
        showcase.secondaryTextAlignment = .right
        // Background
        showcase.backgroundAlpha = 0.9
        showcase.backgroundPromptColor = UIColor.c00C6FB
        showcase.backgroundPromptColorAlpha = 0.80
        showcase.backgroundViewType = .circle // default is .circle
        showcase.backgroundRadius = 300
        // Target
        showcase.targetTintColor = UIColor.c00C6FB
        showcase.targetHolderRadius = 44
        showcase.targetHolderColor = UIColor.white
        // Text
        showcase.primaryTextColor = UIColor.white
        showcase.secondaryTextColor = UIColor.white
        showcase.primaryTextSize = 20
        showcase.secondaryTextSize = 15
        showcase.primaryTextFont = AppFont.bold(20).value
        showcase.secondaryTextFont = AppFont.medium(15).value
        // Alignment
        showcase.primaryTextAlignment = .left
        showcase.secondaryTextAlignment = .left
        // Animation
        showcase.aniComeInDuration = 0.5 // unit: second
        showcase.aniGoOutDuration = 0.5 // unit: second
        showcase.aniRippleScale = 1.5
        showcase.aniRippleColor = UIColor.white
        showcase.aniRippleAlpha = 0.2
        
        showcase.show(completion: {
            UserDefaults.standard.set(true, forKey: DefaultsKey.homeButtonTip)
            // You can save showcase state here
            // Later you can check and do not show it again
        })
    }
    
    @objc func refreshCoinList() {
        getChainList()
        tbvAssets.endRefreshing()
    }
    @objc func refreshNFTs() {
        getNFTList()
        clvNFTs.endRefreshing()
    }
    
    @IBAction func actionSegment(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            tbvAssets.isHidden = false
            scrollViewNft.isHidden = true
            viewNullNFT.isHidden = true
        case 1:
            tbvAssets.isHidden = true
            getNFTList()
            
        default:
            break
        }
        
    }
    
    @IBAction func actionReceive(_ sender: Any) {
        let viewToNavigate = BuyCoinListViewController()
        viewToNavigate.primaryWallet = self.primaryWallet
        viewToNavigate.isFrom = .receiveNFT
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    @IBAction func actionAddCustomToken(_ sender: Any) {
        let viewToNavigate = AddCustomTokenViewController()
        viewToNavigate.enabledTokenDelegate = self
        viewToNavigate.primaryWallet = self.primaryWallet
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    @IBAction func actionHome(_ sender: Any) {
        
        let viewToNavigate = CoinTransferPopUp()
        viewToNavigate.delegate = self
        viewToNavigate.modalTransitionStyle = .coverVertical
        viewToNavigate.modalPresentationStyle = .overFullScreen
        self.present(viewToNavigate, animated: true)
        
    }
    
    /// Navigation bar configuration
    private func configureNavigationBar() {
        /// Navigation Header
        //defineHeader(headerView: headerView, titleText: StringConstants.wallet, btnBackHidden: true)
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""), btnBackHidden: true)
        
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
    }
    
    /// Segment Setup
    private func segmentSetup() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.c767691, NSAttributedString.Key.font: AppFont.bold(16).value, NSAttributedString.Key.backgroundColor: UIColor.clear]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.bold(16).value]
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.layer.cornerRadius = 50
        segmentControl.layer.masksToBounds = true
        segmentControl.clipsToBounds = true
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
                            dispatchGroup.leave()
                        }
                    })
                    
                    /// To get assets list
                    dispatchGroup.notify(queue: .main) {
                        self.getChainList()
                    }
                    
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
    
    private func getNFTList() {
//         nftViewModel.apiGetNFTList(WalletData.shared.wallet?.getAddressForCoin(coin: .ethereum))
        DGProgressView.shared.showLoader(to:scrollViewNft)
        nftViewModel.apiGetNFTList(WalletData.shared.myWallet?.address ?? "") { data, status, message in
            if status {
               
                self.arrNftData = data
                if !(self.arrNftData?.isEmpty ?? false) {
                    
                    self.tbvAssets.isHidden = true
                    self.scrollViewNft.isHidden = false
                    self.viewNullNFT.isHidden = true
                    DispatchQueue.main.async {
                        let number = Double(Float(self.arrNftData?.count ?? 0) / Float(2)).rounded(.up)
                        self.constClvHeight.constant = CGFloat(number * 180)
                        DGProgressView.shared.hideLoader()
                        self.clvNFTs.reloadData()
                        self.clvNFTs.restore()
                        
                    }
                } else {
                    
                    self.tbvAssets.isHidden = true
                    self.scrollViewNft.isHidden = true
                    self.viewNullNFT.isHidden = false
                    DGProgressView.shared.hideLoader()
                }
            } else {
                print(message)
                
                self.tbvAssets.isHidden = true
                self.scrollViewNft.isHidden = true
                self.viewNullNFT.isHidden = false
                DGProgressView.shared.hideLoader()
            }
        }
    }
    
    internal func getBalance(_ chainList: [Token], completion: @escaping () -> Void) {
        var counter = chainList.count
        
        for token in chainList {
            token.callFunction.getBalance { bal in
                DispatchQueue.main.async {
                    print("token.address", token.address ?? "")
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
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "symbol == %@ AND address == %@", predicateArgs: [token.symbol ?? "", ""]) { object in
                            if let token = object as? Token {
                                token.balance = bal ?? "0"
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
                //"bc1q4ce2w4z6q8m6v7fehau640dpp0fpqqzjqzpgsk"  "n1TKu4ZX7vkyjfvo7RCbjeUZB6Zub8N3fN"token.address
                self.viewModel.getBitcoinBalanceAPI(walletAddress: token.address ?? "", completion: { balance in
                    print("token.address", token.address ?? "")
                    print("balance",balance)
                    
                    if token.address != "" {
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "address == %@", predicateArgs: [token.address ?? ""]) { object in
                            if let token = object as? Token {
                                token.balance = "\(balance)"
                            }
                        }
                    } else {
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "symbol == %@ AND address == %@", predicateArgs: [token.symbol ?? "", ""]) { object in
                            if let token = object as? Token {
                                token.balance = "\(balance)"
                            }
                        }
                    }
                })
            }
        }
    }
    internal func getPrice(_ allChainToken: [Token], completion: @escaping () -> Void) {
        var counter = allChainToken.count
        if primaryCurrency == nil {
            if let symbol = currencyData?.first(where: { $0.isPrimary }) {
                self.primaryCurrency = symbol
                WalletData.shared.primaryCurrency = self.primaryCurrency
                print(symbol)
            }
        }
        
        for token in allChainToken {
            
//            self.coinGeckoViewModel.apiMarketVolumeData(primaryCurrency?.symbol ?? "", ids: token.tokenId ?? "") { _,_,data in
            var tokenId = ""
            if token.tokenId == "" {
                tokenId = ""
            } else {
                tokenId = token.tokenId ?? ""
            }
            coinGeckoViewModel.apiMarketVolumeData(primaryCurrency?.symbol ?? "", ids: tokenId) { _,_,data in
                if let data = data, let assets = data.first {
                    DispatchQueue.main.async {
                        let symbol = (assets.symbol ?? "").uppercased()
                        let id = assets.id ?? ""
                        print("symbol = ",symbol)
                        print("id = ",id)
                        DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "symbol == %@ AND tokenId == %@", predicateArgs: [symbol ,id]) { object in
                            if let token = object as? Token {
                                let price = assets.currentPrice ?? 0.0
                                token.price = "\(price)"
                                print("price = ",token.price ?? "")
                                token.logoURI = assets.image ?? ""
                                print("logoURI = ",token.logoURI ?? "")
                                let roundVal = WalletData.shared.formatDecimalString("\(assets.priceChangePercentage24H ?? 0.0)", decimalPlaces: 2)
                                token.lastPriceChangeImpact = roundVal
                                print("lastPriceChangeImpact = ",token.lastPriceChangeImpact ?? "")
                               // if token.isUserAdded {
                                    counter -= 1
                             //   }
                               
                                print("counter == ",counter)
                            } else {

                            }
                            if counter == 0 {
                                completion()
                            }
                        }
                     }
                } else {
                    counter -= 1
                    if counter == 0 {
                        completion()
                    }
                }
            }
        }
    }

    
    fileprivate func updateTableViewData() {
        DispatchQueue.main.async {
            self.tbvAssets.reloadData()
            self.updateTotalBal()
        }
    }
    
    internal func getChainList() {
     //     DGProgressView.shared.showLoader(to: self.view)
        if currencyData?.count == 0 {
            currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
        }
        
        if primaryWallet == nil {
            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            primaryWallet = allWallet?.first(where: { $0.isPrimary })
           // WalletData.shared.wallet = HDWallet(mnemonic: primaryWallet?.mnemonic ?? "", passphrase: "")
            WalletData.shared.myWallet = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainETH, nil))
            WalletData.shared.walletBTC = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainBTC, nil))
        }
        
        guard let primaryWallet = primaryWallet else {
            // Handle the case when primaryWalletID is nil
            return
        }
        
        let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: primaryWallet.wallet_id?.uuidString ?? "")
        let allChainToken = getPrimaryWalletToken?.compactMap { $0.tokens  }
        
        if allChainToken?.count == 0 {
            DGProgressView.shared.hideLoader()
            return
        }
        // change for get fast wallet list 12-12-23
        if((self.chainTokenList?.isEmpty ?? false)) {

            self.chainTokenList = allChainToken
            self.chainTokenList?.sort { (token1, token2) -> Bool in
                // Assuming price is a string that needs to be converted to a numeric value
                let balance1 = Double(token1.balance ?? "") ?? 0.0
                let balance2 = Double(token2.balance ?? "") ?? 0.0
                let bal1 = balance1 * (Double(token1.price ?? "") ?? 0.0)
                let bal2 = balance2 * (Double(token2.price ?? "") ?? 0.0)
                // Sort in descending order (highest price first)
                return bal1 > bal2

            }
            self.updateTableViewData()
        }
        // chnage end 12-12-23
      //                 DGProgressView.shared.hideLoader()
        getPrice(allChainToken ?? []) {
            self.getBalance(allChainToken ?? []) {
                self.chainTokenList = allChainToken
                // Sort the chainTokenList array based on the highest price
                self.chainTokenList?.sort { (token1, token2) -> Bool in
                    // Assuming price is a string that needs to be converted to a numeric value
                    let balance1 = Double(token1.balance ?? "") ?? 0.0
                    let balance2 = Double(token2.balance ?? "") ?? 0.0
                    let bal1 = balance1 * (Double(token1.price ?? "") ?? 0.0)
                    let bal2 = balance2 * (Double(token2.price ?? "") ?? 0.0)
                    // Sort in descending order (highest price first)
                    return bal1 > bal2

                }
                print("data reloaded")
                self.updateTableViewData()
                DGProgressView.shared.hideLoader()
            }
        }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
            let sumOfTotal = WalletData.shared.formatDecimalString("\(sumOfTotalMainBal)", decimalPlaces: 2)
            self.lblMainBal.text = "\(self.primaryCurrency?.sign ?? "")\(sumOfTotal)"
            self.lblWalletName.text = self.primaryWallet?.wallet_name ?? ""
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
