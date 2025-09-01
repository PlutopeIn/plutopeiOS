//
//  AddMasterCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 18/06/24.
//

import UIKit

struct CardDetails {
    let number:String?
    let expiryYear:Int?
    let expiryMonth:Int?
    let cardHolderName:String?
}
class AddMasterCardViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtCardNumber: CreditCardTextField!
    @IBOutlet weak var txtExpireDate: UITextField!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var btnNext: GradientButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblExpireDate: UILabel!
    @IBOutlet weak var lblMsgInfo: UILabel!
    @IBOutlet weak var lblardHolderName: UILabel!
    var isFrom = ""
    var isFromCard = ""
    var month: Int = 0
    var year: Int = 0
    
    lazy var bankCardPayInViewModel: BankCardPayInViewModel = {
        BankCardPayInViewModel { _ ,_ in
        }
    }()
    lazy var bankCardPayOutViewModel: BankCardPayOutViewModel = {
        BankCardPayOutViewModel { _ ,_ in
        }
    }()
    fileprivate func uiSetup() {
        txtCardNumber.appendText(Spacing: 12, Direction: .left)
        
        lblCardNumber.font = AppFont.regular(15).value
        lblExpireDate.font = AppFont.regular(15).value
        lblardHolderName.font = AppFont.regular(15).value
        txtCardNumber.font = AppFont.regular(15).value
        txtExpireDate.font = AppFont.regular(15).value
        txtCardHolderName.font = AppFont.regular(15).value
        lblMsgInfo.font = AppFont.regular(15).value
        
        txtCardNumber.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.newcardNumber, comment: "")
        txtExpireDate.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.expirationDate, comment: "")
        txtCardHolderName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardHolderName, comment: "")
        btnNext.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.next, comment: ""), for: .normal)
        lblMsgInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.masterCardAddMsg, comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addCardDetails, comment: ""), btnBackHidden: false)
        txtExpireDate.delegate = self
        uiSetup()
      
    }

    internal func alltextFieldsValid() -> Bool {
        guard let cardNoText = self.txtCardNumber.text?.trimingChar(), !cardNoText.isEmpty else {
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.masterCardemptyNumberMsg, comment: ""))
            return false
            
        }
        let textWithoutSpaces = self.txtCardNumber.text?.replacingOccurrences(of: " ", with: "")
        guard textWithoutSpaces?.count == 16 else {
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.masterCardInvalidNumberMsg, comment: ""))
            return  false
        }
        guard let expireText = self.txtExpireDate.text?.trimingChar(), !expireText.isEmpty else {
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.masterCardExpiryDateMsg, comment: ""))
            return false
        }
        let components = expireText.split(separator: "/")
            if components.count == 2, let monthInt = Int(components[0]), let yearInt = Int(components[1]) {
                // Ensure the month is between 1 and 12
                guard monthInt >= 1, monthInt <= 12 else {
                    self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidMonthMsg, comment: ""))
                    return false
                }
                
                let currentYear = Calendar.current.component(.year, from: Date())
                let fullYear = 2000 + yearInt
                
                // Ensure the year is greater than or equal to the current year
                guard fullYear >= currentYear else {
                    self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidyearMsg, comment: ""))
                    return false
                    
                }
            } else {
                self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidDateFormateMsg, comment: ""))
                return false
            }
        guard let cardHolderText = self.txtCardHolderName.text?.trimingChar(), !cardHolderText.isEmpty else {
          
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enterCardHolderName, comment: ""))
            return false
        }
        return true
    }
    func removeSpaces(from string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    @IBAction func btnUpdateAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if alltextFieldsValid() {
            
            if isFromCard == "payout" {
                self.btnNext.ShowLoader()
                DGProgressView.shared.showLoader(to: view)
                let cardNumberWithoutSpaces = removeSpaces(from: txtCardNumber.text ?? "")
                print(cardNumberWithoutSpaces)
                bankCardPayOutViewModel.apiPayOutAddCard(addCardPayout: AddCardPayout(cardHolder:txtCardHolderName.text ?? "", cardNumber: cardNumberWithoutSpaces,cardExpirationYear: self.year, cardExpirationMonth: self.month)) { resStatus, dataValue, resMessage in
                    if resStatus == 1 {
                        self.btnNext.HideLoader()
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
                                    if viewController is WithdrowViewController {
                                        NotificationCenter.default.post(name: NSNotification.Name("RefreshBuyDashBoard"), object: nil)
                                        navigationController.popToViewController(viewController, animated: true)
                                        break
                                    }
                                }
                            }
                        }
                        
                    } else {
                        self.btnNext.HideLoader()
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: resMessage, font: AppFont.regular(15).value)
                    }
                }
            } else {
                let addCardBillingAddressVC = AddCardBillingAddressViewController()
                addCardBillingAddressVC.arrCardDetail = CardDetails(number: txtCardNumber.text ?? "", expiryYear: self.year, expiryMonth: self.month, cardHolderName: txtCardHolderName.text ?? "")
                if isFromCard == "payin" {
                    
                } else {
                    addCardBillingAddressVC.isFrom = "addMasterCard"
                }
                addCardBillingAddressVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addCardBillingAddressVC, animated: true)
            }
        }
    }
}

extension AddMasterCardViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)

        // Allow only digits and the "/" character
        let allowedCharacters = CharacterSet(charactersIn: "0123456789/")
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        // If deleting, handle appropriately
        if string.isEmpty {
            return true
        }

        // Automatically add "/" after the second digit if not already present
        if newText.count == 2, !newText.contains("/") {
            textField.text = newText + "/"
            return false
        }

        // Prevent invalid month input and show alert
        if newText.count == 2, let monthInt = Int(newText), monthInt > 12 {
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidMonthMsg, comment: ""))
            return false
        }

        // Prevent invalid year input and show alert
        if newText.count == 5 {
            let components = newText.split(separator: "/")
            if components.count == 2, let yearInt = Int(components[1]) {
                let currentYear = Calendar.current.component(.year, from: Date()) % 100
                if yearInt < currentYear {
                    self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidyearMsg, comment: ""))
                    return false
                }
            }
        }

        // Limit the length to 5 characters ("MM/YY")
        return newText.count <= 5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let dateText = textField.text, dateText.count == 5 else {
            // Handle incomplete or invalid input
           
            return
        }

        let components = dateText.split(separator: "/")

        if components.count == 2, let monthInt = Int(components[0]), let yearInt = Int(components[1]) {
            // Ensure the month is between 01 and 12
            guard monthInt >= 1, monthInt <= 12 else {
                print("Invalid month")
                self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidMonthMsg, comment: ""))
                
                return
            }

            let currentYear = Calendar.current.component(.year, from: Date())
            let fullYear = 2000 + yearInt

            // Ensure the year is greater than or equal to the current year
            guard fullYear >= currentYear else {
                print("Invalid year")
                self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidyearMsg, comment: ""))
                return
            }

            self.month = monthInt
            self.year = fullYear
//            print("Month: \(monthInt), Year: \(fullYear)")
        } else {
            // Handle invalid input
//            print("Invalid date format")
        }
    }
    // Helper function to show a toast message below a UITextField
    func showToasts(message: String, font: UIFont, textField: UITextField) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0

        let maxSize = CGSize(width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height - 40)
        let expectedSize = toastLabel.sizeThatFits(maxSize)
        
        let textFieldFrame = textField.convert(txtExpireDate.bounds, to: self.view)
        let toastYPosition = textFieldFrame.origin.y + textFieldFrame.size.height + 8  // Adjust the 8 value to add some space between the text field and the toast
        
        toastLabel.frame = CGRect(x: (self.view.bounds.size.width - expectedSize.width) / 2, y: toastYPosition, width: expectedSize.width + 20, height: expectedSize.height + 20)

        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
