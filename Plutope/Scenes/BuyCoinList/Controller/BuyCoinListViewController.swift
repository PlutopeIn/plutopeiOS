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
            
        case .some(.swap):
        
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
            
        case .none:
            break
       
        }
        
        /// Table Register
        tableRegister()
        
        /// getTokensListFromCoredata
        getTokensListFromCoredata()
        
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
        // Check if any balance is greater than 0
        let hasPositiveBalance = tokensList?.contains { Double($0.balance ?? "") ?? 0.0 > 0.0 } ?? false

        // Use the filter method based on the condition
        if hasPositiveBalance {
            self.sortedTokens = tokensList?.filter { Double($0.balance ?? "") ?? 0.0 > 0.0 }
        } else {
            self.sortedTokens = self.tokensList
            // Show all data if all balances are zero
            // No need to filter in this case
        }
        let addressToRemove = "0x0000000000000000000000000000000000001010"

        self.sortedTokens = self.sortedTokens?.filter { token in
            return token.address != addressToRemove
        }
        
        self.tokensList = self.tokensList?.filter { token in
            return token.address != addressToRemove
        }
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
            let symbol = asset.name
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false ||
            symbol?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
}
