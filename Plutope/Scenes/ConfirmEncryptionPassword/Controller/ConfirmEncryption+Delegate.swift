//
//  ConfirmEncryption+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/06/23.
//
import UIKit
extension ConfirmEncryptionPasscodeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrWarnings[indexPath.row].isChecked.toggle()
        tbvInstruction.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
