//
//  CardUsersProfileViewController+TableviewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/05/24.
//

import Foundation
import UIKit
// MARK: - UITableViewDelegate methods
extension CardUsersProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        switch indexPath.row {
        case 0:
           let profileVC = CardUserProfileDetailsViewController()
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        case 1:
            let cardSettingVC = CardSettingsViewController()
            cardSettingVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(cardSettingVC, animated: true)
        case 2:
//            showWebView(for: URLs.helpSupportAppUrl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contactUs, comment: ""))
            showWebView(for: URLs.cardsFaqURl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""))
//        case 3:
//            let historyVC = AllTranscationHistryViewController()
//            historyVC.hidesBottomBarWhenPushed = true
//             self.navigationController?.pushViewController(historyVC, animated: true)
        case 3:
            self.zendeskInit()
//        case 3:
//            showWebView(for: URLs.cardsFaqURl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""))
        case 4:
            logOut()
        default:
            break
        }
    }
    
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
}
// MARK: - UITableViewDataSource methods
extension CardUsersProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.arrFeatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvItems.dequeueReusableCell(indexPath: indexPath) as SettingViewCell
        let data = arrFeatures[indexPath.row]
        cell.selectionStyle = .none
        cell.ivSettings.image = data.image

        cell.lblTitle.text = data.name
//        cell.ivForward.isHidden = true
        cell.lblSubtitle.isHidden = true
        
        if indexPath.row == 4 {
            cell.lblTitle.textColor = .red
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
       tbvHeight.constant = tbvItems.contentSize.height
    }
    
}
