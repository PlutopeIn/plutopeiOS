//
//  SaveContactPopUpViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 02/08/23.
//

import UIKit
import CoreData

class SaveContactPopUpViewController: UIViewController {
    @IBOutlet weak var lblAddToAddressBook: UILabel!
    @IBOutlet weak var lblEnterAlias: UILabel!
    @IBOutlet weak var txtName: customTextField!
    @IBOutlet weak var btnSave: GradientButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var address: String? = ""
    weak var refreshDataDelegate: RefreshDataDelegate?
    // uiSetup
    fileprivate func uiSetup() {
        self.lblAddToAddressBook.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addtoaddressbook, comment: "")
        self.lblEnterAlias.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enteranalias, comment: "")
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), for: .normal)
        self.btnSave.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.save, comment: ""), for: .normal)
        
        lblAddToAddressBook.font = AppFont.violetRegular(20).value
        lblEnterAlias.font = AppFont.regular(14).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // uiSetup
        uiSetup()
        // Do any additional setup after loading the view.
        txtName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtName.delegate = self
        btnSave.alpha = 0.5
        btnSave.isUserInteractionEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtName.textAlignment = .right
            } else {
                txtName.textAlignment = .left
            }
            
        }
/// btnCancelAction
    @IBAction func btnCancelAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true)
    }
    
    //  updateButtonAvailability
    internal func updateButtonAvailability() {
        let allTextFieldsFilled = !(txtName.text?.isEmpty ?? false)
        btnSave.alpha = allTextFieldsFilled ? 1.0 : 0.5
        btnSave.isUserInteractionEnabled = allTextFieldsFilled
    }
    /// btnSaveAction
    @IBAction func btnSaveAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: DatabaseHelper.shared.context)!
        let contactEntity = Contacts(entity: entity, insertInto: DatabaseHelper.shared.context)
        contactEntity.name = txtName.text ?? ""
        contactEntity.address = address ?? ""
        DatabaseHelper.shared.saveData(contactEntity) { status in
            if status {
                self.dismiss(animated: true)
                self.refreshDataDelegate?.refreshData()
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension SaveContactPopUpViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonAvailability()
    }

}
