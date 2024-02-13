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
        let cell = self.tblLanguages.dequeueReusableCell(indexPath: indexPath) as LanguageSelectionTableCell
        let languageData = self.arrayLanguageData[indexPath.row]
        
        cell.selectionStyle = .none
        cell.btnCheckUnCheck.isSelected = languageData.isCheckedLanguage
        cell.lblTitle.text = languageData.title
        //        self.lblLogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login", comment: "")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
