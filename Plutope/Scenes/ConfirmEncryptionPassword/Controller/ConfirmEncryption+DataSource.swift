//
//  ConfirmEncryption+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/06/23.
//
import UIKit
extension ConfirmEncryptionPasscodeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrWarnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tbvInstruction.dequeueReusableCell(withIdentifier: WarningViewCell.reuseIdentifier) as? WarningViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let data = arrWarnings[indexPath.row]
        
        cell.lblWarning.text = data.warning
        
        if data.isChecked {
            cell.ivCheck.image = UIImage.check
            
        } else {
            cell.ivCheck.image = UIImage.uncheck
        }
        
        if arrWarnings.allSatisfy({ $0.isChecked }) {
            btnConfirm.alpha = 1
            btnConfirm.isUserInteractionEnabled = true
        } else {
            btnConfirm.alpha = 0.5
            btnConfirm.isUserInteractionEnabled = false
        }
        
        return cell
        
    }
    
}
