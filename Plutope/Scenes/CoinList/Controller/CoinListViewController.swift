//
//  CoinListViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit

class CoinListViewController: UIViewController {
    
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var tbvCoinList: UITableView!
    @IBOutlet weak var txtSearch: customTextField!
    
    var primaryWallet: Wallets?
    var payCoinDetail: Token?
    var tokensList: [Token]? = []
    var isFrom = ""
    var filterTokens: [Token]? = []
    var pairData: [ExchangePairsData] = []
    var fromCurrency,fromNetwork: String?
    var toNetwork = ["eth","bsc","pol","btc","op","arb","avax","base"]
    weak var swapDelegate: SwappingCoinDelegate?
    weak var enabledTokenDelegate: EnabledTokenDelegate?
    var isPayCoin = false
    var isFromDash = false
    var isFromNFT = false
    var index = 0
    var isSearching: Bool = false
    var isFromMyTokenVC = false
    lazy var viewModel: SwappingViewModel = {
        SwappingViewModel { _,_ in
        }
    }()
    lazy var coinGeckoViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,_ in
        }
    }()
    lazy var coinGraphViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,_ in
            DGProgressView.shared.hide()
        }
    }()
    
    var apiResponse: [MarketData]? {
        didSet {
            if let response = apiResponse, !response.isEmpty {
                // Handle the non-empty response
                // For example, update your UI
                allReadySaved()
                
            } else {
                // Handle the empty response or nil value
            }
        }
    }
    var trendingToken: [MarketData]? = []
    var isOkx = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        
        /// Table Register
        tableRegister()
        ivBack.addTapGesture {
            HapticFeedback.generate(.light)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        if primaryWallet == nil {
            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            primaryWallet = allWallet?.first(where: { $0.isPrimary })
        }
        
        
        if self.isFromMyTokenVC == true {
            tbvCoinList.isMultipleTouchEnabled = true
        } else {
            tbvCoinList.isMultipleTouchEnabled = false
        }
        txtSearch.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        /// getTokensListFromCoredata
        getTokensListFromCoredata()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        isSearching = false
    }
    /// Table Register
    fileprivate func tableRegister() {
        tbvCoinList.delegate = self
        tbvCoinList.dataSource = self
        tbvCoinList.register(CoinListViewCell.nib, forCellReuseIdentifier: CoinListViewCell.reuseIdentifier)
    }
    
    /// getTokensListFromCoredata
    func getTokensListFromCoredata() {
        if isFrom == "swap" {
            //DGProgressView.shared.showLoader(to: view)
            
            // Retrieve tokens and filter efficiently
            self.tokensList = (DatabaseHelper.shared.retrieveData("Token") as? [Token])?
                .filter { token in
                    token.tokenId != "PLT".lowercased() &&  // Exclude PLT token
                    token.address != "0x0000000000000000000000000000000000001010" && // Exclude specific address
                    token.symbol != "BNRY" // Ensure symbol check is uppercase
                }
            allReadySaved()
        } else if let tokens = AppConstants.tokensList {
//            DGProgressView.shared.showLoader(to: view)

            // Fetch only required token attributes to reduce Core Data overhead
            let tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token] ?? []
            
            // Fetch Wallet Tokens once & create a Set for quick lookups
            let walletTokens = (DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens] ?? [])
                .filter { $0.wallet_id == self.primaryWallet?.wallet_id }

            let enabledTokensSet: Set<String> = Set(walletTokens.compactMap { $0.tokens?.tokenId }) // Store only tokenId for O(1) lookup
            // Convert `trendingIds` to Dictionary for fast indexing
            let trendingIdsArray = AppConstants.storedTokensList?.compactMap { $0.id } ?? []
            let trendingIdsDict = Dictionary(uniqueKeysWithValues: trendingIdsArray.enumerated().map { ($1, $0) }) // [tokenId: index]

            //  Efficiently filter & categorize tokens in one pass
            var matchingTokens: [Token] = []
            var remainingTokens: [Token] = []
            
            for token in tokensList {
                guard token.address != "0x0000000000000000000000000000000000001010" else { continue } // Exclude immediately
                
                if enabledTokensSet.contains(token.tokenId ?? "") || (token.isUserAdded && !enabledTokensSet.contains(token.tokenId ?? "")) {
                    continue
                }

                if trendingIdsDict[token.tokenId ?? ""] != nil {
                    matchingTokens.append(token) // Trending token
                } else {
                    remainingTokens.append(token) // Non-trending token
                }
            }

            //  Sort trending tokens using precomputed index in O(n log n) time
            let sortedTrendingTokens = matchingTokens.sorted {
                let index1 = trendingIdsDict[$0.tokenId ?? ""] ?? Int.max
                let index2 = trendingIdsDict[$1.tokenId ?? ""] ?? Int.max
                return index1 < index2
            }

            //  Merge sorted trending tokens with remaining tokens
            var finalTokens = sortedTrendingTokens + remainingTokens

            //  Sort final tokens by balance, while keeping trending tokens at the top
            finalTokens.sort {
                let isTrending1 = trendingIdsDict[$0.tokenId ?? ""] != nil
                let isTrending2 = trendingIdsDict[$1.tokenId ?? ""] != nil

                // Trending tokens remain at the top
                if isTrending1 != isTrending2 {
                    return isTrending1
                }

                // Sort by balance (assending)
                return (Double($0.balance ?? "0") ?? 0) < (Double($1.balance ?? "0") ?? 0)
            }
            print("AppConstants.tokensList",self.tokensList)
            self.tokensList = finalTokens
            self.filterTokens = finalTokens
            self.tbvCoinList.reloadData()
//            DGProgressView.shared.hideLoader()
        } else {
            getTrendingTokens()
        }
    }
}

// MARK: APIS
extension CoinListViewController {

    fileprivate func allReadySaved() {
        DGProgressView.shared.showLoader(to: view)
        let allWalletTokens = (DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens] ?? [])
            .filter { $0.wallet_id == self.primaryWallet?.wallet_id }
        var filteredTokens: [Token] = []
        self.tokensList?.forEach { token in
            // Exclude unwanted tokens
            guard token.address != "0x0000000000000000000000000000000000001010",
                  token.symbol?.uppercased() != "BNRY"
                  else {
                return
            }
                filteredTokens.append(token)
        }

        // Final sorting: Prioritize "PLT" first, then sort by balance
        var finalTokens = filteredTokens
        finalTokens.sort {
            if $0.tokenId?.lowercased() == "plt" { return true }
            if $1.tokenId?.lowercased() == "plt" { return false }
            return (Double($0.balance ?? "0") ?? 0) > (Double($1.balance ?? "0") ?? 0)
        }
        // Store results and update UI
        DGProgressView.shared.hideLoader()
        self.tokensList = finalTokens
        self.filterTokens = finalTokens
        self.tbvCoinList.reloadData()
        
    }
    func getTrendingTokens() {
        DGProgressView.shared.showLoader(to: view)

        coinGraphViewModel.apiMarketVolumeData(WalletData.shared.primaryCurrency?.symbol ?? "", ids: "") { status, msg, data in
            DispatchQueue.global(qos: .userInitiated).async { // Run in background
                guard status, let trendingData = data else {
                    DispatchQueue.main.async {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                    return
                }

                // Store trending data & timestamp
                self.trendingToken = trendingData
                AppConstants.storedTokensList = trendingData
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastFetchTimestampKey)

                // Convert trending tokens to a Set for quick lookup
                let trendingIdsSet = Set(trendingData.map { $0.id })

                // Fetch Tokens & WalletTokens efficiently
                let allTokens = DatabaseHelper.shared.retrieveData("Token") as? [Token] ?? []
//                let targetAddress = "0xd07379a755a8f11b57610154861d694b2a0f615a"
//                DatabaseHelper.shared.deleteTokenIfDisabled(withAddress: targetAddress)
                
                let walletTokens = (DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens] ?? [])
                    .filter { $0.wallet_id == self.primaryWallet?.wallet_id }
                
                // Store enabled tokens in a Set for quick lookup
                let enabledTokensSet = Set(walletTokens.compactMap { $0.tokens })

                // Filter Tokens efficiently
                let filteredTokens = allTokens.filter { token in
                    guard let tokenId = token.tokenId,
                          let symbol = token.symbol?.uppercased(),
                          let address = token.address
                    else { return false }

                    return !(enabledTokensSet.contains(token) || (token.isUserAdded && !enabledTokensSet.contains(token))) &&
                           address != "0x0000000000000000000000000000000000001010" &&
                           symbol != "BNRY"
                }

                // **Partitioning Tokens Efficiently**
                var trendingTokens: [Token] = []
                var nonTrendingTokens: [Token] = []

                for token in filteredTokens {
                    if trendingIdsSet.contains(token.tokenId ?? "") {
                        trendingTokens.append(token)
                    } else {
                        nonTrendingTokens.append(token)
                    }
                }

                // Sort Trending Tokens in their original order
                let trendingTokenOrderMap = trendingData.enumerated().reduce(into: [String: Int]()) { dict, pair in
                    dict[pair.element.id] = pair.offset
                }

                trendingTokens.sort {
                    (trendingTokenOrderMap[$0.tokenId ?? ""] ?? Int.max) <
                    (trendingTokenOrderMap[$1.tokenId ?? ""] ?? Int.max)
                }

                // **Final Sorting: Prioritize "PLT" & Sort by Balance**
                var finalTokens = trendingTokens + nonTrendingTokens
                finalTokens.sort {
                    if $0.tokenId?.lowercased() == "plt" { return true }
                    if $1.tokenId?.lowercased() == "plt" { return false }
                    return (Double($0.balance ?? "0") ?? 0) > (Double($1.balance ?? "0") ?? 0)
                }

                // Store tokens in UserDefaults in the background thread
                let tokenDictionaries = finalTokens.map { $0.toDictionary() }
                UserDefaults.standard.set(tokenDictionaries, forKey: "storedTokens")
//                print("trndingTokentokensList",finalTokens)
                AppConstants.tokensList = finalTokens
                
                // UI update on main thread
                DispatchQueue.main.async {
                    DGProgressView.shared.hideLoader()
                    self.tokensList = finalTokens
                    self.filterTokens = finalTokens
                    self.tbvCoinList.reloadData()
                 
                }
            }
        }
    }
}
