//
//  WalletConnectionDetailPopup+TableViewDelegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/02/24.
//

import UIKit

// MARK: UITableViewDelegate Methods
extension WalletConnectionDetailPopup : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        tbvHeight.constant = tbvAccount.contentSize.height
    }
}
