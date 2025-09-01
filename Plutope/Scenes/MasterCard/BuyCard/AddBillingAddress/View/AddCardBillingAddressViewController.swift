//
//  AddCardBillingAddressViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 18/06/24.
//

import UIKit

protocol GoBackToCardList : AnyObject {
    func goBackToCardList()
}
class AddCardBillingAddressViewController: UIViewController {

    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    var arrCardDetail : CardDetails?
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblCountryTitle: UILabel!
    
    @IBOutlet weak var txtCountry: customTextField!
    
    @IBOutlet weak var ivCountry: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var txtCity: customTextField!
    @IBOutlet weak var lblZip: UILabel!
    
    @IBOutlet weak var txtZip: customTextField!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtAddress: UITextView!
    
    @IBOutlet weak var txtState: customTextField!
    @IBOutlet weak var btnDone: GradientButton!
    var isFrom = ""
    weak var delegate : GoBackToCardList?
    var countryCode = ""
    var countryPickerData: [CountryList] = []
    lazy var bankCardPayInViewModel: BankCardPayInViewModel = {
        BankCardPayInViewModel { _ ,_ in
        }
    }()
    
    fileprivate func uiSetup() {
        lblMsg.font = AppFont.regular(13).value
        lblCountryTitle.font = AppFont.regular(15).value
        txtCountry.font = AppFont.regular(15).value
        lblState.font = AppFont.regular(15).value
        txtState.font = AppFont.regular(15).value
        lblCity.font = AppFont.regular(15).value
        txtCity.font = AppFont.regular(15).value
        lblAddress.font = AppFont.regular(15).value
        txtAddress.font = AppFont.regular(15).value
        lblZip.font = AppFont.regular(15).value
        txtZip.font = AppFont.regular(15).value
        
        lblCountryTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.residenceCountry, comment: "")
        lblState.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.state, comment: "")
        lblCity.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.city, comment: "")
        lblAddress.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.billingAddress, comment: "")
        lblZip.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.zipCode, comment: "")
        btnDone.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.save, comment: ""), for: .normal)
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.billingInfoMsg, comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.billinginfo, comment: ""), btnBackHidden: false)
        txtCountry.isUserInteractionEnabled = true
        
               // Add a tap gesture recognizer to the text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap))
        txtCountry.addGestureRecognizer(tapGesture)
        txtAddress.leftSpace()
        
        uiSetup()
    }
    @objc func handleTextFieldTap() {
        HapticFeedback.generate(.light)
            // Present the new view controller
            let popUpVc = CountryPopUpViewController()
            popUpVc.isFrom = "billingInfo"
            popUpVc.isCountry = true
            popUpVc.delegate = self
            popUpVc.modalTransitionStyle = .crossDissolve
            popUpVc.modalPresentationStyle = .overFullScreen
            present(popUpVc, animated: true, completion: nil)
        }
    internal func alltextFieldsValid() -> Bool {
        guard let countryText = self.txtCountry.text?.trimingChar(), !countryText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyCountry)
            return false
        }
        guard let stateText = self.txtState.text?.trimingChar(), !stateText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyState)
//            self.showSimpleAlert(Message: "Please enter State")
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
    func removeSpaces(from string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    @IBAction func btnDoneAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if alltextFieldsValid() {
//            self.btnDone.ShowLoader()
            DGProgressView.shared.showLoader(to: view)
            let cardNumberWithoutSpaces = removeSpaces(from: arrCardDetail?.number ?? "")
            print(cardNumberWithoutSpaces)
            let cardNo = "\(cardNumberWithoutSpaces)"
            let expireMonth = "\(arrCardDetail?.expiryMonth ?? 0)"
            let expireYear = "\(arrCardDetail?.expiryYear ?? 0)"
            bankCardPayInViewModel.apiPayinAddCard(addCardPaying: AddCardPaying(cardHolder: arrCardDetail?.cardHolderName, cardNumber: cardNo, zip: txtZip.text ?? "", city: txtCity.text ?? "", state: txtState.text ?? "", address: txtAddress.text ?? "", countryCode: self.countryCode, cardExpirationYear: expireYear, cardExpirationMonth: expireMonth)) { resStatus, resMessage ,resData in
                if resStatus == 1 {
                    DGProgressView.shared.hideLoader()
                    if self.isFrom == "addMasterCard" {
                        if let navigationController = self.navigationController {
                            for viewController in navigationController.viewControllers {
                                if viewController is MasterCardListViewController {
                                    NotificationCenter.default.post(name: NSNotification.Name("RefreshMasterCardList"), object: nil)
                                    navigationController.popToViewController(viewController, animated: true)
                                    break
                                }
                            }
                        }
                    } else {
                        if let navigationController = self.navigationController {
                            for viewController in navigationController.viewControllers {
                                if viewController is BuyCardDashboardViewController {
                                    NotificationCenter.default.post(name: NSNotification.Name("RefreshBuyDashBoard"), object: nil)
                                    navigationController.popToViewController(viewController, animated: true)
                                    break
                                }
                            }
                        }
                    }
                    
                } else {
//                    self.btnDone.HideLoader()
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
                }
            }
        }
    }
}
extension AddCardBillingAddressViewController: SelectedCountryDelegate {
    func getSelectedCountry(name: String, code: String, dialCode: String, flag: String, isCountry: Bool?) {
        DispatchQueue.main.async {
                self.countryCode = code
                self.txtCountry.text = name
        }
    }
 
}
