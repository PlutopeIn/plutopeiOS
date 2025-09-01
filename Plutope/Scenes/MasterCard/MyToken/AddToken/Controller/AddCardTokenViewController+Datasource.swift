//
//  AddCardTokenViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//
import UIKit
extension AddCardTokenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        curruncyList.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coinListCell = tbvCoinList.dequeueReusableCell(indexPath: indexPath) as CardMainViewCell
            let coinData = curruncyList[indexPath.row]
            coinListCell.selectionStyle = .none
            coinListCell.lblName.text = coinData.symbol
            
            // Update the background color based on selection state
            if tableView.indexPathsForSelectedRows?.contains(indexPath) == true {
                coinListCell.mainView.backgroundColor = UIColor.white
            } else {
                coinListCell.mainView.backgroundColor = UIColor.clear
            }
            
            return coinListCell
        }
    
 } 
