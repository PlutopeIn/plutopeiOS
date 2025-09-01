//
//  WalletsViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//

import UIKit
import FirebaseDynamicLinks
struct WalletDataValue: Codable {
    var walletid: UUID?
    var walletname: String?
    var mnemonic: String?
    var isPrimary: Bool
    var isManualBackup: Bool
    var isCloudBackup: Bool
    var fileName: String?
}
// MARK: - Helper Methods
struct TempWalletData {
    var fileName: String?
    var isCloudBackup: Bool?
    var isManualBackup: Bool?
    var isPrimary: Bool?
    var mnemonic: String?
    var walletid: UUID?
    var walletname: String?
}
class WalletsViewController: UIViewController, Reusable {
   
    @IBOutlet weak var lblMultiCoin: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvWallets: UITableView!
    var isFromAppUpdated = ""
    var walletsList: [Wallets]?
    var primaryWallet: Wallets?
    var tempPrimaryWallet: Wallets?
    var arrReferallCode : ReferallCodeDataList?
    var activeToken: [ActiveTokens]? = []
    var tokensList: [Token]? = []
    var tempPrimaryWalletData: TempWalletData?
    weak var primaryWalletDelegate: PrimaryWalletDelegate?
    
    weak var updatedWalletWalletDelegate: UpdatedWalletWalletDelegate?
    var  objectsToShare = [Any]()
    
    lazy var referallCodeViewModel: ReferallCodeViewModel = {
        ReferallCodeViewModel { _ ,_ in
        }
    }()
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    lazy var tokenListViewModel: TokenListViewModel = {
        TokenListViewModel { status,_ in
            if status == false {
                //  self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallets, comment: ""), btnRightImage: UIImage.addwallet, btnRightAction: {
            HapticFeedback.generate(.light)
            let viewToNavigate = WalletSetUpViewController()
            viewToNavigate.isFromWallets = true
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        })
        self.isFromAppUpdated  = UserDefaults.standard.value(forKey: isFromAppUpdatedKey) as? String ?? ""
        self.lblMultiCoin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.multicoinwallets, comment: "")
        
        /// Table Register
        tableRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.walletsList = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
        self.tbvWallets.reloadData()
    }
    
    /// Table Register
    private func tableRegister() {
        tbvWallets.register(WalletsViewCell.nib, forCellReuseIdentifier: WalletsViewCell.reuseIdentifier)
        tbvWallets.delegate = self
        tbvWallets.dataSource = self
     } 
 } 
