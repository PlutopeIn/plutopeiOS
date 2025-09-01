//
//  Setting+Datasource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 09/06/23.
//
import UIKit
extension SettingsViewController: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        arrSettigngData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrSettigngData[section].group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvSetting.dequeueReusableCell(indexPath: indexPath) as SettingViewCell
        let data = arrSettigngData[indexPath.section].group[indexPath.row]
        cell.selectionStyle = .none
       // tableView.separatorStyle = .singleLine
        cell.ivSettings.image = data.image
        cell.lblTitle.text = data.title
        if data.showForward {
            cell.ivForward.isHidden = false
        } else {
            cell.ivForward.isHidden = true
        }
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            cell.lblSubtitle.textAlignment = .right
            
        } else {
            cell.lblSubtitle.textAlignment = .left
        }
        if data.subTitle {
            cell.lblSubtitle.isHidden = false
        } else {
            cell.lblSubtitle.isHidden = true
        }
        cell.lblSubtitle.text = WalletData.shared.primaryCurrency?.symbol
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
        return 61
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
}
