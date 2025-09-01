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
        HapticFeedback.generate(.light)
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
            
//                }
//                else{
//                    self.dismiss(animated: true)
//                }
                
//            }
            
        } else if isFrom == "swap"{
            guard let selectedToken = self.tokensList?[indexPath.row] else { return }

               // ✅ 1. Dismiss immediately and notify delegate
               self.dismiss(animated: true) {
                   if self.isPayCoin {
                       self.swapDelegate?.selectPayCoin(selectedToken)
                   } else {
                       self.swapDelegate?.selectGetCoin(selectedToken)
                   }
                   self.enabledTokenDelegate?.selectEnabledToken(selectedToken)
               }

               // ✅ 2. Run balance + price fetch in background
               selectedToken.callFunction.getBalance { [weak self] bal in
                   guard let self = self else { return }

                   let tokenId = selectedToken.tokenId ?? ""
                   let address = selectedToken.address?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                   let symbol = selectedToken.symbol?.uppercased() ?? ""
                   let primaryCurrencySymbol = WalletData.shared.primaryCurrency?.symbol ?? ""

                   self.coinGeckoViewModel.apiMarketVolumeData(primaryCurrencySymbol, ids: tokenId) { status, msg, data in
                       guard status, let assets = data?.first else {
                           DispatchQueue.main.async {
                               self.showToast(message: msg, font: .systemFont(ofSize: 15))
                           }
                           return
                       }

                       // ✅ 3. Update database with balance and price
                       DatabaseHelper.shared.updateData(
                           entityName: "Token",
                           predicateFormat: "tokenId == %@ AND address == %@ AND symbol == %@",
                           predicateArgs: [tokenId, address, symbol]
                       ) { object in
                           guard let token = object as? Token else { return }

                           let balanceValue = bal ?? "0"
                           token.balance = balanceValue
                           token.price = "\(assets.currentPrice ?? 0.0)"
                           token.logoURI = assets.image ?? ""
                           token.lastPriceChangeImpact = String(format: "%.2f", assets.priceChangePercentage24H ?? 0.0)

                           switch (token.name?.lowercased(), token.tokenId?.lowercased(), address.isEmpty) {
                           case ("optimism", "optimism", _):
                               print("OptimismBal =", balanceValue)
                           case ("arbitrum", "arbitrum", true):
                               print("arbitrumBal =", balanceValue)
                           case ("base", "base", true):
                               print("baseBal =", balanceValue)
                           default:
                               print("Bal =", balanceValue)
                           }

                           // ✅ Optional: Notify main screen of updates via delegate or NotificationCenter
                       }
                   }
               }
        } else {
            self.tokensList?[indexPath.row].callFunction.getBalance(completion: { bal in
                DispatchQueue.main.async {
//                    DGProgressView.shared.showLoader(to: self.view)
                }
                self.coinGeckoViewModel.apiMarketVolumeData("\(WalletData.shared.primaryCurrency?.symbol ?? "")", ids: self.tokensList?[indexPath.row].tokenId ?? "") { status,msg,data in
                    if status {
                        DispatchQueue.main.async {
                            DGProgressView.shared.hideLoader()
                        }
                        if !(data?.isEmpty ?? true) {
                        if let data = data, let assets = data.first {
                            DispatchQueue.main.async {
                                let symbol = (assets.symbol ?? "").uppercased()
                                DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "tokenId == %@ AND address == %@  AND symbol == %@", predicateArgs: [self.tokensList?[indexPath.row].tokenId ?? "" ,self.tokensList?[indexPath.row].address ?? "",self.tokensList?[indexPath.row].symbol?.uppercased() ?? ""]) { object in
                                    //  DatabaseHelper.shared.updateData(entityName: "Token", predicateFormat: "symbol == %@ AND tokenId == %@", predicateArgs: [symbol ,assets.id ?? ""]) { object in
                                    if let token = object as? Token {
                                        let cleanAddress = token.address?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                        let balanceValue = bal ?? "0"

                                        token.balance = balanceValue

                                        switch (token.name?.lowercased(), token.tokenId?.lowercased(), cleanAddress.isEmpty) {
                                        case ("optimism", "optimism", _):
                                            print("OptimismBal =", balanceValue)

                                        case ("arbitrum", "arbitrum", true):
                                            print("arbitrumBal =", balanceValue)

                                        case ("base", "base", true):
                                            print("baseBal =", balanceValue)

                                        default:
                                            print("Bal =", balanceValue)
                                        }
//                                        token.balance = bal
                                        let price = assets.currentPrice ?? 0.0
                                        token.price = "\(price)"
                                        token.logoURI = assets.image ?? ""
                                        token.lastPriceChangeImpact = String(format: "%.2f", (assets.priceChangePercentage24H ?? 0.0))
                                        DispatchQueue.main.async {
                                            if (self.tokensList?.count ?? 0) != 0 {
                                                self.dismiss(animated: true) {
                                                    if self.isPayCoin {
                                                        self.swapDelegate?.selectPayCoin(self.tokensList?[indexPath.row] ?? nil)
                                                    } else {
                                                        self.swapDelegate?.selectGetCoin(self.tokensList?[indexPath.row] ?? nil)
                                                    }
                                                    self.enabledTokenDelegate?.selectEnabledToken((self.tokensList?[indexPath.row])!)
                                                }
                                            }
                                        }
                                    } else {
                                        
                                    }
                                }
                            }
                        }
                        } else {
                            DispatchQueue.main.async {
                                DGProgressView.shared.hideLoader()
                                self.showToast(message: msg, font: .systemFont(ofSize: 15))
                            }
                            
                        }
                }// status
                    else {
                        DispatchQueue.main.async {
                            DGProgressView.shared.hideLoader()
                            self.showToast(message: msg, font: .systemFont(ofSize: 15))
                        }
                       
                    }
                }
            })
        }
    }
}

// MARK: UITextFieldDelegate
extension CoinListViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            self.tokensList = filterTokens
        }
        tbvCoinList.reloadData()
    }
    /* new logic as per symbol */
    func filterAssets(with searchText: String) {
        let lowercasedSearch = searchText.lowercased()

        guard let tokens = filterTokens else {
            self.tokensList = []
            return
        }

        let filtered = tokens.filter { asset in
            guard let symbol = asset.symbol?.lowercased(),
                  let type = asset.type?.lowercased(),
                  let name = asset.name?.lowercased() else { return false }

            return symbol.contains(lowercasedSearch) ||
                   type.contains(lowercasedSearch) ||
                   name.contains(lowercasedSearch)
        }

        // Tier 1: Exact symbol match
        let exactMatches = filtered.filter {
            $0.symbol?.lowercased() == lowercasedSearch
        }

        // Tier 2: Symbol starts with search text
        let symbolStartsWith = filtered.filter {
            $0.symbol?.lowercased().hasPrefix(lowercasedSearch) == true &&
            $0.symbol?.lowercased() != lowercasedSearch
        }

        // Tier 3: All other partial matches (symbol contains but not prefix, or name/type match)
        let otherMatches = filtered.filter {
            !exactMatches.contains($0) && !symbolStartsWith.contains($0)
        }

        // Merge all and sort each tier by balance descending
        self.tokensList = (exactMatches + symbolStartsWith + otherMatches).sorted {
            (Double($0.balance ?? "0") ?? 0) > (Double($1.balance ?? "0") ?? 0)
        }
    }

}


