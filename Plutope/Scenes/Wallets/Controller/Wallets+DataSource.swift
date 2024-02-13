//
//  Wallets+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import UIKit
extension WalletsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        walletsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvWallets.dequeueReusableCell(indexPath: indexPath) as WalletsViewCell
        let data = walletsList?[indexPath.row]
        cell.selectionStyle = .none
        
        cell.lblWalletName.text = data?.wallet_name
        //cell.lblWalletType.text = "Multi-Coin Wallet"
        cell.lblWalletType.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.multicoinwallets, comment: "")
        if data?.isPrimary ?? false {
            cell.ivCheckWallet.isHidden = false
        } else {
            cell.ivCheckWallet.isHidden = true
        }
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(openWalletRecovery), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    @objc func openWalletRecovery(_ sender: UIButton) {
        let viewToNavigate = WalletRecoveryViewController()
        viewToNavigate.wallet = walletsList?[sender.tag]
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
}
