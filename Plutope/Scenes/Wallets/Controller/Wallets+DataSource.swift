//
//  Wallets+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//

import UIKit
import FirebaseDynamicLinks

extension WalletsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        walletsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvWallets.dequeueReusableCell(indexPath: indexPath) as WalletsViewCell
        let data = walletsList?[indexPath.row]
        cell.selectionStyle = .none
//        cell.ivCheckWallet.image = UIImage(named: "ic_headerPlutopeIcon")
        cell.lblWalletName.text = data?.wallet_name
        //cell.lblWalletType.text = "Multi-Coin Wallet"
        cell.lblWalletType.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.multicoinwallets, comment: "")
        if data?.isPrimary ?? false {
            cell.ivCheckWallet.isHidden = false
//            var selectedWallets = getSelectedWallets()
//            if selectedWallets.contains(data?.wallet_id?.uuidString ?? "") {
//                self.showSimpleAlert(Message: "This wallet has already been selected.")
//            } else {
//                selectedWallets.append(data?.wallet_id?.uuidString ?? "")
//                saveSelectedWallets(selectedWallets)
//            }
            
          
        } else {
            cell.ivCheckWallet.isHidden = true
        }
        cell.tag = indexPath.row
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(openWalletRecovery), for: .touchUpInside)
//        cell.btnShare.addTarget(self, action: #selector(shareWalletRecovery), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    @objc func openWalletRecovery(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        let viewToNavigate = WalletRecoveryViewController()
        viewToNavigate.wallet = walletsList?[sender.tag]
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
//    func getReferallCodeData() {
//           DGProgressView.shared.showLoader(to: view)
//        referallCodeViewModel.getReferallCodeAPI(walletAddress: <#String#>) { resStatus, dataValue, resMessage in
//                if resStatus == 1 {
//                    DGProgressView.shared.hideLoader()
//                    self.arrReferallCode = dataValue
//                    
//                    let userCode = self.arrReferallCode?.userCode ?? ""
//                    self.createShortDynamicLink(referralCode: userCode)
//                    
//                } else {
//                    DGProgressView.shared.hideLoader()
//                    self.showToast(message: resMessage, font: AppFont.medium(15).value)
//                }
//            }
//    }
//    @objc func shareWalletRecovery(_ sender: UIButton) {
//        
//        self.getReferallCodeData()
//       }

    func createShortDynamicLink(referralCode: String) {
        guard let link = URL(string: "https://plutope.page.link/u9DC?referral=\(referralCode)") else { return }

        let dynamicLinksDomainURIPrefix = "https://plutope.page.link"
        let builder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        
        builder?.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier!)
        
        builder?.shorten { (shortURL, warnings, error) in
            if let error = error {
                print("Error creating short link: \(error.localizedDescription)")
                self.showToast(message: "Something went wrong", font: AppFont.regular(15).value)
                return
            }
            
            if let shortURL = shortURL {
                var components = URLComponents(url: shortURL, resolvingAgainstBaseURL: false)
                components?.queryItems = [URLQueryItem(name: "referral", value: referralCode)]
                let referralLink = components?.url?.absoluteString ?? ""
                
                print("createShortDynamicLink: \(shortURL.absoluteString)")
                print("createShortDynamicLink: \(referralLink)")
                
                if !referralLink.isEmpty {
                    let sendIntent = UIActivityViewController(activityItems: [referralLink], applicationActivities: nil)
                    if let topController = UIApplication.shared.keyWindow?.rootViewController {
                        topController.present(sendIntent, animated: true, completion: nil)
                    }
                } else {
                    self.showToast(message: "Something went wrong", font: AppFont.regular(15).value)
                }
            }
        }
    }
}
