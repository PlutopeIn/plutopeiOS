//
//  LanguageSelection+DataSource.swift
//  Plutope
//
//  Created by Admin on 07/11/23.
//

import Foundation
import UIKit
// MARK: UITableViewDataSource Methods
extension LanguageSelectionController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayLanguageData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblLanguages.dequeueReusableCell(indexPath: indexPath) as LanguageSelectionCell
        let languageData = self.arrayLanguageData[indexPath.row]
        cell.selectionStyle = .none
//        cell.btnCheckUnCheck.isSelected = languageData.isCheckedLanguage
        
        cell.lblLanguageName.text = languageData.title
        
        if indexPath.row == 0 {
            cell.imgFlag.image = UIImage(named: "India_flag")
            if languageData.isCheckedLanguage == true {
                cell.imgSelection.image = UIImage(named: "ic_flagselected")
                cell.mainView.borderColor = UIColor.blue
            } else {
                cell.imgSelection.image = UIImage(named: "")
                cell.mainView.borderColor = UIColor.secondarySystemFill
            }
        } else if indexPath.row == 1 {
            cell.imgFlag.image = UIImage(named: "us_flag")
            if languageData.isCheckedLanguage == true {
                cell.imgSelection.image = UIImage(named: "ic_flagselected")
                cell.mainView.borderColor = UIColor.blue
            } else {
                cell.imgSelection.image = UIImage(named: "")
                cell.mainView.borderColor = UIColor.secondarySystemFill
            }
        } else if indexPath.row == 2 {
            cell.imgFlag.image = UIImage(named: "thailand_flag")
            if languageData.isCheckedLanguage == true {
                cell.imgSelection.image = UIImage(named: "ic_flagselected")
                cell.mainView.borderColor = UIColor.blue
            } else {
                cell.imgSelection.image = UIImage(named: "")
                cell.mainView.borderColor = UIColor.secondarySystemFill
            }
        }
//        self.lblLogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: "")
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = UIColor.clear // Make header transparent
        }
    }

    // This method sets the height of the header to 30
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }*/

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 70
    }
}
