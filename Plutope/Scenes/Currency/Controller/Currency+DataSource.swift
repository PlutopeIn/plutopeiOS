//
//  Currency+DataSource.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrency?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvCurrency.dequeueReusableCell(withIdentifier: CurrencyViewCell.reuseIdentifier) as? CurrencyViewCell else { return UITableViewCell() }
        tableView.separatorStyle = .singleLine
        let data = arrCurrency?[indexPath.row]
        cell.selectionStyle = .none
        if data?.isPrimary ?? false {
            cell.ivSelected.isHidden = false
        } else {
            cell.ivSelected.isHidden = true
        }
        cell.lblCurrency.text = "\(data?.symbol ?? "") - \(data?.name ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
