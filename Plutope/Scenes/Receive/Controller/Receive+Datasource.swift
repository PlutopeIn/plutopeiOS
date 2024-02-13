//
//  Receive+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 04/06/23.
//
import UIKit
extension ReceiveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tbvReceiveCoinList.dequeueReusableCell(withIdentifier: PurchasedCoinViewCell.reuseIdentifier, for: indexPath) as? PurchasedCoinViewCell  else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
