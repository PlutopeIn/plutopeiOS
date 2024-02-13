//
//  CoinListViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit

class CoinListViewController: UIViewController {
    
    @IBOutlet weak var tbvCoinList: UITableView!
    @IBOutlet weak var txtSearch: customTextField!
    
    var primaryWallet: Wallets?
    var payCoinDetail: Token?
    var tokensList: [Token]? = []
    var filterTokens: [Token]? = []
    var pairData: [ExchangePairsData] = []
    var fromCurrency,fromNetwork: String?
    var toNetwork = ["eth","bsc","matic","btc"]
    weak var swapDelegate: SwappingCoinDelegate?
    weak var enabledTokenDelegate: EnabledTokenDelegate?
    var isPayCoin = false
    var isFromDash = false
    var isFromNFT = false
    var index = 0
    
    lazy var viewModel: SwappingViewModel = {
        SwappingViewModel { _,message in
           // self.showToast(message: message, font: .systemFont(ofSize: 15))
            DGProgressView.shared.hideLoader()
        }
    }()
    lazy var coinGeckoViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
          //  self.showToast(message: message, font: .systemFont(ofSize: 15))
            DGProgressView.shared.hide()
        }
    }()
    lazy var coinGraphViewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
          //  self.showToast(message: message, font: .systemFont(ofSize: 15))
            DGProgressView.shared.hide()
        }
    }()
    
    var trendingToken: [MarketData]? = []
    var isOkx = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        
        /// Table Register
        tableRegister()
        
        /// getTokensListFromCoredata
        getTokensListFromCoredata()
        
        txtSearch.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
    }
    /// Table Register
    fileprivate func tableRegister() {
        tbvCoinList.delegate = self
        tbvCoinList.dataSource = self
        tbvCoinList.register(CoinListViewCell.nib, forCellReuseIdentifier: CoinListViewCell.reuseIdentifier)
    }
    
    /// getTokensListFromCoredata
    fileprivate func getTokensListFromCoredata() {
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        print(self.tokensList?.compactMap { $0.tokenId })
        if !isFromDash && !isPayCoin {
            if payCoinDetail?.type != "KIP20" && !isOkx {
                self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
//                self.tokensList = self.tokensList?.filter({ token in
//                    if token.address != "0x0000000000000000000000000000000000001010" {
//                        return true
//                    } else {
//                        return false
//                    }
//                })
                DGProgressView.shared.showLoader(to: self.view)
                filterTokens = tokensList
                getExchangePairsToken(fromCurrency: fromCurrency ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork[self.index])
            } else if isOkx {
                tokensList = tokensList?.filter { ($0.type == payCoinDetail?.type ?? "") && $0 != payCoinDetail }
                
                self.tokensList = self.tokensList?.filter({ token in
                    if token.address != "0x0000000000000000000000000000000000001010" {
                        return true
                    } else {
                        return false
                    }
                })
                if self.tokensList?.count != 0 {
                   filterTokens = tokensList
                   tbvCoinList.reloadData()
                }
            } else {
                tokensList = tokensList?.filter { $0.type == "KIP20" && $0 != payCoinDetail}
                if self.tokensList?.count != 0 {
                   filterTokens = tokensList
                   tbvCoinList.reloadData()
                }
            }
           
        } else {
            /// Action if tapped from dashboard
           getTrendingTokens()
        }
    }
}

// MARK: APIS
extension CoinListViewController {
    func getExchangePairsToken(fromCurrency: String, fromNetwork: String, toNetwork: String) {
        
        viewModel.apiGetExchangePairs(fromCurrency: fromCurrency, fromNetwork: fromNetwork, toNetwork: toNetwork) { tokenPairs, status, _ in
            if status {
                self.pairData.append(contentsOf: tokenPairs ?? [])
                self.index += 1
                if self.index < self.toNetwork.count {
                    self.getExchangePairsToken(fromCurrency: self.fromCurrency ?? "", fromNetwork: self.fromNetwork ?? "", toNetwork: self.toNetwork[self.index])
                } else {
                    
                    self.pairData = Array(Set(self.pairData))
                    
                    let toCurrencyList = self.pairData.compactMap { $0.toCurrency }
                    self.tokensList = self.tokensList?.filter({ token in
                        if toCurrencyList.contains(token.symbol?.lowercased() ?? "") && (token.type == "ERC20" || token.type == "POLYGON" || token.type == "BEP20" || token.type == "BTC") && token != self.payCoinDetail && token.address != "0x0000000000000000000000000000000000001010" {
                            return true
                        } else {
                                return false
                        }
                        
                    })
                    let sortedFinalTokens = self.tokensList?.sorted { $0.balance ?? "" > $1.balance ?? "" }
                    
                    self.tokensList = sortedFinalTokens
                    self.filterTokens = self.tokensList
                    self.tbvCoinList.reloadData()
                    DGProgressView.shared.hideLoader()
                }
            } else {
                DGProgressView.shared.hideLoader()
            }
        }
    }
    
    func getTrendingTokens() {
        coinGraphViewModel.apiMarketVolumeData(WalletData.shared.primaryCurrency?.symbol ?? "", ids: "") { _,_,data in
            if data != nil {
                self.trendingToken = data
                var allWalletTokens = DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens]
                allWalletTokens = allWalletTokens?.filter { $0.wallet_id == self.primaryWallet?.wallet_id }
                let enabledTokens = allWalletTokens?.compactMap { $0.tokens }
                self.tokensList = self.tokensList?.filter({ token in
                    if token.address != "0x0000000000000000000000000000000000001010" {
                        if enabledTokens?.contains(token) ?? false || (token.isUserAdded && !(enabledTokens?.contains(token) ?? false)) {
                            return false
                        } else {
                            return true
                            
                        }
                    } else {
                        print("no address")
                        return false
                    }
                    
                })
             
                let trendingIds = self.trendingToken?.compactMap { $0.id }
                let matchingTokens = self.tokensList?.filter { trendingIds?.contains($0.tokenId ?? "") ?? false }
                let remainingTokens = self.tokensList?.filter { !(trendingIds?.contains($0.tokenId ?? "") ?? false) }

                // Sort matchingTokens based on the order of ids
                let sortedMatchingTokens = matchingTokens?.sorted { token1, token2 in
                    guard let index1 = trendingIds?.firstIndex(of: token1.tokenId ?? ""),
                          let index2 = trendingIds?.firstIndex(of: token2.tokenId ?? "") else {
                        return false // Handle the case where tokenId is not found in ids array
                    }
                    return index1 < index2
                }

                // Combine sortedMatching Tokens and remainingTokens
                let finalTokens = (sortedMatchingTokens ?? []) + (remainingTokens ?? [])
                let sortedFinalTokens = finalTokens.sorted { $0.balance ?? "" > $1.balance ?? "" }
                self.tokensList = sortedFinalTokens
                self.filterTokens = sortedFinalTokens
                self.tbvCoinList.reloadData()
            }
        }
    }
}
