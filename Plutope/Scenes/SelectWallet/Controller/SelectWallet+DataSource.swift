//
//  SelectWallet+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit

// MARK: UITableViewDataSource methods
extension SelectWalletBackUpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrBackupWallets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvBackup.dequeueReusableCell(indexPath: indexPath) as WalletBackupViewCell
        cell.selectionStyle = .none
        
        cell.lblWalletName.text = arrBackupWallets?[indexPath.row].title
        cell.lblDate.text = arrBackupWallets?[indexPath.row].date
        cell.lblTime.text = arrBackupWallets?[indexPath.row].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ifyoudontseeyourbackuptrytosyncyourgoogledrive, comment: "")
        //"If you don't see your backup, try to sync your iCloud."
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let lblInstruction = UILabel(frame: CGRect(x: 17, y: 10, width: screenWidth, height: 17))
        view.backgroundColor = .clear
        
        //lblInstruction.text = StringConstants.instructionBackup
        lblInstruction.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.choosethebackupforthewalletyouwanttorestore, comment: "")
        lblInstruction.textColor = UIColor.label
        lblInstruction.font = AppFont.regular(10).value
        
        view.addSubview(lblInstruction)
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        27
    }
}
