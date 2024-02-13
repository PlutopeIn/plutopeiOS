//
//  BackupWallet+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 02/06/23.
//
import UIKit
extension BackupWalletViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWarnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tbvWarnings.dequeueReusableCell(withIdentifier: WarningViewCell.reuseIdentifier) as? WarningViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let data = arrWarnings[indexPath.row]
        
        cell.lblWarning.text = data.warning
        
        if data.isChecked {
            cell.ivCheck.image = UIImage.check
            
        } else {
            cell.ivCheck.image = UIImage.uncheck
        }
        
        if arrWarnings.allSatisfy({ $0.isChecked }) {
            btnContinue.alpha = 1
            btnContinue.isUserInteractionEnabled = true
        } else {
            btnContinue.alpha = 0.5
            btnContinue.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
}
