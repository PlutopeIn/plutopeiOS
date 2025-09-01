//
//  CardSettingsViewController+UITableviewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 23/05/24.
//

import UIKit
extension CardSettingsViewController: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        arrSettigngData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrSettigngData[section].group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvSettings.dequeueReusableCell(indexPath: indexPath) as SettingViewCell
        let data = arrSettigngData[indexPath.section].group[indexPath.row]
        cell.selectionStyle = .none
        
        cell.ivSettings.image = data.image
//        cell.ivSettings.tintColor = UIColor.white
        cell.lblTitle.text = data.title
//        cell.ivForward.isHidden = true
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
        if AppConstants.cardPrimaryCurrency == "" {
            
        } else {
            let selectedCurrency = UserDefaults.standard.value(forKey: cardCurrency) as? String ?? ""
            cell.lblSubtitle.text = selectedCurrency
        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
}
