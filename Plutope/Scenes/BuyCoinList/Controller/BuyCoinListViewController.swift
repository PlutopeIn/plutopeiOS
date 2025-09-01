//
//  BuyCoinListViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit

class BuyCoinListViewController: UIViewController, Reusable {
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvBuyCoin: UITableView!
    var primaryCurrency: Currencies?
    var isFrom: CoinList? = .send
    var fromDashbord = ""
    lazy var primaryWallet: Wallets? = nil
    var tokensList: [Token]? = []
    var filterTokens: [Token]? = []
    var sortedTokens: [Token]? = []
    weak var swapDelegate: SwappingCoinDelegate?
    weak var enabledTokenDelegate: EnabledTokenDelegate?
    var isPayCoin = false
    var isFromDash = false
    var minimumAmount: Double = Double()
    var isSearching: Bool = false
    weak var selectNetworkDelegate: SelectNetworkDelegate?
    lazy var viewModel: CoinMinPriceViewModel = {
        CoinMinPriceViewModel { status, message in
            if status == false {
               // self.showToast(message: message, font: .systemFont(ofSize: 15))
            }
        }
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
//        /// getTokensListFromCoredata
//        getTokensListFromCoredata()
            }
    override func viewDidLoad() {
        super.viewDidLoad()
        /// getTokensListFromCoredata
        getTokensListFromCoredata()
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        /// Navigation Header
        switch isFrom {
        case .send:
         
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: ""))
            
        case .buy:
          
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: ""))
            
        case .receive:
       
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: ""))
            
        case .receiveNFT:
           
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receivenft, comment: ""))
            
        case .addCustomToken:
           
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.network, comment: ""))
            
        case .swap:
        
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        case .search:
            defineHeader(headerView: headerView, titleText: "")
        case .none:
            break
        }
        
        /// Table Register
        tableRegister()
        self.tbvBuyCoin.reloadData()
        txtSearch.delegate = self
        
    }
    
    /// Table Register
    func tableRegister() {
        tbvBuyCoin.delegate = self
        tbvBuyCoin.dataSource = self
        tbvBuyCoin.register(PurchasedCoinViewCell.nib, forCellReuseIdentifier: PurchasedCoinViewCell.reuseIdentifier)
        tbvBuyCoin.register(CoinListViewCell.nib, forCellReuseIdentifier: CoinListViewCell.reuseIdentifier)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        isSearching = false
    }
    /// getTokensListFromCoredata
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable:next function_body_length
    fileprivate func getTokensListFromCoredata() {
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        
        if (tokensList == nil) {
            self.showToast(message: "No Data", font: AppFont.regular(15).value)
        } else {
            switch isFrom {
            case .receiveNFT :
//                self.tokensList = tokensList?.filter({ token in
//                    if (token.address == "") && (token.symbol == "ETH" || token.symbol == "POL" || token.symbol == "BNB" || token.symbol == "OKT" || token.symbol == "op" || token.symbol == "ARB" || token.symbol == "AVAX" || token.symbol == "base" ) {
//                        return true
//                    } else {
//                        return false
//                    }
//                })
//                self.sortedTokens = tokensList
//                let addressToRemove = "0x0000000000000000000000000000000000001010"
//
//                // Filter out the addressToRemove
//                self.sortedTokens = self.sortedTokens?.filter { token in
//                    return token.address != addressToRemove
//                }
//
//                self.sortedTokens = self.sortedTokens?.filter({ token1 in
//                    token1.symbol != "bnry".uppercased()
//                })
//                // Sort by balance from high to low
//                self.sortedTokens = self.sortedTokens?.sorted(by: { token1, token2 in
//                    if token1.tokenId == "PLT".lowercased() {
//                           return true  // Always keep PLT first
//                    } else if token2.tokenId == "PLT".lowercased() {
//                           return false // Ensure PLT stays on top
//                       }
//                       
//                    if let balance1 = Double(token1.balance ?? "0"), let balance2 = Double(token2.balance ?? "0") {
//                        return balance1 > balance2
//                    }
//                    return false
//                })
//
//                // Print the sorted tokens
//                if let sortedTokens = self.sortedTokens {
//                    for token in sortedTokens {
//                        
//                    }
//                }
//                self.filterTokens = self.tokensList
//                self.tbvBuyCoin.reloadData()
                if primaryWallet == nil {
                    if let allWallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] {
                        primaryWallet = allWallets.first(where: { $0.isPrimary })
                    }
                }

                guard let primaryWallet = primaryWallet else {
                    print(" No primary wallet found")
                    return
                }

                // Retrieve enabled tokens for the primary wallet
                let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: primaryWallet.wallet_id?.uuidString ?? "")
                let enableTokens = getPrimaryWalletToken?.compactMap { $0.tokens } ?? []

                // Get all available tokens
                let allTokens = tokensList ?? []
                let addressToRemove = "0x0000000000000000000000000000000000001010"

                // Choose list to filter
                var filteredTokens = enableTokens.isEmpty ? allTokens : enableTokens

                // **Apply filtering efficiently**
                filteredTokens = filteredTokens.filter { token in
                    token.address != addressToRemove &&
                    token.symbol?.uppercased() != "BNRY"
                }

                // **Remove PLT if isFrom is .buy or .swap**
                if isFrom == .buy || isFrom == .swap {
                    filteredTokens.removeAll { $0.tokenId?.lowercased() == "plt" }
                }
                filteredTokens = filteredTokens.sorted(by: { token1, token2 in
                    // Always keep PLT first if isFrom
                        if token1.tokenId == "PLT".lowercased() {
                            return true  // Always keep PLT first
                        } else if token2.tokenId == "PLT".lowercased() {
                            return false // Ensure PLT stays on top
                        }

                    if let balance1 = Double(token1.balance ?? "0"), let balance2 = Double(token2.balance ?? "0") {
                        return balance1 > balance2
                    }
                    return false
                })

                print("✅ Final Filtered Tokens Count: \(filteredTokens.count)")

                // Assign filtered list to UI
                self.sortedTokens = filteredTokens
                self.tokensList = filteredTokens
                self.filterTokens = filteredTokens
                self.tbvBuyCoin.reloadData()
            case .addCustomToken :
                
                self.tokensList = tokensList?.filter({ token in
                    if (token.address == "") && (token.symbol == "ETH" || token.symbol == "POL" || token.symbol == "BNB" || token.symbol == "OKT" || token.symbol == "OP" || token.symbol == "ARB" || token.symbol == "AVAX" || token.symbol == "BASE" ) {
                        return true
                    } else {
                        return false
                    }
                })
                self.sortedTokens = tokensList
                let addressToRemove = "0x0000000000000000000000000000000000001010"

                // Filter out the addressToRemove
                self.sortedTokens = self.sortedTokens?.filter { token in
                    return token.address != addressToRemove
                }
                self.sortedTokens = self.sortedTokens?.filter({ token1 in
                    token1.symbol != "bnry".uppercased()
                })
                // Sort by balance from high to low
                self.sortedTokens = self.sortedTokens?.sorted(by: { token1, token2 in
                    if token1.tokenId == "PLT".lowercased() {
                           return true  // Always keep PLT first
                       } else if token2.tokenId == "PLT".lowercased() {
                           return false // Ensure PLT stays on top
                       }
                       
                    if let balance1 = Double(token1.balance ?? "0"), let balance2 = Double(token2.balance ?? "0") {
                        return balance1 > balance2
                    }
                    return false
                })
                // Print the sorted tokens
                
                self.filterTokens = self.tokensList
                self.tbvBuyCoin.reloadData()
            default:
                if primaryWallet == nil {
                    if let allWallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] {
                        primaryWallet = allWallets.first(where: { $0.isPrimary })
                    }
                }

                guard let primaryWallet = primaryWallet else {
                    print(" No primary wallet found")
                    return
                }

                // Retrieve enabled tokens for the primary wallet
                let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: primaryWallet.wallet_id?.uuidString ?? "")
                let enableTokens = getPrimaryWalletToken?.compactMap { $0.tokens } ?? []

                // Get all available tokens
                let allTokens = tokensList ?? []
                let addressToRemove = "0x0000000000000000000000000000000000001010"

                // Choose list to filter
                var filteredTokens = enableTokens.isEmpty ? allTokens : enableTokens

                // **Apply filtering efficiently**
                filteredTokens = filteredTokens.filter { token in
                    token.address != addressToRemove &&
                    token.symbol?.uppercased() != "BNRY"
                }

                // **Remove PLT if isFrom is .buy or .swap**
                if isFrom == .buy || isFrom == .swap {
                    filteredTokens.removeAll { $0.tokenId?.lowercased() == "plt" }
                }
                filteredTokens = filteredTokens.sorted(by: { token1, token2 in
                    // Always keep PLT first if isFrom
                        if token1.tokenId == "PLT".lowercased() {
                            return true  // Always keep PLT first
                        } else if token2.tokenId == "PLT".lowercased() {
                            return false // Ensure PLT stays on top
                        }

                    if let balance1 = Double(token1.balance ?? "0"), let balance2 = Double(token2.balance ?? "0") {
                        return balance1 > balance2
                    }
                    return false
                })

                print("✅ Final Filtered Tokens Count: \(filteredTokens.count)")

                // Assign filtered list to UI
                self.filterTokens = tokensList
                self.sortedTokens = filteredTokens
                self.tokensList = filteredTokens
                self.tbvBuyCoin.reloadData()
                
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension BuyCoinListViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            self.tokensList = filterTokens
            self.sortedTokens = filterTokens
        }
        tbvBuyCoin.reloadData()
    }
    
//    func filterAssets(with searchText: String) {
//        self.tokensList = filterTokens?.filter { asset in
//            let type = asset.type
//            let symbol = asset.symbol
//            
//            // Match the entered text with name or symbol
//            return type?.localizedCaseInsensitiveContains(searchText) ?? false ||
//            symbol?.localizedCaseInsensitiveContains(searchText) ?? false 
//        }
//    }
    func filterAssets(with searchText: String) {
        let lowercasedSearch = searchText.lowercased()

        // ✅ Filter tokens efficiently
        let filtered = filterTokens?.filter { asset in
            guard let symbol = asset.symbol?.lowercased(),
                  let type = asset.type?.lowercased(),
                  let name = asset.name?.lowercased() else { return false }

            return (!symbol.isEmpty && symbol.contains(lowercasedSearch)) ||
                   type.contains(lowercasedSearch) ||
                   name.contains(lowercasedSearch)
        } ?? []

        //  Separate exact matches and partial matches
        let exactMatches = filtered.filter { $0.symbol?.lowercased() == lowercasedSearch }
        let partialMatches = filtered.filter { $0.symbol?.lowercased() != lowercasedSearch }

        //  Merge exact + partial matches & sort in assending order by balance
        self.tokensList = (exactMatches + partialMatches).sorted {
            (Double($0.balance ?? "0") ?? 0) > (Double($1.balance ?? "0") ?? 0)
        }
        self.sortedTokens = (exactMatches + partialMatches).sorted {
            (Double($0.balance ?? "0") ?? 0) > (Double($1.balance ?? "0") ?? 0)
        }
    }
    
}
