//
//  Setting+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 09/06/23.
//
import UIKit
import WalletConnectSign
extension SettingsViewController: UITableViewDelegate {
    
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
    }
    
    fileprivate func passcodeAction() {
        /// Biometrics
        if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) != nil {
            guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
            guard let viewController = sceneDelegate.window?.rootViewController else { return }
            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: self, completion: { status in
                if status {
                    let viewToNavigate = SecurityViewController()
                    viewToNavigate.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(viewToNavigate, animated: true)
                }
            })
        } else {
            let viewToNavigate = SecurityViewController()
            viewToNavigate.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
            case 0:
                let viewToNavigate = WalletsViewController()
                viewToNavigate.hidesBottomBarWhenPushed = true
                viewToNavigate.primaryWalletDelegate = self
//                viewToNavigate.primaryWallet = self.primaryWallet
                viewToNavigate.updatedWalletWalletDelegate = self
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 1:
                let viewToNavigate = CurrencyViewController()
                viewToNavigate.isFromSetting = true
                viewToNavigate.delegate = self
                viewToNavigate.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 2:
                let viewToNavigate = LanguageSelectionController()
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewToNavigate, animated: true)
//                viewToNavigate.modalTransitionStyle = .crossDissolve
//                viewToNavigate.modalPresentationStyle = .popover
                viewToNavigate.delegate = self
                self.present(viewToNavigate, animated: true, completion: nil)
            case 3:
                let viewToNavigate = ReferralCodeViewController()
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            default:
                break
            }
        case 1 :
            switch indexPath.row {
            case 0:
                passcodeAction()
//            case 1:
//                let viewToNavigate = ReferralCodeViewController()
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 1:
                let viewToNavigate = AddressContactsViewController()
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
//            
//                
//            case 2:
//                let viewToNavigate = ENSViewController()
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 2:
                let viewToNavigate = WalletConnectPopupViewController( importAccount: importAccount)
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: false)
                
            default:
                break
            }
        case 2 :
            switch indexPath.row {
            case 0:
                showWebView(for: URLs.helpSupportAppUrl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.helpcentre, comment: ""))
            case 1:
                showWebView(for: URLs.aboutAppUrl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.aboutplutope, comment: ""))
            default:
                break
            }
        default:
            break
        }
    }
    
}

extension SettingsViewController: CurrencyUpdateDelegate {
    
    func updateCurrency(currencyObject: Currencies) {
//        if let walletDash = (self.tabBarController?.viewControllers?[1] as? UINavigationController)?.topViewController as? WalletDashboardViewController {
//            self.currencyUpdateDelegate = walletDash
//            self.currencyUpdateDelegate?.updateCurrency(currencyObject: currencyObject)
//            self.tabBarController?.selectedIndex = 1
//        }
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if let walletDash = viewController as? WalletDashboardViewController {
                    self.currencyUpdateDelegate = walletDash
                    self.currencyUpdateDelegate?.updateCurrency(currencyObject: currencyObject)
                    self.tabBarController?.selectedIndex = 1
                    break
                }
            }
        }
    }
    
}
