//
//  CardMainViewController+TableViewDatasource,Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
import UIKit
// MARK: - UITableViewDelegate methods
extension CardMainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        switch indexPath.row {
        case 0:
           let profileVC = CardUserProfileViewController()
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        case 1:
            break
        case 2:
            let myTokenVC = MyTokenViewController()
            myTokenVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(myTokenVC, animated: true)
        case 3:
            let myTokenVC = MyCardViewController()
            myTokenVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(myTokenVC, animated: true)
        default:
            break
        }
    }
}
// MARK: - UITableViewDataSource methods
extension CardMainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.arrFeatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvDetails.dequeueReusableCell(indexPath: indexPath) as CardMainViewCell
        let data = arrFeatures[indexPath.row]
        cell.selectionStyle = .none
        cell.lblName.text = data.name
        if indexPath.row == 1 {
            if self.kyclevel != "" && self.kycStatus != "" {
                cell.lblkycUpdate.isHidden = false
                cell.lblkycUpdate.text = "\(self.kyclevel) Status : \(self.kycStatus)"
            } else {
                cell.lblkycUpdate.isHidden = true
            }
            
        } else {
            cell.lblkycUpdate.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            if self.kyclevel != "" && self.kycStatus != "" {
                return 95
            } else {
                return 75
            }
            
        } else {
            return 75
        }
    }
}
