//
//  CardCurrency+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/07/24.
//
import UIKit
extension CardCurrencyViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = arrCurrency?[indexPath.row] else { return }
//        guard let proto = self.delegate else { return }
        
//        if isFromSetting {
//            guard let currencies = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies] else {
//                return
//            }
//
//            currencies.forEach { $0.isPrimary = false }
//            
//            DatabaseHelper.shared.updateData(entityName: "Currencies", predicateFormat: "id == %@", predicateArgs: [arrCurrency?[indexPath.row].id ?? 0]) { object in
//                if let object = object as? Currencies {
//                    object.isPrimary = true
//                    self.delegate?.updateCurrency(currencyObject: object)
//                }
//            }
//        } else {
//            proto.updateCurrency(currencyObject: data)
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
