//
//  CardCurrency+Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry Poojara on 02/07/24.
//
import UIKit
extension CardCurrencyViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
    let data = self.arrCurrency[indexPath.row]
        let selectedCurrency = data.symbol ?? ""
        self.delegate?.selectedCardCureency(selectedCurrency: selectedCurrency)
         self.navigationController?.popViewController(animated: true)
    }
    
}
