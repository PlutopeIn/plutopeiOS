//
//  Wallets+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import UIKit
extension WalletsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for wallet in walletsList ?? [] {
            wallet.isPrimary = false
         } 
        
        DatabaseHelper.shared.updateData(entityName: "Wallets", predicateFormat: "wallet_id == %@", predicateArgs: [walletsList?[indexPath.row].wallet_id ?? 0]) { object in
            if let object = object as? Wallets {
                object.isPrimary = true
                self.primaryWalletDelegate?.setPrimaryWallet(primaryWallet: object)
                self.navigationController?.popToRootViewController(animated: true)
             } 
         } 
     }
 } 
