//
//  CardDesignViewController + DataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import Foundation
import UIKit

extension CardDesignViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return walletDataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return walletDataArr[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvWallets.dequeueReusableCell(indexPath: indexPath) as CardWalletTableViewCell
      //  let data = walletDataArr[indexPath.section].values[indexPath.row]
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.lblType.text = walletDataArr[0].values[indexPath.row].title
            cell.ivSymbol.image = walletDataArr[0].values[indexPath.row].img
        } else {
            cell.lblType.text = walletDataArr[1].values[indexPath.row].title
            cell.ivSymbol.image = walletDataArr[1].values[indexPath.row].img
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = UILabel(frame: headerView.bounds)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = AppFont.bold(17).value
        label.text = walletDataArr[section].title
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        tbvHeight.constant = tbvWallets.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
}
