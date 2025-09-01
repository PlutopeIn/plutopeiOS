//
//  AllTranscationHistryViewController+Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import UIKit
// MARK: - UITableViewDelegate methods
extension AllTranscationHistryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvHistory.cellForRow(at: indexPath) as? AllTranscationHistryTbvCell
            let transactionsData = transactionSections[indexPath.section].data?[indexPath.row]
            let historyDetailsVC = TranscationHistoryDetailViewController()
            historyDetailsVC.hidesBottomBarWhenPushed = true
            historyDetailsVC.allTransactionDataNew = transactionsData
            self.navigationController?.pushViewController(historyDetailsVC, animated: true)
    }
}
