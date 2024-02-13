//
//  WalletsViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//

import UIKit

class WalletsViewController: UIViewController, Reusable {
   
    @IBOutlet weak var lblMultiCoin: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvWallets: UITableView!
    
    var walletsList: [Wallets]?
    weak var primaryWalletDelegate: PrimaryWalletDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallets, comment: ""), btnRightImage: UIImage.buy, btnRightAction: {
            let viewToNavigate = WalletSetUpViewController()
            viewToNavigate.isFromWallets = true
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        })
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
