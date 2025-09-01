//
//  AddressContacts+Datasource.swift
//  Plutope
//
//  Created by Mitali Desai on 01/08/23.
//

import Foundation
import UIKit

// MARK: UITableViewDataSource
extension AddressContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return contactsDictionary[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvAddressList.dequeueReusableCell(indexPath: indexPath) as NotificationViewCell
        cell.selectionStyle = .none
//        tableView.separatorStyle = .singleLine
        cell.lblTitle.font = AppFont.violetRegular(16).value
        cell.lblDescription.font = AppFont.violetRegular(15.5).value
        
        cell.lblTime.text = ""
        let sectionTitle = sectionTitles[indexPath.section]
        let contactsInSection = contactsDictionary[sectionTitle]
        let contact = contactsInSection?[indexPath.row]
        cell.lblTitle?.text = contact?.name
//        cell.lblDescription?.text = contact?.address
        
        cell.lblDescription.numberOfLines = 1
        cell.lblDescription.setCenteredEllipsisText("\(contact?.address ?? "")")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeader = UIView()
        // Create and configure the title label
        let titleLabel = UILabel()
        titleLabel.text = sectionTitles[section]
        titleLabel.textColor = UIColor.label
        titleLabel.font = AppFont.regular(15).value
        titleLabel.textAlignment = .left
        titleLabel.frame = CGRect(x: 25, y: 5, width: tableView.bounds.width - 32, height: 20)
//        customHeader.backgroundColor = .red
        customHeader.addSubview(titleLabel)
        return customHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25 // Adjust the height as needed
    }

}
