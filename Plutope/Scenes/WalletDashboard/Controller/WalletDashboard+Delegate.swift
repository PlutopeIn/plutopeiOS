//
//  WalletDashboard+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 21/06/23.
//
import Foundation
import UIKit
import CoreData
import AVFoundation
import CGWallet
// MARK: Table view delegate method
extension WalletDashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
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
        let swipeAction = UIContextualAction(style: .destructive, title: isUserAdded ?  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.delete, comment: "") : LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.disable, comment: "")) { (_, _, completionHandler) in
            DatabaseHelper.shared.deleteData(withToken: tokenObject,walletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
            self.getChainList()
            completionHandler(true)
           }

        swipeAction.backgroundColor = isUserAdded ? UIColor.red : UIColor.quaternarySystemFill
        swipeAction.title?.AttributedHashtags(FontColor: UIColor.label, lineSpacing: 1)
        
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
}

// MARK: Collection view delegate method
extension WalletDashboardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        if collectionView == clvNFTs {
            let data = arrNftDataNew?[indexPath.row]
            
            if let imageUrlString = data?.metadata?.image,
               let nftName = data?.metadata?.name {
                
                let description = data?.metadata?.description ?? ""
                
                let nftVC = NFTDescriptionViewController()
                nftVC.hidesBottomBarWhenPushed = true
                nftVC.nftName = nftName
                nftVC.nftDescription = description
                nftVC.imageURL = imageUrlString
                nftVC.arrNftDataNew = data
                self.navigationController?.pushViewController(nftVC, animated: true)
            }

        } else {
            let coinListVC = BuyCoinListViewController()
            
            switch indexPath.row {
            case 0:
                coinListVC.isFrom = .receive
                coinListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(coinListVC, animated: true)
            case 1:
                coinListVC.isFrom = .send
                coinListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(coinListVC, animated: true)
            case 2:
                coinListVC.isFrom = .buy
                coinListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(coinListVC, animated: true)
            case 3:
                coinListVC.isFrom = .swap
                coinListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(coinListVC, animated: true)
            case 4:
                let sellVC = SellViewController()
                sellVC.coinDetail = self.chainTokenList?[1]
                sellVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sellVC, animated: true)
                
            default:
                break
            }
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
        WalletData.shared.walletBTC = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainBTC, nil))
//        WalletData.shared.importAccountFromMnemonicAction(mnemonic: primaryWallet?.mnemonic ?? "") { _ in
//            
//        }
//        self.getChainList()
       
//        exploreNewTokens()
        self.getChainList()
        tbvAssets.isHidden = false
        scrollViewNft.isHidden = true
        viewNullNFT.isHidden = true
//        if assetsSelected == true {
//            tbvAssets.isHidden = false
//            scrollViewNft.isHidden = true
//            viewNullNFT.isHidden = true
//        } else {
//            tbvAssets.isHidden = true
//            getNFTList()
//        }
    }
}

extension WalletDashboardViewController : UpdatedWalletWalletDelegate {
    func setUpdatedWallet(primaryWallet: Wallets?) {
        self.primaryWallet = primaryWallet
        
        self.isFromUpdate = true
        WalletData.shared.myWallet = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainETH, nil))
        WalletData.shared.walletBTC = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(primaryWallet?.mnemonic ?? "", WalletData.shared.chainBTC, nil))
//        WalletData.shared.importAccountFromMnemonicAction(mnemonic: primaryWallet?.mnemonic ?? "") { _ in
//
//        }
        
        exploreNewTokens()

            tbvAssets.isHidden = false
        clvNFTs.isHidden = true
        btnReceiveNFTS.isHidden = true
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
        exploreNew()
//        getChainList()
    }
}

extension WalletDashboardViewController: CurrencyUpdateDelegate {
    
    func updateCurrency(currencyObject: Currencies) {
        WalletData.shared.primaryCurrency = currencyObject
        self.primaryCurrency = currencyObject
//        self.getChainList()
        exploreNewTokens()
    }
    
}
extension WalletDashboardViewController {
    //    checkForCameraPermission
    func checkForCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .denied:
            showCameraSettingsAlert()
        case .restricted:
            break
        default: break
        }
    }
    
    // showCameraSettingsAlert
    func showCameraSettingsAlert() {
        let alert = UIAlertController(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccessDenied, comment: ""))", message: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cameraAccess, comment: ""))", preferredStyle: .alert)
        // Add an action to open the app's settings
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.openSetting, comment: ""))", style: .default, handler: { action in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        // Add a cancel action
        // alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), style: .cancel, handler: nil))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
