//
//  AddressContactsViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 01/08/23.
//

import UIKit

class AddressContactsViewController: UIViewController {
    @IBOutlet weak var viewAddContactBtn: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnAddContact: GradientButton!
    @IBOutlet weak var tbvAddressList: UITableView!
    @IBOutlet weak var lblNoContacts: UILabel!
    
    @IBOutlet weak var viewNoContact: UIView!
    var allContact: [Contacts]?
    // Dictionary to hold contacts organized by first letter of names
    var contactsDictionary: [String: [Contacts]] = [:]
    var sectionTitles: [String] = []
    var isFromSend = false
    weak var selectContactDelegate: SelectContactDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contacts, comment: ""))
        self.btnAddContact.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addcontact, comment: ""), for: .normal)
        self.lblNoContacts.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nocontactsyet, comment: "")
        
        /// Table Register
        tableRegister()
        self.viewAddContactBtn.isHidden = isFromSend
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allContact =  DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
        if allContact?.count == 0 {
            viewNoContact.isHidden = false
            tbvAddressList.isHidden = true
        } else {
            viewNoContact.isHidden = true
            tbvAddressList.isHidden = false
            organizeContacts()
        }
    }
    
    /// Function to organize contacts into sections
    private func organizeContacts() {
        self.allContact =  DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
        contactsDictionary.removeAll()
        sectionTitles.removeAll()
        
        for contact in (allContact ?? []) {
            let firstLetter = String("\(contact.name?.prefix(1) ?? "")").uppercased()
            if contactsDictionary[firstLetter] == nil {
                contactsDictionary[firstLetter] = [contact]
                sectionTitles.append(firstLetter)
            } else {
                contactsDictionary[firstLetter]?.append(contact)
            }
        }
        sectionTitles.sort()
        self.tbvAddressList.reloadData()
    }
    
    /// Table Register
    func tableRegister() {
        tbvAddressList.delegate = self
        tbvAddressList.dataSource = self
        tbvAddressList.register(NotificationViewCell.nib, forCellReuseIdentifier: NotificationViewCell.reuseIdentifier)
    }
    
    @IBAction func btnAddContactAction(_ sender: Any) {
        let viewToNavigate = AddContactViewController()
        viewToNavigate.refreshDataDelegate = self
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
}

// MARK: RefreshDataDelegate
extension AddressContactsViewController: RefreshDataDelegate {
    func refreshData() {
        self.showToast(message: ToastMessages.contactAdded, font: AppFont.regular(15).value)
    }
}
