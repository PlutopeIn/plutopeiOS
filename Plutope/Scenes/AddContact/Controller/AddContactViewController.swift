//
//  AddContactViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 01/08/23.
//

import UIKit
import CoreData
import QRScanner

class AddContactViewController: UIViewController {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAddContact: GradientButton!
    @IBOutlet weak var txtName: customTextField!
    @IBOutlet weak var txtAddress: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnPaste: UIButton!
    
    weak var refreshDataDelegate: RefreshDataDelegate?
    var selectedContact: Contacts?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.name, comment: "")
        self.txtAddress.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.publicaddress0x, comment: "")
        self.btnPaste.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paste, comment: ""), for: .normal)
    
        setViewAndTarget()
        setContactDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtName.textAlignment = .right
            txtAddress.textAlignment = .right
        } else {
            txtName.textAlignment = .left
            txtAddress.textAlignment = .left
        }
    }
    /// setViewAndTarget
    fileprivate func setViewAndTarget() {
        txtName.delegate = self
        txtAddress.delegate = self
        btnAddContact.alpha = 0.5
        btnAddContact.isUserInteractionEnabled = false
        txtAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setContactDetail() {
        if let contact = selectedContact {
            txtName.text = contact.name ?? ""
            txtAddress.text = contact.address ?? ""
            btnDelete.isHidden = false
            btnAddContact.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.save, comment: ""), for: .normal)
            /// Navigation Header
            defineHeader(headerView: headerView, titleText: StringConstants.editContact)
        } else {
            btnDelete.isHidden = true
            btnAddContact.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addcontact, comment: ""), for: .normal)
            /// Navigation Header
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addcontact, comment: ""))
        }
    }
    
    /// updateButtonAvailability
    internal func updateButtonAvailability() {
        let allTextFieldsFilled = areAllTextFieldsFilled()
        btnAddContact.alpha = allTextFieldsFilled ? 1.0 : 0.5
        btnAddContact.isUserInteractionEnabled = allTextFieldsFilled
    }
    
    /// areAllTextFieldsFilled
    internal func areAllTextFieldsFilled() -> Bool {
        guard let name = txtName?.text,
              let address = txtAddress?.text else {
            return false
        }
        
        return !name.isEmpty && !address.isEmpty && address.validateContractAddress()
    }
    
    // btnAddContactAction
    @IBAction func btnAddContactAction(_ sender: Any) {
        let allContactAddress = DatabaseHelper.shared.retrieveData("Contacts") as? [Contacts]
        
        if allContactAddress?.contains(where: { $0.address?.lowercased() == (self.txtAddress.text ?? "").lowercased() }) == true {
            /// Will update name if address already exist in contactbook
            DatabaseHelper.shared.updateData(entityName: "Contacts", predicateFormat: "address == %@", predicateArgs: [txtAddress.text ?? ""]) { object in
                if let contact = object as? Contacts {
                    contact.name = self.txtName.text ?? ""
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                }
            }
        } else if let contact = selectedContact {
            DatabaseHelper.shared.updateData(entityName: "Contacts", predicateFormat: "contact_Id == %@", predicateArgs: [contact.contact_Id ?? ""]) { object in
                if let contact = object as? Contacts {
                    contact.name = self.txtName.text ?? ""
                    contact.address = self.txtAddress.text ?? ""
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                }
            }
        } else {
            /// Will add wallet address in contactbook
            let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: DatabaseHelper.shared.context)!
            let contactEntity = Contacts(entity: entity, insertInto: DatabaseHelper.shared.context)
            contactEntity.name = txtName.text ?? ""
            contactEntity.address = txtAddress.text ?? ""
            contactEntity.contact_Id = UUID().uuidString
            DatabaseHelper.shared.saveData(contactEntity) { status in
                if status {
                    self.navigationController?.popViewController(animated: true)
                    self.refreshDataDelegate?.refreshData()
                }
            }
        }
    }
    
    // actionPaste
    @IBAction func actionPaste(_ sender: Any) {
        txtAddress.text = ""
        if let copiedText = UIPasteboard.general.string, copiedText.validateContractAddress() {
            // Use the copied text here
            txtAddress.text = copiedText
            updateButtonAvailability()
           
        } else {
            self.showToast(message: StringConstants.invalidAdd, font: .systemFont(ofSize: 15))
        }
    }
    /// btnScanAction
    @IBAction func btnScanAction(_ sender: Any) {
        let scanner = QRScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    /// btnDeleteAction
    @IBAction func btnDeleteAction(_ sender: Any) {
        let contactObject = self.selectedContact
        let format = "contact_Id == %@"
        let entityName = "Contacts"
        DatabaseHelper.shared.deleteEntity(withFormat: format, entityName: entityName, identifier: contactObject?.contact_Id ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}
