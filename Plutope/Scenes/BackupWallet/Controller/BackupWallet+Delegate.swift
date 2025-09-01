//
//  BackupWallet+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 02/06/23.
//
import UIKit
extension BackupWalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        arrWarnings[indexPath.row].isChecked.toggle()
        tbvWarnings.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        tblHeight.constant = tbvWarnings.contentSize.height
//        
//    }
}
