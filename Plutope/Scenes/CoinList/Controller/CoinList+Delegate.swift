//
//  CoinList+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
import CoreData
import IQKeyboardManagerSwift
extension CoinListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isFromDash {
            let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
            let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
            walletTokenEntity.id = UUID()
            walletTokenEntity.wallet_id = primaryWallet?.wallet_id
            walletTokenEntity.tokens = self.tokensList?[indexPath.row]
            DatabaseHelper.shared.saveData(walletTokenEntity) { status in
                if status {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.enabledTokenDelegate?.selectEnabledToken((self.tokensList?[indexPath.row])!)
                        }
                    }
                } else {
                    self.dismiss(animated: true)
                }
            }
        } else {
            self.tokensList?[indexPath.row].callFunction.getBalance(completion: { bal in
                
                self.coinGeckoViewModel.apiMarketVolumeData("\(WalletData.shared.primaryCurrency?.symbol ?? "")", ids: self.tokensList?[indexPath.row].tokenId ?? "") { _,_,data in
                    if let data = data, let assets = data.first {
                        DispatchQueue.main.async {
                            let symbol = (assets.symbol ?? "").uppercased()
                            DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "symbol == %@ AND address == %@", predicateArgs: [self.tokensList?[indexPath.row].symbol ?? "" ,self.tokensList?[indexPath.row].address ?? ""]) { object in
                                if let token = object as? Token {
                                    token.balance = bal
                                    let price = assets.currentPrice ?? 0.0
                                    token.price = "\(price)"
                                    token.logoURI = assets.image ?? ""
                                    
                                    let roundVal = WalletData.shared.formatDecimalString("\(assets.priceChangePercentage24H ?? 0.0)", decimalPlaces: 2)
                                    token.lastPriceChangeImpact = roundVal
                                    DispatchQueue.main.async {
                                        if (self.tokensList?.count ?? 0) != 0 {
                                            self.dismiss(animated: true) {
                                                if self.isPayCoin {
                                                    self.swapDelegate?.selectPayCoin(self.tokensList?[indexPath.row] ?? nil)
                                                } else {
                                                    self.swapDelegate?.selectGetCoin(self.tokensList?[indexPath.row] ?? nil)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}

// MARK: - UITextFieldDelegate
extension CoinListViewController: UITextFieldDelegate {
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.inputView?.reloadInputViews()
        if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            self.tokensList = filterTokens
        } else {
            filterAssets(with: textField.text ?? "")
        }
       
        tbvCoinList.reloadData()
        
    }
    
    func filterAssets(with searchText: String) {
        self.tokensList = filterTokens?.filter { asset in
            let type = asset.type
            let symbol = asset.symbol
            
            // Check if the symbol is an exact match with the search text
            let isSymbolMatch = symbol?.localizedCaseInsensitiveCompare(searchText) == .orderedSame
            
            // Match the entered text with name or symbol
            return isSymbolMatch || type?.localizedCaseInsensitiveContains(searchText) ?? false || symbol?.localizedCaseInsensitiveContains(searchText) ?? false
        }.sorted { asset1, asset2 in
            // Custom sorting logic to prioritize exact matches first
            let symbol1 = asset1.symbol ?? ""
            let symbol2 = asset2.symbol ?? ""
            let isSymbol1Match = symbol1.localizedCaseInsensitiveCompare(searchText) == .orderedSame
            let isSymbol2Match = symbol2.localizedCaseInsensitiveCompare(searchText) == .orderedSame
            
            // If both symbols are the same or both are not an exact match,
            // sort based on asset name
            if isSymbol1Match == isSymbol2Match {
                let name1 = asset1.type ?? ""
                let name2 = asset2.type ?? ""
                return name1.localizedCaseInsensitiveCompare(name2) == .orderedAscending
            } else {
                // If one is an exact match and the other is not, prioritize exact matches first
                return isSymbol1Match
            }
        }
    }
}
