//
//  SelectWallet+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit

// MARK: UITableViewDelegate methods
extension SelectWalletBackUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let fileName = self.arrBackupWallets?[indexPath.row].title
        let viewToNavigate = EncryptionPasswordViewController()
        viewToNavigate.isRestoreWallet = true
        viewToNavigate.backUpFileName = fileName
        let fileNameWithoutExtension = fileName?.replacingOccurrences(of: ".json", with: "")
        viewToNavigate.walletName = fileNameWithoutExtension
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
}
