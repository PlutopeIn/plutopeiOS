//
//  UpdateCardRequestAddressViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/05/24.
//

import UIKit
import Combine
class UpdateCardRequestAddressViewController: UIViewController {
    
    @IBOutlet weak var txtAddress2: UITextView!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblCountryTitle: UILabel!
    
    @IBOutlet weak var txtCountry: customTextField!
    
    @IBOutlet weak var ivCountry: UIImageView!
    
    @IBOutlet weak var lblDocumentCountryTitle: UILabel!
    
    @IBOutlet weak var txtDocumentCountry: customTextField!
    
    @IBOutlet weak var ivDocumentCountry: UIImageView!
    @IBOutlet weak var lblState: UILabel!
    
    @IBOutlet weak var txtState: customTextField!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var txtCity: customTextField!
    @IBOutlet weak var lblZip: UILabel!
    
    @IBOutlet weak var txtZip: customTextField!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtAddress: UITextView!
    
    @IBOutlet weak var btnUpdate: GradientButton!
    var cardRequestId : Int?
    let countryPickerView = UIPickerView()
    let documentCountryPickerView = UIPickerView()
    let statePickerView = UIPickerView()
    var cityPickerView = UIPickerView()
    var countryCode = ""
    var doccumentCountryCode = ""
    var stateCode = ""
    var cityCode = ""
    var cancellables = Set<AnyCancellable>()
    var viewModel = CountryCodeViewModel()
    var countryPickerData: [CountryList] = []
    var documentCountryPickerData: [CountryList] = []
    var statePickerData: [StatesList] = []
    var cityPickerData: [String] = []
    var cardType = ""
    var currency = ""
    var isCountry = false
    var isFirstTimeTapped = true
    var isFrom = ""
    var additionalStatuses:[String] = []
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    fileprivate func uiSetUp() {
        lblCountryTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.country,comment: "")
        lblCity.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cityofresidence,comment: "")
        lblState.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.stateofresidence,comment: "")
        lblAddress.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.address1,comment: "")
        lblAddress2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.address2,comment: "")
        lblZip.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.zipCode,comment: "")) *"
        btnUpdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.updateAddress,comment: ""), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation header
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.billingAddress,comment: ""), btnBackHidden: true)
        uiSetUp()
        txtCountry.isUserInteractionEnabled = true
               // Add a tap gesture recognizer to the text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap))
        txtCountry.addGestureRecognizer(tapGesture)
        txtAddress.leftSpace()
        txtAddress2.leftSpace()
        btnBack.addTapGesture {
            HapticFeedback.generate(.light)
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is CardDashBoardViewController {
                        navigationController.popToViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtZip.textAlignment = .right
            txtCity.textAlignment = .right
            txtState.textAlignment = .right
            txtAddress.textAlignment = .right
            txtCountry.textAlignment = .right
            txtAddress2.textAlignment = .right
            
        } else {
            txtZip.textAlignment = .left
            txtCity.textAlignment = .left
            txtState.textAlignment = .left
            txtCountry.textAlignment = .left
            txtAddress.textAlignment = .left
            txtAddress2.textAlignment = .left
            
        }
    }
    @objc func handleTextFieldTap() {
            // Present the new view controller
        HapticFeedback.generate(.light)
            let popUpVc = CountryPopUpViewController()
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            popUpVc.isFrom = "updateAddreess"
            popUpVc.isCountry = true
            popUpVc.delegate = self
            present(popUpVc, animated: true, completion: nil)
        }
    @objc func handleTextFieldTap1() {
        HapticFeedback.generate(.light)
            // Present the new view controller
            let popUpVc = CountryPopUpViewController()
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            popUpVc.isFrom = "updateAddreess"
            popUpVc.isCountry = false
            popUpVc.delegate = self
            present(popUpVc, animated: true, completion: nil)
        }
   
    internal func alltextFieldsValid() -> Bool {
        guard let countryText = self.txtCountry.text?.trimingChar(), !countryText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyCountry)
            return false
        }
       
        guard let stateText = self.txtState.text?.trimingChar(), !stateText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyState)
            return false
        }
        guard let cityText = self.txtCity.text?.trimingChar(), !cityText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyCity)
            return false
        }
        guard let addressText = self.txtAddress.text?.trimingChar(), !addressText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyAddress)
            return false
        }
        guard let zipText = self.txtZip.text?.trimingChar(), !zipText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyZip)
            return false
        }
        return true
    }
    
    func pickerViewConfigure() {
        // Configure picker views
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        documentCountryPickerView.delegate = self
        documentCountryPickerView.dataSource = self
        txtCountry.inputView = countryPickerView
        txtDocumentCountry.inputView = documentCountryPickerView
        txtCountry.delegate = self
        txtDocumentCountry.delegate = self
        fetchCountry()
    }
    @IBAction func btnUpdateAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if alltextFieldsValid() {
            DGProgressView.shared.showLoader(to: view)
            let cardHolderName = UserDefaults.standard.value(forKey: cardHolderfullName) as? String ?? ""
            myCardViewModel.addressUpdateRequestsAPINew(updateCardHolderAddress: UpdateCardHolderAddress(country: self.countryCode, documentCountry: self.countryCode, city: txtCity.text ?? "", state: self.txtState.text ?? "", address: txtAddress.text ?? "",address2:txtAddress2.text ?? "", postalCode: txtZip.text ?? "", cardholderName: cardHolderName), cardRequestId: "\(cardRequestId ?? 0)") { resStatus, resMsg, dataValue in
                if resStatus == 1 {
                    self.myCardViewModel.apiCardHolderNameUpdateRequestsNew(cardholderName: cardHolderName, cardRequestId: "\(self.cardRequestId ?? 0)") { resStatus, resMsg, dataValue in
                        if resStatus == 1 {
                            DGProgressView.shared.hideLoader()
                            
                            if !self.additionalStatuses.contains("ADDITIONAL_PERSONAL_INFO") &&
                               !self.additionalStatuses.contains("TAXID") {
                                let additionalInfoVC = AdditionalPersonalInfoViewController()
                                additionalInfoVC.cardRequestId = self.cardRequestId ?? 0
                                additionalInfoVC.cardType = self.cardType
                                let fullAddress = "\(self.txtAddress.text ?? "") \(self.txtAddress2.text ?? "") \(self.txtCity.text ?? "") \(self.txtState.text ?? "") \(self.txtCountry.text ?? "") \(self.txtZip.text ?? "")"
                                additionalInfoVC.address = fullAddress
                                additionalInfoVC.additionalStatuses = self.additionalStatuses
                                additionalInfoVC.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(additionalInfoVC, animated: true)
                            } else {
                                let cardPaymentVC = CardPaymentViewControllerNew()
                                cardPaymentVC.cardRequestId = self.cardRequestId ?? 0
                                cardPaymentVC.cardType = self.cardType
                                let fullAddress = "\(self.txtAddress.text ?? "") \(self.txtAddress2.text ?? "") \(self.txtCity.text ?? "") \(self.txtState.text ?? "") \(self.txtCountry.text ?? "") \(self.txtZip.text ?? "")"
                                cardPaymentVC.address = fullAddress
                                cardPaymentVC.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(cardPaymentVC, animated: true)
                            }
                        } else {
                            DGProgressView.shared.hideLoader()
                        }
                    }
                   
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMsg, font: AppFont.regular(15).value)
                }
            }
            
        }
    }
    
    func fetchCountry() {
//        if documentCountryPickerData.isEmpty || countryPickerData.isEmpty {
////            txtCountry.isUserInteractionEnabled = false
////            txtDocumentCountry.isUserInteractionEnabled = false
//           
//        }
        if  countryPickerData.isEmpty {
//            txtCountry.isUserInteractionEnabled = false
//            txtDocumentCountry.isUserInteractionEnabled = false
           
        }
        DGProgressView.shared.showLoader(to: self.view)
        myCardViewModel.getCountrisAPI { status, msg, data in
            DispatchQueue.main.async {
                if status == 1 {
                   // self.documentCountryPickerData = data ?? []
                    self.countryPickerData = data ?? []
                    DGProgressView.shared.hideLoader()
                } else {
                    DGProgressView.shared.hideLoader()
                    print(msg)
                }
            }
        }
    }
}
extension UpdateCardRequestAddressViewController: SelectedCountryDelegate {
    func getSelectedCountry(name: String, code: String, dialCode: String, flag: String, isCountry: Bool?) {
        DispatchQueue.main.async {
            if isCountry == true {
                self.countryCode = code
                self.txtCountry.text = name
            } else {
                self.doccumentCountryCode = code
                self.txtDocumentCountry.text = name
            }
        }
    }
 
}
