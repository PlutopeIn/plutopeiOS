//
//  Notification+Datasource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrNotification[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvNotification.dequeueReusableCell(indexPath: indexPath) as NotificationViewCell
        let data = arrNotification[indexPath.section].data[indexPath.row]
        cell.selectionStyle = .none
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.description
        cell.lblTime.text = data.time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let lbl = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.width - 15, height: 15))
        
        lbl.font = AppFont.regular(12).value
        lbl.textColor = UIColor.white
        view.addSubview(lbl)
        
        switch section {
        case 0:
            //lbl.text = "New"
            lbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.new, comment: "")
        case 1:
            //lbl.text = "Earlier"
            lbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.earlier, comment: "")
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
}
