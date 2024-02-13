//
//  BackupWallet+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 02/06/23.
//
import UIKit
extension BackupWalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrWarnings[indexPath.row].isChecked.toggle()
        tbvWarnings.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
