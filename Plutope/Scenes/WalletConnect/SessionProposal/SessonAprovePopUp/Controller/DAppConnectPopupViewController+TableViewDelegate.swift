//
//  DAppConnectPopupViewController+TableViewDelegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/01/24.
//

import UIKit

// MARK: UITableViewDelegate Methods
extension DAppConnectPopupViewController : UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        tbvHeight.constant = tbvChainType.contentSize.height
    }
}

