//
//  AddressContacts+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 02/08/23.
//

import Foundation
import UIKit

// MARK: UITableViewDelegate
extension AddressContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        if isFromSend {
            let sectionTitle = sectionTitles[indexPath.section]
            let contactsInSection = contactsDictionary[sectionTitle]
            guard let contact = contactsInSection?[indexPath.row] else { return }
            self.selectContactDelegate?.selectContact(contact)
            self.navigationController?.popViewController(animated: true)
        } else {
            if let contact = allContact?[indexPath.row] {
                let viewToNavigate = AddContactViewController()
                viewToNavigate.refreshDataDelegate = self
                viewToNavigate.selectedContact = contact
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            }
        }
    }
}
