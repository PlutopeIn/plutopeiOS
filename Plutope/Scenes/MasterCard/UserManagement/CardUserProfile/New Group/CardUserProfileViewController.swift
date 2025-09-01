//
//  CardUserProfileViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import UIKit
import Combine

class CardUserProfileViewController: UIViewController {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblUpdateKyc: UILabel!
    @IBOutlet weak var viewUpdateKyc: UIView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: customTextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: customTextField!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var txtMobile: customTextField!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var txtDOB: customTextField!
    @IBOutlet weak var ivDOB: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var txtCountry: customTextField!
    @IBOutlet weak var ivCountry: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var txtCity: customTextField!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var txtStreet: customTextField!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var txtZip: customTextField!
    @IBOutlet weak var btnUpdate: GradientButton!
    
    var isFromRegister = false
    var countryCode = ""
    var curruncyCode = ""
    var isFromDetails = false
    var selectedDate : String = ""
    var arrProfileList : CardUserDataList?
    
    lazy var cardUserProfileViewModel: CardUserProfileViewModel = {
        CardUserProfileViewModel { _ ,message in
        }
    }()
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    let pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    let toolbar = UIToolbar()
    var dob = ""
    let server = serverTypes
    var documentCountryPickerData: [CountryList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pickerViewConfigure()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        datePickerSetups()
        lblInfo.font = AppFont.regular(15).value
        txtCountry.isUserInteractionEnabled = true
        uiSetUp()
               // Add a tap gesture recognizer to the text field
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap))
        txtCountry.addGestureRecognizer(tapGesture1)
        viewUpdateKyc.addTapGesture {
            HapticFeedback.generate(.light)
            let updateKYCVC = UpdateKYCViewController()
            updateKYCVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateKYCVC, animated: true)
        }
      
        
        if self.txtCountry.text != "" {
            self.ivCountry.isHidden = true
        } else {
            self.ivCountry.isHidden = false
        }
    }
    
    @objc func handleTextFieldTap() {
            // Present the new view controller
        HapticFeedback.generate(.light)
            let popUpVc = CountryPopUpViewController()
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            popUpVc.isFrom = "profile"
            popUpVc.isCountry = true
            popUpVc.delegate = self
            present(popUpVc, animated: true, completion: nil)
        }
    internal func alltextFieldsValid() -> Bool {
        guard let firstNameText = self.txtFirstName.text?.trimingChar(), !firstNameText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyFirstName)
            return false
        }
        guard let lastNameText = self.txtLastName.text?.trimingChar(), !lastNameText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyLastName)
            return false
        }
        guard let dobText = self.txtDOB.text?.trimingChar(), !dobText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyDob)
            return false
        }
        guard let countryText = self.txtCountry.text?.trimingChar(), !countryText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyCountry)
            return false
        }
        guard let cityText = self.txtCity.text?.trimingChar(), !cityText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyCity)
            return false
        }
        guard let streetText = self.txtStreet.text?.trimingChar(), !streetText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyStreet)
            return false
        }

        return true
    }
     func updateProfileAction() {
        if isFromRegister == true {
            
            if alltextFieldsValid() {
                self.curruncyCode =  "\(WalletData.shared.primaryCurrency?.symbol ?? "")"
//                self.btnUpdate.ShowLoader()
                
                DGProgressView.shared.showLoader(to: view)
                cardUserProfileViewModel.apiUpateProfileNew(profileData: ProfileList(firstName: txtFirstName.text ?? "",lastNAme: txtLastName.text ?? "",dob:dob,country: self.countryCode,city: txtCity.text ?? "",street: txtStreet.text ?? "",zip: txtZip.text ?? "" ,primaryCurrency: "EUR"), isfromRegister: true) { status, msg in
                    if status == 1 {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                      //  let fullName = "\(data?["firstName"] ?? "")\(data?["lastName"] ?? "")"
                        let cardMainVC = CardDashBoardViewController()
                        self.navigationController?.pushViewController(cardMainVC, animated: true)
                    } else {
                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                }
            }
            
        } else {
            if alltextFieldsValid() {
                self.curruncyCode =  "\(WalletData.shared.primaryCurrency?.symbol ?? "")"
//                self.btnUpdate.ShowLoader()
                DGProgressView.shared.showLoader(to: view)
                cardUserProfileViewModel.apiUpateProfileNew(profileData: ProfileList(firstName: txtFirstName.text ?? "",lastNAme: txtLastName.text ?? "",dob:dob,country: self.countryCode,city: txtCity.text ?? "",street: txtStreet.text ?? "",zip: txtZip.text ?? "" ,primaryCurrency: "EUR"), isfromRegister: false) { status, msg in
                    if status == 1 {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                        self.navigationController?.popViewController(animated: true)
                    } else {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                }
            }
        }
    }
     func updateProfileNewAction() {
        if isFromRegister == true {
            
            if alltextFieldsValid() {
                self.curruncyCode =  "\(WalletData.shared.primaryCurrency?.symbol ?? "")"
//                self.btnUpdate.ShowLoader()
                
                DGProgressView.shared.showLoader(to: view)
                cardUserProfileViewModel.apiUpateProfileNew(profileData: ProfileList(firstName: txtFirstName.text ?? "",lastNAme: txtLastName.text ?? "",dob:dob,country: self.countryCode,city: txtCity.text ?? "",street: txtStreet.text ?? "",zip: txtZip.text ?? "" ,primaryCurrency: "EUR"), isfromRegister: true) { status, msg in
                    if status == 1 {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                        let cardMainVC = CardDashBoardViewController()
                        self.navigationController?.pushViewController(cardMainVC, animated: true)
                    } else {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                }
            }
        } else {
            if alltextFieldsValid() {
                self.curruncyCode =  "\(WalletData.shared.primaryCurrency?.symbol ?? "")"
//                self.btnUpdate.ShowLoader()
                DGProgressView.shared.showLoader(to: view)
                cardUserProfileViewModel.apiUpateProfileNew(profileData: ProfileList(firstName: txtFirstName.text ?? "",lastNAme: txtLastName.text ?? "",dob:dob,country: self.countryCode,city: txtCity.text ?? "",street: txtStreet.text ?? "",zip: txtZip.text ?? "" ,primaryCurrency: "EUR"), isfromRegister: false) { status, msg in
                    if status == 1 {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                        self.navigationController?.popViewController(animated: true)
                    } else {
//                        self.btnUpdate.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                }
            }
        }
    }
    @IBAction func btnUpdateAction(_ sender: Any) {
        HapticFeedback.generate(.light)
            updateProfileNewAction()
    }
    fileprivate func uiSetUp() {
        if isFromDetails {
            btnUpdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.update, comment: ""), for: .normal)
        } else {
            btnUpdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        }
       
        lblInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.msginfo, comment: "")
        lblFirstName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.firstnamelegal, comment: "")
        lblLastName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lastnamelegal, comment: "")
        lblDOB.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.dateofbirth, comment: "")
        lblCountry.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.countryofresidence, comment: "")
        lblCity.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cityofresidence, comment: "")
        lblStreet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.resifdenceStreet, comment: "")
        lblZip.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.zipCode, comment: "")
        ivDOB.tintColor = .secondaryLabel
        
        lblFirstName.font = AppFont.regular(15).value
        txtFirstName.font = AppFont.regular(15).value
        lblLastName.font = AppFont.regular(15).value
        txtLastName.font = AppFont.regular(15).value
        lblDOB.font = AppFont.regular(15).value
        txtDOB.font = AppFont.regular(15).value
        lblStreet.font = AppFont.regular(15).value
        txtStreet.font = AppFont.regular(15).value
        lblZip.font = AppFont.regular(15).value
        txtZip.font = AppFont.regular(15).value
        lblCity.font = AppFont.regular(15).value
        txtCity.font = AppFont.regular(15).value
        lblInfo.font = AppFont.regular(15).value
        lblCountry.font = AppFont.regular(15).value
        txtCountry.font = AppFont.regular(15).value
//        txtFirstName.setIcon(Postion: .left, Image: UIImage.addwallet, isRounded: false, ImageSize: CGSize(width: 22, height: 22), TintColor: nil, Padding: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtLastName.textAlignment = .right
                txtFirstName.textAlignment = .right
                txtDOB.textAlignment = .right
                txtCountry.textAlignment = .right
                txtCity.textAlignment = .right
                txtMobile.textAlignment = .right
                txtStreet.textAlignment = .right
                txtZip.textAlignment = .right
                
            } else {
                txtLastName.textAlignment = .left
                txtFirstName.textAlignment = .left
                txtDOB.textAlignment = .left
                txtCountry.textAlignment = .left
                txtCity.textAlignment = .left
                txtMobile.textAlignment = .left
                txtStreet.textAlignment = .left
                txtZip.textAlignment = .left
            }
        if isFromRegister == true {
            viewInfo.isHidden = false
            uiSetUp()
            // Navigation header
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.personalDetail, comment: ""), btnBackHidden: true)
            if AppConstants.storedCountryList == nil {
                fetchCountry()
            } else {
                allReadySaved()
            }
        } else {
            viewInfo.isHidden = true
            // Navigation header
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.personalDetail, comment: ""), btnBackHidden: false)
           
            if AppConstants.storedCountryList == nil {
                fetchCountry()
            } else {
                allReadySaved()
            }
        }
            
        }
    
    private func datePickerSetups() {
       // DatePickerSetups
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Date()
        txtDOB.inputView = datePicker
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        txtDOB.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
   }
    @objc func doneButtonTapped() {
        HapticFeedback.generate(.light)
        // Dismiss the keyboard
        selectedDate = self.txtDOB.text ?? ""
        view.endEditing(true)
    }
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        // Update the text of the textField with the selected date
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        dob = dateFormatter.string(from: datePicker.date)
        txtDOB.text = dateFormatter1.string(from: datePicker.date)
    }
}
extension CardUserProfileViewController: SelectedCountryDelegate {
    func getSelectedCountry(name: String, code: String, dialCode: String, flag: String, isCountry: Bool?) {
        DispatchQueue.main.async {
            self.txtCountry.text = name
            self.countryCode = code
            if self.txtCountry.text != "" {
                self.ivCountry.isHidden = true
            } else {
                self.ivCountry.isHidden = false
            }
        }
    }
}
