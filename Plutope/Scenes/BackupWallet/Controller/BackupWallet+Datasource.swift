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
//            cell.ivCheck.image = UIImage.newcheck
            cell.ivCheck.image = UIImage.check
            cell.ivCheck.imageTintColor = UIColor.systemBackground
            cell.ivCheck.backgroundColor = UIColor.label
            
        } else {
            cell.ivCheck.image = UIImage.uncheck
            cell.ivCheck.imageTintColor = UIColor.label
            cell.ivCheck.backgroundColor = UIColor.clear
        }
        
        if arrWarnings.allSatisfy({ $0.isChecked }) {
            btnContinue.alpha = 1
            btnContinue.isUserInteractionEnabled = true
            self.btnContinue.backgroundColor = UIColor.label
            self.btnContinue.titleLabel?.textColor = UIColor.systemBackground
        } else {
            btnContinue.alpha = 0.5
            btnContinue.isUserInteractionEnabled = false
            self.btnContinue.backgroundColor = UIColor.darkGray
            self.btnContinue.titleLabel?.textColor = UIColor.white
        }
        
        return cell
    }
    
}
