//
//  AddCardTokenViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//
import UIKit
import CoreData
import IQKeyboardManagerSwift
extension AddCardTokenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tableView.cellForRow(at: indexPath) as? CardMainViewCell
        cell?.mainView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CardMainViewCell
        cell?.mainView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
// MARK: UITextFieldDelegate
extension AddCardTokenViewController: UITextFieldDelegate {
    
    // Implement the UITextFieldDelegate method to perform the search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false) {
            isSearching = true
            filterAssets(with: textField.text ?? "")
        } else {
            isSearching = false
            self.curruncyList = self.filterTokens ?? []
        }
        tbvCoinList.reloadData()
    }
    
    func filterAssets(with searchText: String) {
        self.curruncyList = (filterTokens?.filter { asset in
            let symbol = asset.symbol
            
            // Match the entered text with name or symbol
            return
            symbol.localizedCaseInsensitiveContains(searchText) ?? false
        })!
    }
    
}
