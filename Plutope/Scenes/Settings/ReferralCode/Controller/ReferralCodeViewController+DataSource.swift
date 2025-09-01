//
//  ReferralCodeViewController+DataSource.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 11/07/24.
//

import Foundation
import UIKit
extension ReferralCodeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrReferallCodeUser?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvUpdateClaim.dequeueReusableCell(indexPath: indexPath) as ReferralUserCell
        let data = arrReferallCodeUser?[indexPath.row]
        cell.selectionStyle = .none
        cell.lblWalletName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletAddress, comment: "")
    
        cell.lblwalletAddress.setCenteredEllipsisText(data?.walletAddress ?? "")
        cell.imgCopy.addTapGesture {
            HapticFeedback.generate(.light)
            UIPasteboard.general.string = cell.lblwalletAddress.text
            self.showToast(message: "\(StringConstants.copied): \(cell.lblwalletAddress.text ?? "")", font: AppFont.regular(15).value)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.tbvHeight.constant = tbvUpdateClaim.contentSize.height
//    }
}
    
