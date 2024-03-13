//
//  WalletDashboard+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 21/06/23.
//
import Foundation
import UIKit
import CoreData
// import WalletCore
import CGWallet
// MARK: Table view delegate method
extension WalletDashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewToNavigate = CoinDetailViewController()
        viewToNavigate.coinDetail = self.chainTokenList?[indexPath.row]
        viewToNavigate.refreshWalletDelegate = self
        viewToNavigate.hidesBottomBarWhenPushed = true
        viewToNavigate.updatebalDelegate = self
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let tokenObject = self.chainTokenList?[indexPath.row] else { return nil }
        let isUserAdded = tokenObject.isUserAdded
        
        /*let swipeAction = UIContextualAction(style: .destructive, title: isUserAdded ? StringConstants.delete : StringConstants.disable) { (_, _, completionHandler) in
            DatabaseHelper.shared.deleteData(withToken: tokenObject,walletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
            self.getChainList()
            completionHandler(true)
           }*/
        let swipeAction = UIContextualAction(style: .destructive, title: isUserAdded ?  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.delete, comment: "") : LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.disable, comment: "")) { (_, _, completionHandler) in
            DatabaseHelper.shared.deleteData(withToken: tokenObject,walletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
            self.getChainList()
            completionHandler(true)
           }

        swipeAction.backgroundColor = isUserAdded ? UIColor.red : UIColor.c75769D
        
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
}

// MARK: Collection view delegate method
extension WalletDashboardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = arrNftData?[indexPath.row]
        let jsonString = data?.metadata
        if jsonString != "" || jsonString != nil {
            if let jsonData = jsonString?.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                       let imageUrlString = json["image"] as? String,
                       let nftName = json["name"] as? String,
                       let description = json["description"] as? String {
                        let nftVC = NFTDescriptionViewController()
                        nftVC.modalPresentationStyle = .overFullScreen
                        nftVC.modalTransitionStyle = .crossDissolve
                        nftVC.nftName = nftName
                        nftVC.nftDescription = description
                        nftVC.imageURL = imageUrlString
                        self.present(nftVC, animated: true)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        } else {
            print("jsonString = nill")
        }
    }
}

// MARK: EnabledTokenDelegate
extension WalletDashboardViewController: EnabledTokenDelegate {
    
    func selectEnabledToken(_ coinDetail: Token) {
        
        getPrice([coinDetail]) {
            self.getBalance([coinDetail]) {
                self.getChainList()
            }
        }
    }
}

// MARK: PrimaryWalletDelegate
extension WalletDashboardViewController: PrimaryWalletDelegate {
    
    func setPrimaryWallet(primaryWallet: Wallets?) {
        self.primaryWallet = primaryWallet
      // WalletData.shared.wallet = HDWallet(mnemonic: primaryWallet?.mnemonic ?? "", passphrase: "")
        WalletData.shared.myWallet = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainETH, nil))
        self.getChainList()
        segmentControl.selectedSegmentIndex = 0
        tbvAssets.isHidden = false
        scrollViewNft.isHidden = true
        viewNullNFT.isHidden = true
    }
}

// MARK: Dismiss presented screen and push forward
extension WalletDashboardViewController: PushViewControllerDelegate {
    
    func pushViewController(_ controller: UIViewController) {
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension WalletDashboardViewController: RefreshDataDelegate {
    func refreshData() {
        getChainList()
    }
}

extension WalletDashboardViewController: CurrencyUpdateDelegate {
    
    func updateCurrency(currencyObject: Currencies) {
        WalletData.shared.primaryCurrency = currencyObject
        self.primaryCurrency = currencyObject
        self.getChainList()
    }
    
}
