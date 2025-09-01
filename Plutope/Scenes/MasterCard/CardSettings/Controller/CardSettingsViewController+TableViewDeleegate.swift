//
//  CardSettingsViewController+TableViewDeleegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 23/05/24.
//

import UIKit
extension CardSettingsViewController: UITableViewDelegate {
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        switch indexPath.section {
        case 0 :
            switch indexPath.row {
//            case 0:
//                let viewToNavigate = CardCurrencyViewController()
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                viewToNavigate.delegate = self
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 0:
                let viewToNavigate = ChangePasswordViewController()
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 1:
                let viewToNavigate = VerifyEmailViewController()
                viewToNavigate.hidesBottomBarWhenPushed = true
                viewToNavigate.isFrom = "settings"
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
                
//            case 2:
//                let viewToNavigate = CardCurrencyViewController()
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                viewToNavigate.delegate = self
//                viewToNavigate.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewToNavigate, animated: true)
                
            default:
                break
                
            }
        default:
            break
        }
    }
}

extension CardSettingsViewController: SelectCardCurrencyUpdateDelegate {
    func selectedCardCureency(selectedCurrency: String) {
        self.selectedCurrency = selectedCurrency
//        AppConstants.cardPrimaryCurrency = self.selectedCurrency.uppercased()
        UserDefaults.standard.set(self.selectedCurrency.uppercased(), forKey: cardCurrency)
        self.changePrimaryCurrency()
    }
}
