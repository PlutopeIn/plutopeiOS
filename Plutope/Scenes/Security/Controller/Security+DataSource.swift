//
//  Security+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit

// MARK: UITableViewDataSource methods
extension SecurityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSecurityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvSecurity.dequeueReusableCell(indexPath: indexPath) as SecurityViewCell
        let data = arrSecurityData[indexPath.row]
        cell.selectionStyle = .none
        
        cell.lblTitle.text = data.title
        if data.isSwitch {
            cell.viewForward.isHidden = true
            cell.viewSwitch.isHidden = false
        } else {
            cell.viewForward.isHidden = false
            cell.viewSwitch.isHidden = true
        }
        
        cell.lblSelectedMethod.isHidden = !(indexPath.row == 1)
        cell.lblSelectedMethod.text = UserDefaults.standard.value(forKey: DefaultsKey.appLockMethod) as? String ?? ""
        
        if UserDefaults.standard.string(forKey: DefaultsKey.appPasscode) != nil {
            if indexPath.row == 1 || indexPath.row == 2 {
                cell.isHidden = false
            }
        } else {
            if indexPath.row == 1 || indexPath.row == 2  {
                cell.isHidden = true
            }
        }
        
        cell.switchSecurity.onImage = UIImage.icGraph
        
        cell.switchSecurity.tag = indexPath.row
        cell.switchSecurity.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        switch indexPath.row {
        case 0:
            cell.switchSecurity.isOn = UserDefaults.standard.string(forKey: DefaultsKey.appPasscode) != nil
        case 2:
            print(UserDefaults.standard.string(forKey: DefaultsKey.isTransactionSignin) != nil)
            cell.switchSecurity.isOn = UserDefaults.standard.string(forKey: DefaultsKey.isTransactionSignin) != nil
          
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let hasAppPasscode = UserDefaults.standard.string(forKey: DefaultsKey.appPasscode) != nil
        if !hasAppPasscode && (indexPath.row == 1 || indexPath.row == 2) {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        // Handle the switch value change for the specific indexPath
        guard let cell = tbvSecurity.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SecurityViewCell else { return }
        
        switch sender.tag {
        case 0:
            if cell.switchSecurity.isOn {
                let viewToNavigate = CreatePasscodeViewController()
                viewToNavigate.isFromSecurity = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
                print("Do when switch turns on")
            } else {
                /// Will turn off biometrics
                UserDefaults.standard.removeObject(forKey: DefaultsKey.appPasscode)
                UserDefaults.standard.removeObject(forKey: DefaultsKey.isTransactionSignin)
            }
            
        case 2:
            if cell.switchSecurity.isOn {
                UserDefaults.standard.setValue(true, forKey: DefaultsKey.isTransactionSignin)
            } else {
                /// Will turn off biometrics
                UserDefaults.standard.removeObject(forKey: DefaultsKey.isTransactionSignin)
                
            }
         
        default:
            break
        }
        
        tbvSecurity.reloadData()
    }
}
