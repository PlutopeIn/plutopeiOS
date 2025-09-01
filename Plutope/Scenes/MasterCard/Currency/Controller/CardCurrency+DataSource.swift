//
//  CardCurrency+DataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/07/24.
//
import UIKit
extension CardCurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvCurrency.dequeueReusableCell(withIdentifier: CurrencyViewCell.reuseIdentifier) as? CurrencyViewCell else { return UITableViewCell() }
        let data = arrCurrency[indexPath.row]
        cell.selectionStyle = .none
        let selectedCurrency = UserDefaults.standard.value(forKey: cardCurrency) as? String ?? ""
        
        if data.symbol?.uppercased() == selectedCurrency {
            cell.ivSelected.isHidden = false
        } else {
            cell.ivSelected.isHidden = true
        }
        cell.lblCurrency.text = "\(data.symbol ?? "") - \(data.name ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
