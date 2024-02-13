//
//  LockMethod+Datasource.swift
//  Plutope
//
//  Created by Mitali Desai on 07/07/23.
//

import Foundation
import UIKit

// MARK: UITableViewDataSource methods
extension LockMethodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrMethodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvLockMethod.dequeueReusableCell(indexPath: indexPath) as SecurityViewCell
        let data = arrMethodData[indexPath.row]
        cell.selectionStyle = .none
        
        cell.lblTitle.text = data.title
        
        cell.viewSwitch.isHidden = true
        
        if UserDefaults.standard.string(forKey: DefaultsKey.appLockMethod) == data.title {
            cell.ivForward.image = UIImage(systemName: "checkmark")
            cell.viewForward.isHidden = false
        } else {
            cell.viewForward.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
