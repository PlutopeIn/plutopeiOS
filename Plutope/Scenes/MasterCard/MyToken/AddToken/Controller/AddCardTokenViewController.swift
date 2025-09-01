//
//  AddCardTokenViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import UIKit

class AddCardTokenViewController: UIViewController {
    
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var tbvCoinList: UITableView!
    var primaryWallet: Wallets?
    var isFromMyTokenVC = false
    var selectedTokenArray = [String]()
    var filterTokens: [SupportedVaultCurrency]? = []
    var isSearching: Bool = false
    weak var refreshCardTokenDelegate : RefreshCardTokenDelegate?
    var curruncyList:[SupportedVaultCurrency] = []
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,message in
        }
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        txtSearch.delegate = self
        /// Table Register
        tableRegister()
        self.curruncyList = [
            SupportedVaultCurrency(symbol: "BAT"),
            SupportedVaultCurrency(symbol: "BTC"),
            SupportedVaultCurrency(symbol: "CHO"),
            SupportedVaultCurrency(symbol: "CRPT"),
            SupportedVaultCurrency(symbol: "DAI"),
            SupportedVaultCurrency(symbol: "DAO"),
            SupportedVaultCurrency(symbol: "ETH"),
            SupportedVaultCurrency(symbol: "GALA"),
            SupportedVaultCurrency(symbol: "LINK"),
            SupportedVaultCurrency(symbol: "LTC"),
            SupportedVaultCurrency(symbol: "MANA"),
            SupportedVaultCurrency(symbol: "MAPS"),
            SupportedVaultCurrency(symbol: "MATIC"),
            SupportedVaultCurrency(symbol: "MKR"),
            SupportedVaultCurrency(symbol: "OMG"),
            SupportedVaultCurrency(symbol: "QASH"),
            SupportedVaultCurrency(symbol: "REP"),
            SupportedVaultCurrency(symbol: "SAND"),
            SupportedVaultCurrency(symbol: "SHIB"),
            SupportedVaultCurrency(symbol: "UNI"),
            SupportedVaultCurrency(symbol: "USDC"),
            SupportedVaultCurrency(symbol: "USDT"),
            SupportedVaultCurrency(symbol: "XRP"),
            SupportedVaultCurrency(symbol: "ZRX")
        ]
        self.filterTokens = self.curruncyList
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
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
        tbvCoinList.allowsMultipleSelection = true
        tbvCoinList.register(CardMainViewCell.nib, forCellReuseIdentifier: CardMainViewCell.reuseIdentifier)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        appendSelectedCoins()
    }
    
}

// MARK: APIS
extension AddCardTokenViewController {
    func createWallet(tokenList: [String]) {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.createWalletAPI(currencies: tokenList) { status, msg, data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
                self.dismiss(animated: true)
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
                self.dismiss(animated: true)
            }
            self.refreshCardTokenDelegate?.refreshCardTokenDelegateToken()
        }
    }
    
     func appendSelectedCoins() {
        let index = tbvCoinList.indexPathsForSelectedRows ?? []
        selectedTokenArray.removeAll()
        for inx in index {
            self.selectedTokenArray.append(curruncyList[inx.row].symbol.lowercased())
            let uniqueUnordered = Array(Set(self.selectedTokenArray))
            self.selectedTokenArray = uniqueUnordered
            print(selectedTokenArray)
        }
         self.createWallet(tokenList: self.selectedTokenArray)
        
    }
    
}
