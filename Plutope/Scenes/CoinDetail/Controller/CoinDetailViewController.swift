//
//  CoinDetailViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import SafariServices
import Lottie
// swiftlint:disable type_body_length
class CoinDetailViewController: UIViewController, Reusable {
    
    @IBOutlet weak var lblCheckExp: UILabel!
    @IBOutlet weak var lblCoinBalance: UILabel!
    @IBOutlet weak var clvActions: UICollectionView!
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCheckExplorer: UILabel!
    @IBOutlet weak var lblCoinNetwork: DesignableLabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var viewNoTransaction: UIView!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var ivCoinImage: UIImageView!
    @IBOutlet weak var lblCoinBal: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvTransactions: UITableView!
    @IBOutlet weak var constantTbvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTransactions: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewTransationinternal: UIView!
    @IBOutlet weak var heightViewtransactionInternal: NSLayoutConstraint!
    @IBOutlet weak var lblNoTransactions: UILabel!
    
    @IBOutlet weak var lotteView: LottieAnimationView!
    @IBOutlet weak var btnInternal: UIButton!
    @IBOutlet weak var btnTransaction: UIButton!
    var isFetchingData = false
   
    var coinDetail: Token?
    var isToContract  = false
    var url: String?

    // new Api
    var arrTransactionNewData: [TransactionHistoryResult] = []
    
    var transactionHistory: [TransactionHistory] = []
    weak var refreshWalletDelegate: RefreshDataDelegate?
    weak var updatebalDelegate: RefreshDataDelegate?
    var isCustomAdded: Bool = false
    var selectedSegment = String()
    var transctionsValueArr  = [DashboardTrnsactions]()
    var cursor: String? = nil
    var tokenCursor: String? = nil
    var isLoading = false
    var isTokenLoading = false
    var hasMoreData = true
    var hasTokenMoreData = true
    var internalCursor: String? = nil
    var hasMoreInternalData = true
    var isInternalFetchingData = false
    var isFromSearch = false
    var page = 1
    var currentPage: Int = 1
    var totalPages: Int = 1
    lazy var viewModel: TransactionHistoryViewModel = {
        TransactionHistoryViewModel { _ , _ in
            self.viewNoTransaction.isHidden = false
            self.tbvTransactions.isHidden = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                            // Simulated network delay
                            DispatchQueue.main.async {
                               self.tbvTransactions.hideLoader()
                              
                            }
                        }
        }
    }()
    lazy var buyViewModel: CoinMinPriceViewModel = {
        CoinMinPriceViewModel { status, message in
            if status == false {
                self.showToast(message: message, font: .systemFont(ofSize: 15))
            }
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
         //   self.showToast(message: message, font: .systemFont(ofSize: 15))
            // self.btnDone.HideLoader()
        }
    }()
    fileprivate func uiSetUp() {
        self.lblTransactions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactions, comment: "")
        self.lblNoTransactions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.notransactionsyet, comment: "")
        self.lblPrice.font = AppFont.regular(15).value
        self.lblPer.font = AppFont.regular(15).value
        self.lblCoinBal.font = AppFont.violetRegular(26.76).value
        self.lblTransactions.font = AppFont.violetRegular(16).value
        self.lblCoinNetwork.font = AppFont.regular(8.0).value
        self.lblCoinBalance.font = AppFont.violetRegular(15).value
        self.lblCheckExp.font = AppFont.regular(13).value
       
        setAttributedClickableText(labelName: lblCheckExplorer, labelText:LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.canNotFindTrans, comment: "") , value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.checkExplorer, comment: ""), color: UIColor.label, linkColor: UIColor.c00C6FB)
        lblCheckExplorer.addTapGesture {
            HapticFeedback.generate(.light)
            self.openExplorer(for: self.coinDetail?.chain, walletAddress: self.coinDetail?.chain?.walletAddress)
        }

        lotteView.addTapGesture {
            HapticFeedback.generate(.light)
            self.openExplorer(for: self.coinDetail?.chain, walletAddress: self.coinDetail?.chain?.walletAddress)
        }
        lblCheckExp.addTapGesture {
            HapticFeedback.generate(.light)
            self.openExplorer(for: self.coinDetail?.chain, walletAddress: self.coinDetail?.chain?.walletAddress)
        }
    }
   
    private func openExplorer(for chain: Chain?, walletAddress: String?) {
        guard let txId = walletAddress, let chain = chain else { return }

        let urlString: String
        switch chain {
        case .binanceSmartChain:
            urlString = "https://bscscan.com/address/\(txId)"
        case .ethereum:
            urlString = "https://etherscan.io/address/\(txId)"
        case .oKC:
            urlString = "https://www.okx.com/explorer/oktc/address/\(txId)"
        case .polygon:
            urlString = "https://polygonscan.com/address/\(txId)"
        case .bitcoin:
            urlString = "https://btcscan.org/address/\(txId)"
        case .opMainnet:
            urlString = "https://optimistic.etherscan.io/address/\(txId)"
       
        case .avalanche:
            urlString = "https://subnets.avax.network/c-chain/address/\(txId)"
        case .arbitrum:
            urlString = "https://arbiscan.io/address/\(txId)"
        case .base:
            urlString = "https://basescan.org/address/\(txId)"
        default:
            return // Unsupported chain
        }

        guard let url = URL(string: urlString) else { return }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .overFullScreen
        self.present(safariVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSegment = "Transaction"
        /// Navigation Header
        if  coinDetail?.tokenId == "PLT".lowercased() {
            defineHeader(headerView: headerView, titleText:  coinDetail?.name ?? "", btnBackHidden: false, popToRoot: true)
        } else {
        defineHeader(headerView: headerView, titleText:  coinDetail?.name ?? "", btnBackHidden: false, popToRoot: true, btnRightImage: UIImage.icNewgraff.withTintColor(UIColor.systemGray3)) {
            HapticFeedback.generate(.light)
            let viewToNavigate = CoinGraphViewController()
            viewToNavigate.coinDetail = self.coinDetail
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        } btnBackAction: {
            if self.isCustomAdded {
                if let rootVC = self.navigationController?.viewControllers.first(where: {$0 is WalletDashboardViewController}) as? WalletDashboardViewController {
                    self.refreshWalletDelegate = rootVC
                } else {
                    self.refreshWalletDelegate = nil
                }
                self.refreshWalletDelegate?.refreshData()
            }
            if self.isFromSearch == true {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
        
        /// UI Set up
        uiSetUp()
        loadNibs()
        /// Table Register
        tableRegister()
        if  coinDetail?.tokenId == "PLT".lowercased() {
            transctionsValueArr =  [DashboardTrnsactions(image: UIImage.send, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")),DashboardTrnsactions(image: UIImage.receive, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: ""))]
            
        } else {
            transctionsValueArr =  [DashboardTrnsactions(image: UIImage.send, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")),DashboardTrnsactions(image: UIImage.receive, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: "")),DashboardTrnsactions(image: UIImage.buy, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")),DashboardTrnsactions(image: UIImage.swap, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")),DashboardTrnsactions(image: UIImage.icSell, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""))]
            }
        /// call setcoin detail
        setCoinDetail()
        
        // segment
//        segmentSetup()
         
        // set segment for only main chains 
//        if coinDetail?.address == "" && coinDetail?.type != "BTC"{
//            viewTransationinternal.isHidden = false
//            heightViewtransactionInternal.constant = 40
//        } else {
            viewTransationinternal.isHidden = true
            heightViewtransactionInternal.constant = 0
//        }
        if DataStore.networkEnv == .mainnet {
            getTransactionHistory(cursor: nil)
//            if coinDetail?.address == "" {
//                fetchTransactionHistory(cursor: nil)
//            } else {
//                fetchTokenTransactionHistory(cursor: nil)
//            }
        }
        
        self.btnTransaction.backgroundColor = UIColor.label
        self.btnInternal.backgroundColor = UIColor.secondarySystemFill
        
        let btnNewCardTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transaction, comment: "")
        let btnNewCardAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFont.violetRegular(14).value,
            .foregroundColor: UIColor.systemBackground // Adapts to light/dark mode
        ]
        let btnNewCardAttributTitle = NSAttributedString(string: btnNewCardTitle, attributes: btnNewCardAttributes)
        btnTransaction.setAttributedTitle(btnNewCardAttributTitle, for: .normal)
        
        let btnNftAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFont.violetRegular(14).value,
            .foregroundColor: UIColor.label
        ]
        let btnNFTsTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.internalText, comment: "")
        
        let btnNftAttributTitle = NSAttributedString(string: btnNFTsTitle, attributes: btnNftAttributes)
        btnInternal.setAttributedTitle(btnNftAttributTitle, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lotteView.loopMode = .loop
        lotteView.animationSpeed = 1
        lotteView.play()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tbvTransactions.reloadData()
//        tbvTransactions.restore()
//    }
    /// NFT collection register
     func loadNibs() {
        clvActions.delegate = self
        clvActions.dataSource = self
        clvActions.register(WalletDashboardCell.nib, forCellWithReuseIdentifier: WalletDashboardCell.reuseIdentifier)
        
    }
    /// setcoin detail
    fileprivate func setCoinDetail() {
        
        if let coinDetail = self.coinDetail {
            if coinDetail.symbol == "usdc.e" {
                coinDetail.symbol = "usdt"
            }
        }
     //   print(coinDetail?.symbol?.lowercased() == "usdc.e")
        let coinBal =  WalletData.shared.formatDecimalString("\(coinDetail?.balance ?? "")", decimalPlaces: 8)
        lblCoinBal.text = "\(coinBal) \(coinDetail?.symbol ?? "0")"
        
        let amout = (Double(coinDetail?.balance ?? "0") ?? 0.0) * (Double(coinDetail?.price ?? "0") ?? 0.0)

        let formattedValue = WalletData.shared.formatDecimalString("\(amout)", decimalPlaces: 2)

        // coin amount
        let coinAmt = "≈ \(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedValue)"
        lblCoinBalance.text = coinAmt
        lblCoinNetwork.text = coinDetail?.type
        /// Price impact set up with color
        if Double(coinDetail?.lastPriceChangeImpact ?? "0") ?? 0.0 >= 0 {
            self.lblPer.text = "+\(coinDetail?.lastPriceChangeImpact ?? "0")%"
            self.lblPer.textColor = UIColor.c099817
        } else {
            self.lblPer.text = "\(coinDetail?.lastPriceChangeImpact ?? "0")%"
            self.lblPer.textColor = .red
        }
        lblPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(coinDetail?.price ?? "0")"
        /// Set coin image
//        if let logoURI = coinDetail?.logoURI, !logoURI.isEmpty {
//            ivCoinImage.sd_setImage(with: URL(string: logoURI))
//        } else {
//            ivCoinImage.image = coinDetail?.chain?.chainDefaultImage
//        }
        
        let logoURI = coinDetail?.logoURI ?? ""
        if coinDetail?.tokenId == "PLT".lowercased() {
           
            if logoURI == "" {
                ivCoinImage.sd_setImage(with: URL(string: "https://plutope.app/api/images/applogo.png"))
            } else {
                ivCoinImage.sd_setImage(with: URL(string: logoURI))
            }
        } else {
            if logoURI == "" {
                ivCoinImage.sd_setImage(with: URL(string: logoURI))
            } else {
                ivCoinImage.sd_setImage(with: URL(string: logoURI))
            }
        }
        if coinDetail?.isUserAdded ?? false {
            
//            btnBuy.isHidden = true
//            lblBuy.isHidden = true
//            btnMore.isHidden = true
//            lblMore.isHidden = true
            lblPrice.text = ""
            lblPer.text = ""
        } else {
//            btnBuy.isHidden = false
//            btnMore.isHidden = false
//            lblMore.isHidden = false
//            lblBuy.isHidden = false
        }
    }
    
//    @IBAction func actionTransaction(_ sender: Any) {
//        if coinDetail?.address == "" {
//            cursor = nil
//           // transactions.removeAll()
//            tbvTransactions.reloadData()
//            
//            // Fetch first page
//            fetchTransactionHistory(cursor: nil)
//        } else {
//            tokenCursor = nil
//          //  tokenTransactions.removeAll()
//            tbvTransactions.reloadData()
//            fetchTransactionHistory(cursor: nil)
//        }
//        
//        self.btnTransaction.backgroundColor = UIColor.label
//        self.btnInternal.backgroundColor = UIColor.secondarySystemFill
//        
//        let btnNewCardTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transaction, comment: "")
//        let btnNewCardAttributes: [NSAttributedString.Key: Any] = [
//            .font: AppFont.violetRegular(14).value,
//            .foregroundColor: UIColor.systemBackground // Adapts to light/dark mode
//        ]
//        let btnNewCardAttributTitle = NSAttributedString(string: btnNewCardTitle, attributes: btnNewCardAttributes)
//        btnTransaction.setAttributedTitle(btnNewCardAttributTitle, for: .normal)
//        
//        let btnNftAttributes: [NSAttributedString.Key: Any] = [
//            .font: AppFont.violetRegular(14).value,
//            .foregroundColor: UIColor.label
//        ]
//        let btnNFTsTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.internalText, comment: "")
//        
//        let btnNftAttributTitle = NSAttributedString(string: btnNFTsTitle, attributes: btnNftAttributes)
//        btnInternal.setAttributedTitle(btnNftAttributTitle, for: .normal)
//    }
//    
//    @IBAction func actionInternal(_ sender: Any) {
//        selectedSegment = "Internal"
//        internalCursor = nil
//        internalTransactions.removeAll()
//        tbvTransactions.reloadData()
// 
//        fetchInternalTransactionHistory(cursor: nil)
//        tbvTransactions.reloadData()
//        self.btnInternal.backgroundColor = UIColor.label
//        self.btnTransaction.backgroundColor = UIColor.secondarySystemFill
//        
//        let btnNFTsTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.internalText, comment: "")
//        let btnNFTsAttributes: [NSAttributedString.Key: Any] = [
//            .font: AppFont.violetRegular(14).value,
//            .foregroundColor: UIColor.systemBackground // Adapts to light/dark mode
//        ]
//        let btnNFTsAttributTitle = NSAttributedString(string: btnNFTsTitle, attributes: btnNFTsAttributes)
//        btnInternal.setAttributedTitle(btnNFTsAttributTitle, for: .normal)
//        
//        let btnNewCardTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transaction, comment: "")
//        let btnAssetAttributes: [NSAttributedString.Key: Any] = [
//            .font: AppFont.violetRegular(14).value,
//            .foregroundColor: UIColor.label
//        ]
//        let btnAssetAttributTitle = NSAttributedString(string: btnNewCardTitle, attributes: btnAssetAttributes)
//        btnTransaction.setAttributedTitle(btnAssetAttributTitle, for: .normal)
//    }
    
    @IBAction func actionSendCoin(_ sender: Any) {
        HapticFeedback.generate(.light)
            let viewToNavigate = SendCoinViewController()
            viewToNavigate.coinDetail = self.coinDetail
            viewToNavigate.refreshWalletDelegate = self
            viewToNavigate.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    @IBAction func actionBuy(_ sender: Any) {
        HapticFeedback.generate(.light)
        let coinData = self.coinDetail
        let buyCoinVC = BuyCoinViewController()
        buyCoinVC.headerTitle = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")) \(coinData?.symbol ?? "")"
        buyCoinVC.coinDetail = coinData
        //        buyCoinVC.minimumAmount = minimumAmount
        self.navigationController?.pushViewController(buyCoinVC, animated: true)
    }
    
    @IBAction func actionSwapCoin(_ sender: Any) {
        HapticFeedback.generate(.light)
        if isIPAD {
            showBottonSheetIniPad()
        } else {
            showBottomSheet()
        }
    }
    
    @IBAction func actionReceiveCoin(_ sender: Any) {
        HapticFeedback.generate(.light)
        let viewToNavigate = ReceiveCoinViewController()
        viewToNavigate.coinDetail = self.coinDetail
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    /// Table Register
    func tableRegister() {
        tbvTransactions.delegate = self
        tbvTransactions.dataSource = self
        tbvTransactions.register(TransactionViewCell.nib, forCellReuseIdentifier: TransactionViewCell.reuseIdentifier)
        mainScrollView.delegate = self
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height

        print(" offsetY: \(offsetY), contentHeight: \(contentHeight), viewHeight: \(scrollViewHeight)")

        if selectedSegment == "Transaction" {
            // Only allow loading more if we have more data
            guard hasMoreData, !isLoading else {
                print("No more data to load or already loading")
                return
            }

            // Prevent triggering when all data fits on one screen
            let isShortContent = contentHeight <= scrollViewHeight + 20
            if isShortContent {
                print(" Content too short to scroll — skip loading")
                return
            }

            // When scrolling near the bottom, trigger next page
            if offsetY > contentHeight - scrollViewHeight - 100 {
                print("Loading next page")
                getTransactionHistory(cursor: cursor)
            }
        }
    }
    func resetTransactionPagination() {
        // If data already loaded and there's only one page, do nothing
        if !hasMoreData && !arrTransactionNewData.isEmpty {
            print("✅ Only 1 page loaded. No need to reset.")
            return
        }

        // Clear current transactions data
        self.arrTransactionNewData.removeAll()
        
        // Reset cursor to nil to fetch from the first page
        self.cursor = nil
        
        // Allow more data to be fetched again
        self.hasMoreData = true
        
        // Reload the table view to show empty or refreshed UI
        self.tbvTransactions.reloadData()
        
        // Fetch first page
        getTransactionHistory(cursor: nil)
    }

    func getTransactionHistory(cursor: String?) {
        guard !isLoading else { return }
        isLoading = true
        self.tbvTransactions.showLoader()
        viewModel.getTransactionHistortyNew(self.coinDetail!, cursor: cursor) { [weak self] result, nextCursor, success, errorMessage in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.tbvTransactions.hideLoader()
                self.isLoading = false
                guard success, let newTransactions = result else {
                    self.hasMoreData = false

                    // Show "No Transactions" UI only if no local data exists
                    if self.arrTransactionNewData.isEmpty {
                        self.lblTransactions.isHidden = true
                        self.viewNoTransaction.isHidden = false
                        self.tbvTransactions.isHidden = true
                    }
                    return
                }

                if newTransactions.isEmpty {
                    self.hasMoreData = false

                    // Only show empty UI if this is the first page and we have no data
                    if self.arrTransactionNewData.isEmpty {
                        self.lblTransactions.isHidden = true
                        self.viewNoTransaction.isHidden = false
                        self.tbvTransactions.isHidden = true
                    }

                    return
                }
                // Filter out unwanted types
                let filteredTransactions = newTransactions.filter { $0.type != "unxswapByOrderId" }

                // Show UI
                self.lblTransactions.isHidden = false
                self.viewNoTransaction.isHidden = true
                self.tbvTransactions.isHidden = false

                // Append or set
                if cursor == nil {
                    self.arrTransactionNewData = filteredTransactions
                } else {
                    self.arrTransactionNewData.append(contentsOf: filteredTransactions)
                }

                // Update pagination
                self.cursor = nextCursor
                self.hasMoreData = (nextCursor != nil)
                self.tbvTransactions.reloadData()

            }
        }
    }

}

// MARK: PrimaryWalletDelegate
extension CoinDetailViewController: RefreshDataDelegate {
    func refreshData() {
        if let walletDash = self.navigationController?.viewControllers.first as? WalletDashboardViewController {
            updatebalDelegate = walletDash
            updatebalDelegate?.refreshData()
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex = 1
        }
    }
}

class CustomPopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the appearance of your custom popover
        view.backgroundColor = UIColor.white

        // Add your action buttons
        let action1Button = UIButton(type: .system)
        action1Button.setTitle("Action 1", for: .normal)
        action1Button.addTarget(self, action: #selector(action1Pressed), for: .touchUpInside)
        view.addSubview(action1Button)

        let action2Button = UIButton(type: .system)
        action2Button.setTitle("Action 2", for: .normal)
        action2Button.addTarget(self, action: #selector(action2Pressed), for: .touchUpInside)
        view.addSubview(action2Button)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        view.addSubview(cancelButton)

        // Layout action buttons with constraints
        action1Button.translatesAutoresizingMaskIntoConstraints = false
        action2Button.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            action1Button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            action1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            action1Button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            action1Button.heightAnchor.constraint(equalToConstant: 50),

            action2Button.topAnchor.constraint(equalTo: action1Button.bottomAnchor, constant: 10),
            action2Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            action2Button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            action2Button.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.topAnchor.constraint(equalTo: action2Button.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func action1Pressed() {
        HapticFeedback.generate(.light)
        // Handle Action 1
        dismiss(animated: true, completion: nil)
    }

    @objc func action2Pressed() {
        HapticFeedback.generate(.light)
        // Handle Action 2
        dismiss(animated: true, completion: nil)
    }

    @objc func cancelPressed() {
        HapticFeedback.generate(.light)
        // Handle Cancel
        dismiss(animated: true, completion: nil)
    }
    
}
// swiftlint:enable type_body_length
