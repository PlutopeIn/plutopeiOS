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
    
    var isFrom: CoinList? = .send
    
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
        /// getTokensListFromCoredata
        getTokensListFromCoredata()
            }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
        case .none:
            break
       
        }
        
        /// Table Register
        tableRegister()
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
    fileprivate func getTokensListFromCoredata() {
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        
        if (tokensList == nil) {
            self.showToast(message: "No Data", font: AppFont.medium(15).value)
        } else {
            switch isFrom {
            case .receiveNFT :
                self.tokensList = tokensList?.filter({ token in
                    if (token.address == "" && token.type != "KIP20") && (token.symbol == "ETH" || token.symbol == "MATIC" || token.symbol == "BNB") {
                        return true
                    } else {
                        return false
                    }
                })
                
            case .addCustomToken :
                
                self.tokensList = tokensList?.filter({ token in
                    if (token.address == "") && (token.symbol == "ETH" || token.symbol == "MATIC" || token.symbol == "BNB" || token.symbol == "OKT") {
                        return true
                    } else {
                        return false
                    }
                })
                
            default: break
                
            }
        }
        
        if primaryWallet == nil {
            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            primaryWallet = allWallet?.first(where: { $0.isPrimary })
            // WalletData.shared.wallet = HDWallet(mnemonic: primaryWallet?.mnemonic ?? "", passphrase: "")
        }
        
        guard let primaryWallet = primaryWallet else {
            // Handle the case when primaryWalletID is nil
            return
        }
        let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
        let enableTokens = getPrimaryWalletToken?.compactMap { $0.tokens  }
        
        let alreadyEnabled = enableTokens?.first(where: { $0.address == tokensList?.first?.address })
        if let tokensList = tokensList, let enableTokens = enableTokens {
            let isAnyTokenEnabled = tokensList.contains { token in
                enableTokens.contains { $0.address == token.address }
            }

            if isAnyTokenEnabled {
                self.sortedTokens = enableTokens
                let addressToRemove = "0x0000000000000000000000000000000000001010"

                // Filter out the addressToRemove
                self.sortedTokens = self.sortedTokens?.filter { token in
                    return token.address != addressToRemove
                }

                // Sort by balance from high to low
                self.sortedTokens = self.sortedTokens?.sorted(by: { $0.balance ?? "" > $1.balance ?? "" })

                // Print the sorted tokens
                if let sortedTokens = self.sortedTokens {
                    for token in sortedTokens {
                        print(token.balance)
                    }
                }
            } else {
                self.tokensList = tokensList
            }
        }

        let addressToRemove = "0x0000000000000000000000000000000000001010"

        self.tokensList = self.tokensList?.filter { token in
            return token.address != addressToRemove
        }
        print(tokensList)
        self.filterTokens = self.tokensList
        self.tbvBuyCoin.reloadData()
        
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
        }
        tbvBuyCoin.reloadData()
    }
    
    func filterAssets(with searchText: String) {
        self.tokensList = filterTokens?.filter { asset in
            let type = asset.type
            let symbol = asset.symbol
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false ||
            symbol?.localizedCaseInsensitiveContains(searchText) ?? false 
        }
    }
    
}
