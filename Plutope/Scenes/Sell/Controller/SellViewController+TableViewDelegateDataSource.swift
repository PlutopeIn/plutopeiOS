//
//  SellViewController+TableViewDelegateDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/04/25.
//

import UIKit
import SDWebImage
// MARK: - UITableViewDelegate Methods
extension SellViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvSellProviderList.cellForRow(at: indexPath) as? SellTableviewCell
        
        if let url = sellProviderList?[indexPath.row].url {
            let _ : String = url
            
            if sellProviderList?[indexPath.row].providerName == "rampable" {
                self.showWeb3BrowserView(for: url, onVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""),coinDetail: self.coinDetail)
            } else {
                self.showWebView(for: url, onVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""))
            }
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
    @MainActor
    func showWeb3BrowserView(for url: String, onVC: UIViewController, title: String,coinDetail:Token?) {
        let webController = Web3BrowserViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        webController.isFrom = "coinDetail"
        webController.coinDetail = coinDetail
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
        }
    
}
// MARK: - UITableViewDataSource Methods

extension SellViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellProviderList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvSellProviderList.dequeueReusableCell(indexPath: indexPath) as SellTableviewCell
        cell.selectionStyle = .none
        let providerData = sellProviderList?[indexPath.row]
        
        let logoURI = "\(ServiceNameConstant.BaseUrl.baseUrl)\(ServiceNameConstant.BaseUrl.clientVersion)\(ServiceNameConstant.BaseUrl.images)\(providerData?.image ?? "")"
        cell.ivProvider.sd_setImage(with: URL(string: logoURI))
       
        cell.lblProviderName.text = providerData?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
// MARK: UITextFieldDelegate
extension SellViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            self.sellProviderList = filterProviderList ?? []
        }
        tbvSellProviderList.reloadData()
    }
    func filterAssets(with searchText: String) {
        self.sellProviderList = filterProviderList?.filter { asset in
            let type = asset.name
            let symbol = asset.providerName
            
            // Match the entered text with name or symbol
            return type?.localizedCaseInsensitiveContains(searchText) ?? false ||
            symbol?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}
