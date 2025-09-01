//
//  LanguageSelection+Delegate.swift
//  Plutope
//
//  Created by Admin on 07/11/23.
//

import Foundation
import UIKit

// MARK: UITableViewDelegate Methods

extension LanguageSelectionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = self.tblLanguages.dequeueReusableCell(indexPath: indexPath) as LanguageSelectionCell
        cell.mainView.borderColor = UIColor.blue
        if indexPath.row == 0 {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "hi")
            self.setSelectedLanguage(language: "hi")
        } else if indexPath.row == 2 {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "th")
            self.setSelectedLanguage(language: "th")
        }
//        else if indexPath.row == 3 {
//            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
//            self.setSelectedLanguage(language: "ar")
//           // setupLanguageChangeObserver()
//        }
        else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            self.setSelectedLanguage(language: "en")
        }
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            self.delegate?.dismissPopup()
            }

//        self.dismiss(animated: true)Orefer
    }
}
