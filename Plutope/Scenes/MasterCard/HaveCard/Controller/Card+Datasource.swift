//
//  Card+Datasource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
extension CardViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrTransactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvTransactions.dequeueReusableCell(indexPath: indexPath) as TransactionViewCell
        let data = arrTransactionData[indexPath.row]
        cell.selectionStyle = .none
        print(data)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
