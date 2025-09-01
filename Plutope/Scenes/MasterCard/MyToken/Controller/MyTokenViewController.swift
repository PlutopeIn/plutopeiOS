//
//  MyTokenViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import UIKit

protocol TopupWalletDelegate:AnyObject {
    func selectedToken(tokenName:String,tokenimage:String? ,tokenbalance:String,tokenAmount:String,tokenCurruncy:String,tokenArr:Wallet?,currency:String,isFromToken1:String?)
}

class MyTokenViewController: UIViewController ,Reusable {
    @IBOutlet weak var ivAddToken: UIImageView!
    
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvCards: UITableView!
    @IBOutlet weak var headerView: UIView!
    var isFromMyTokenVC = false
    var arrWalletList : [Wallet] = []
    var filterTokens : [Wallet] = []
    var primaryWallet: Wallets?
    var allowOperations :[String] = []
    var arrCurrencyList : [String] = []
    var isFrom = ""
    var isFromToken1 = false
    let server = serverTypes
    var isSearching: Bool = false
    weak var delegate : TopupWalletDelegate?
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,message in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("RefreshToken"), object: nil)
        /// Table Register
        tableRegister()
        if self.isFrom == "topupVC" || self.isFrom == "payment" || self.isFrom == "buyCrypto"  {
            self.filterTokens = self.arrWalletList
        } else if self.isFrom == "exchnageCrypto" {
            let filteredData = self.arrWalletList.filter { $0.allowOperations?.contains("EXCHANGE") ?? false }
            self.arrWalletList = filteredData
            self.filterTokens = self.arrWalletList
        }  else if self.isFrom == "withdrawCrypto" {
            let filteredData = self.arrWalletList.filter { $0.allowOperations?.contains("PAYOUT_CRYPTO") ?? false }
            self.arrWalletList = filteredData
            self.filterTokens = self.arrWalletList
        } else {
//            if server == .live {
                self.getWalletTokensNew()
//            } else {
//                self.getWalletTokens()
//            }
        }
        txtSearch.delegate = self
        if isFrom == "topupVC" || isFrom == "payment" || isFrom == "sendCardWallet" || isFrom == "buyCrypto" || self.isFrom == "exchnageCrypto" || self.isFrom == "withdrawCrypto" || self.isFrom == "receive" {
           // headerView.isHidden = true
            headerView.isHidden = false
            ivAddToken.isHidden = true
            headerHeight.constant = 70
            // headerHeight.constant = 0
            defineHeader(headerView: headerView, titleText: "", btnBackHidden: true,btnRightImage: UIImage.cancel) {
                print("clicked")
                HapticFeedback.generate(.light)
                self.dismiss(animated: true)
                
            }
        } else {
            headerView.isHidden = false
            ivAddToken.isHidden = true
            headerHeight.constant = 70
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.digitalAssets, comment: ""), btnBackHidden: false)
        }
        ivAddToken.addTapGesture {
            HapticFeedback.generate(.light)
            let vcToPresent = AddCardTokenViewController()
            vcToPresent.modalTransitionStyle = .coverVertical
            vcToPresent.modalPresentationStyle = .pageSheet
            vcToPresent.primaryWallet = self.primaryWallet
            vcToPresent.isFromMyTokenVC = true
            vcToPresent.refreshCardTokenDelegate = self
            self.present(vcToPresent, animated: true)
        }
    }
    @objc func refreshData() {
//        if server == .live {
            self.getWalletTokensNew()
//        } else {
//            self.getWalletTokens()
//        }
//           self.getWalletTokens()
            print("Refresh data called")
      }
    deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshToken"), object: nil)
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
    func tableRegister() {
        tbvCards.delegate = self
        tbvCards.dataSource = self
        tbvCards.register(MyTokenTableViewCell.nib, forCellReuseIdentifier: MyTokenTableViewCell.reuseIdentifier)

    }
//    func getWalletTokens() {
//        DGProgressView.shared.showLoader(to: view)
//        myTokenViewModel.getTokenAPI { status, data,fiat ,msg  in
//            if status == 1 {
//                DGProgressView.shared.hideLoader()
////                if self.isFrom == "topupVC" || self.isFrom == "payment" {
////
////                    let filteredData = data?.filter { $0.allowOperations?.contains("CP_2_PAYLOAD") ?? false }
////                    self.arrWalletList = filteredData ?? []
////                } else {
////                    let filteredData = data?.filter { $0.allowOperations?.contains("PAYIN_CRYPTO") ?? false }
//////                    self.arrWalletList = filteredData ?? []
//                self.arrWalletList = data ?? []
//               // }
//               
//                self.filterTokens = self.arrWalletList
//                DispatchQueue.main.async {
//                    self.tbvCards.reloadData()
//                    self.tbvCards.restore()
//                }
//                
//            } else {
//                DGProgressView.shared.hideLoader()
//            }
//            
//        }
//    }
    func getWalletTokensNew() {
        tbvCards.showLoader()
        myTokenViewModel.getTokenAPINew { status, data,fiat ,msg in
            if status == 1 {
//                DGProgressView.shared.hideLoader()
                self.arrWalletList = data ?? []
                self.filterTokens = self.arrWalletList
                DispatchQueue.main.async {
                    self.tbvCards.hideLoader()
                    self.tbvCards.reloadData()
                    self.tbvCards.restore()
                }
            } else {
                self.tbvCards.hideLoader()
//                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
}
extension MyTokenViewController : RefreshCardTokenDelegate {
    func refreshCardTokenDelegateToken() {
//        if server == .live {
            self.getWalletTokensNew()
//        } else {
//            self.getWalletTokens()
//        }
//        self.getWalletTokens()
    }
}
// MARK: UITextFieldDelegate
extension MyTokenViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            self.arrWalletList = filterTokens
        }
        tbvCards.reloadData()
    }
    
    func filterAssets(with searchText: String) {
        self.arrWalletList = filterTokens.filter { asset in
            let type = asset.name
            let currency = asset.currency
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false || currency?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
}
