//
//  AddFiatAmountViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/02/24.
//

import UIKit

class AddFiatAmountViewController: UIViewController {

    @IBOutlet weak var lblYourCoinBal: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmountCoin: UILabel!
    @IBOutlet weak var txtCoinQuantity: customTextField!
    @IBOutlet weak var btnCurruncy: UIButton!
    @IBOutlet weak var btnToken: UIButton!
    @IBOutlet weak var btnConfirm: GradientButton!
    @IBOutlet weak var ivClose: UIImageView!
    var coinDetail: Token?
    var tokenAmount = ""
    var tokentype = ""
    var tokenPrice = ""
    weak var delegate: AddFiatAmountDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        /// UI SetUp
        uiSetUp()
        DispatchQueue.main.async {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
               
                self.txtCoinQuantity.leftSpacing = 15
                self.txtCoinQuantity.rightSpacing =  125
                self.txtCoinQuantity.textAlignment = .right
            } else {
                self.txtCoinQuantity.leftSpacing = 15
                self.txtCoinQuantity.rightSpacing =  125
                self.txtCoinQuantity.textAlignment = .left
            }
        }
        lblTitle.font = AppFont.violetRegular(24).value
        txtCoinQuantity.font = AppFont.regular(13).value
        lblYourCoinBal.font = AppFont.regular(13).value
        lblAmountCoin.font = AppFont.regular(13).value
        btnCurruncy.titleLabel?.font = AppFont.regular(12).value
        btnToken.titleLabel?.font = AppFont.regular(12).value
        btnConfirm.titleLabel?.font = AppFont.violetRegular(16).value
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
        // Do any additional setup after loading the view.
    }
    fileprivate func uiSetUp() {
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        
        let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        lblTitle.text = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.requestforPayment, comment: ""))
        
        lblAmountCoin.text = "\(amount) \(coinDetail?.symbol ?? "")"
        btnToken.setTitle(coinDetail?.symbol ?? "", for: .normal)
        btnCurruncy.setTitle(WalletData.shared.primaryCurrency?.symbol, for: .normal)
        txtCoinQuantity.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtCoinQuantity.textAlignment = .right
            } else {
                txtCoinQuantity.textAlignment = .left
            }
            
        }
    @IBAction func btnConfirmAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        if isIPAD {
//            showBottonSheetIniPad()
//        } else {
//            showBottomSheet()
//        }
        
        guard let coinQuantityText = txtCoinQuantity.text?.trimmingCharacters(in: .whitespaces), !coinQuantityText.isEmpty else {
            showToast(message: ToastMessages.amountRequired, font: AppFont.regular(15).value)
            return
        }

        let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(coinDetail?.price ?? "") ?? 0.0)
        guard let coinAmount = !btnToken.isHidden ? Double(coinQuantityText) : coinQuantityFromPrice, let _ = Double(coinDetail?.balance ?? "") else {
            return
        }

        if coinAmount <= 0 {
            showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
            return
        }

        if !btnToken.isHidden {

            self.delegate?.addFiatAmount(tokenAmount: self.txtCoinQuantity.text ?? "",type: "coin", value: "", walletType: "other")
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        } else {
            let str = lblYourCoinBal.text ?? ""
            let stringWithoutPrefix = str.replacingOccurrences(of: "~", with: "")
            print(stringWithoutPrefix)
            if let result = extractSubstringBetweenWhitespaces(stringWithoutPrefix) {
                print(result)
                self.delegate?.addFiatAmount(tokenAmount: result,type: "currency",value: self.txtCoinQuantity.text ?? "", walletType: "other")
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    //    actionCoinTap
    @IBAction func btnTokenAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        btnToken.isHidden = true
        btnCurruncy.isHidden = false
        txtCoinQuantity.text = ""
        lblYourCoinBal.text = ""
        let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        lblAmountCoin.text = "\(amount) \(WalletData.shared.primaryCurrency?.symbol ?? "")"
    }
    //    actionCurrencyTap
    @IBAction func btnCurruncyAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        btnToken.isHidden = false
        btnCurruncy.isHidden = true
        txtCoinQuantity.text = ""
        lblYourCoinBal.text = ""
       let amount = (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: ""))
        lblAmountCoin.text = "\(amount) \(coinDetail?.symbol ?? "")"
    }
}

// MARK: UITextFieldDelegate
extension AddFiatAmountViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if textField == txtCoinQuantity {
            if !btnToken.isHidden {
                let payableAmount = ( (Double(text) ?? 0.0) * (Double(coinDetail?.price ?? "") ?? 0.0) ) / 1
                /// Will show payable amount
                
                let getbalance = WalletData.shared.formatDecimalString("\(payableAmount)", decimalPlaces: 10)
//                lblYourCoinBal.text = "~ \(WalletData.shared.primaryCurrency?.sign ?? "") \(getbalance)"
                
                lblYourCoinBal.text = "= \(WalletData.shared.primaryCurrency?.sign ?? "")\(getbalance)"
            } else {
                /// Will show payable token/coin
                let amount = (Double(text) ?? 0) / (Double(coinDetail?.price ?? "") ?? 0.0)
                let stringValue = String(amount)
                
                let getbalance = WalletData.shared.formatDecimalString("\(stringValue)", decimalPlaces: 8)
                lblYourCoinBal.text = "= \(getbalance) \(coinDetail?.symbol ?? "")"
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCoinQuantity {
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Try to add the new input
            if let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                
                // Check if there's already a decimal point in the text
                if updatedText.components(separatedBy: ".").count > 2 {
                    return false // Block if there are more than one decimal points
                }
            }
        }
            return true // Allow input if it's valid
        }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//           // This method is called whenever the user types or pastes characters
//
//           // If the paste action is performed
//
//        if textField == txtAddress {
//            if UIPasteboard.general.hasStrings, string.isEmpty {
//                // Call your action method
//            } else {
//                actionPaste(self)
//            }
//        }
//           return true
//       }

}
extension AddFiatAmountViewController {
    func extractSubstringBetweenWhitespaces(_ inputString: String) -> String? {
        // Find the indices of all whitespaces
        let whitespaceIndices = inputString.indices.filter { inputString[$0] == " " }

        // Check if there are at least two whitespaces
        guard whitespaceIndices.count >= 2 else {
            // Handle the case where there are fewer than two whitespaces
            print("Not enough whitespaces in the string.")
            return nil
        }

        // Extract the substring starting from the index after the first whitespace up to the index of the second whitespace
        let resultString = inputString[inputString.index(after: whitespaceIndices[0])..<whitespaceIndices[1]]
        
        return String(resultString)
    }
}
// MARK: Bottom Sheet
extension AddFiatAmountViewController {
    
    func showBottomSheet() {
        // Create an alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let metaMaskTitle = "MetaMask"
        //LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
        let metaMaskAction = UIAlertAction(title:metaMaskTitle , style: .default) { (_) in
            // Perform swap action
            print("metaMaskAction triggered")
            guard let coinQuantityText = self.txtCoinQuantity.text?.trimmingCharacters(in: .whitespaces), !coinQuantityText.isEmpty else {
                self.showToast(message: ToastMessages.amountRequired, font: AppFont.regular(15).value)
                return
            }
            
            let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(self.coinDetail?.price ?? "") ?? 0.0)
            guard let coinAmount = !self.btnToken.isHidden ? Double(coinQuantityText) : coinQuantityFromPrice, let _ = Double(self.coinDetail?.balance ?? "") else {
                return
            }
            
            if coinAmount <= 0 {
                self.showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
                return
            }
            
            if !self.btnToken.isHidden {
               
                self.delegate?.addFiatAmount(tokenAmount: self.txtCoinQuantity.text ?? "",type: "coin", value: "", walletType: "metaMask")
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                let str = self.lblYourCoinBal.text ?? ""
                let stringWithoutPrefix = str.replacingOccurrences(of: "~", with: "")
                print(stringWithoutPrefix)
                if let result = self.extractSubstringBetweenWhitespaces(stringWithoutPrefix) {
                    print(result)
                    self.delegate?.addFiatAmount(tokenAmount: result,type: "currency",value: self.txtCoinQuantity.text ?? "",walletType: "metaMask")
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
            }

        }
        let otherTitle = "Other"
        //LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
        let otherAction = UIAlertAction(title:otherTitle , style: .default) { (_) in
            // Perform swap action
            print("otherAction triggered")
            guard let coinQuantityText = self.txtCoinQuantity.text?.trimmingCharacters(in: .whitespaces), !coinQuantityText.isEmpty else {
                self.showToast(message: ToastMessages.amountRequired, font: AppFont.regular(15).value)
                return
            }
            
            let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(self.coinDetail?.price ?? "") ?? 0.0)
            guard let coinAmount = !self.btnToken.isHidden ? Double(coinQuantityText) : coinQuantityFromPrice, let _ = Double(self.coinDetail?.balance ?? "") else {
                return
            }
            
            if coinAmount <= 0 {
                self.showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
                return
            }
            
            if !self.btnToken.isHidden {
               
                self.delegate?.addFiatAmount(tokenAmount: self.txtCoinQuantity.text ?? "",type: "coin", value: "", walletType: "other")
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                let str = self.lblYourCoinBal.text ?? ""
                let stringWithoutPrefix = str.replacingOccurrences(of: "=", with: "")
                print(stringWithoutPrefix)
                if let result = self.extractSubstringBetweenWhitespaces(stringWithoutPrefix) {
                    print(result)
                    self.delegate?.addFiatAmount(tokenAmount: result,type: "currency",value: self.txtCoinQuantity.text ?? "",walletType: "other")
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let cancelTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
       
        alertController.addAction(metaMaskAction)
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func showBottonSheetIniPad() {
        
        if isIPAD {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            // Customize the height of the popover
            if let popoverController = alertController.popoverPresentationController {
                popoverController.permittedArrowDirections = []
                popoverController.sourceView = self.view

                // Set the sourceRect to cover the whole view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)

                // Customize the height of the popover
                let customHeight: CGFloat = 350
                alertController.preferredContentSize = CGSize(width: self.view.bounds.width, height: customHeight)
            }
            let metaMaskTitle = "MetaMask"
//            let swapTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
            let metaMaskAction = UIAlertAction(title: metaMaskTitle, style: .default) { (_) in
                print("metaMaskAction triggered")
                guard let coinQuantityText = self.txtCoinQuantity.text?.trimmingCharacters(in: .whitespaces), !coinQuantityText.isEmpty else {
                    self.showToast(message: ToastMessages.amountRequired, font: AppFont.regular(15).value)
                    return
                }
                
                let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(self.coinDetail?.price ?? "") ?? 0.0)
                guard let coinAmount = !self.btnToken.isHidden ? Double(coinQuantityText) : coinQuantityFromPrice, let _ = Double(self.coinDetail?.balance ?? "") else {
                    return
                }
                
                if coinAmount <= 0 {
                    self.showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
                    return
                }
                
                if !self.btnToken.isHidden {
                   
                    self.delegate?.addFiatAmount(tokenAmount: self.txtCoinQuantity.text ?? "",type: "coin", value: "", walletType: "metaMask")
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let str = self.lblYourCoinBal.text ?? ""
                    let stringWithoutPrefix = str.replacingOccurrences(of: "~", with: "")
                    print(stringWithoutPrefix)
                    if let result = self.extractSubstringBetweenWhitespaces(stringWithoutPrefix) {
                        print(result)
                        self.delegate?.addFiatAmount(tokenAmount: result,type: "currency",value: self.txtCoinQuantity.text ?? "",walletType: "metaMask")
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            let otherTitle = "other"
//            let swapTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
            let otherAction = UIAlertAction(title: otherTitle, style: .default) { (_) in
                print("otherAction triggered")
                guard let coinQuantityText = self.txtCoinQuantity.text?.trimmingCharacters(in: .whitespaces), !coinQuantityText.isEmpty else {
                    self.showToast(message: ToastMessages.amountRequired, font: AppFont.regular(15).value)
                    return
                }
                
                let coinQuantityFromPrice = (Double(coinQuantityText) ?? 0.0) / (Double(self.coinDetail?.price ?? "") ?? 0.0)
                guard let coinAmount = !self.btnToken.isHidden ? Double(coinQuantityText) : coinQuantityFromPrice, let _ = Double(self.coinDetail?.balance ?? "") else {
                    return
                }
                
                if coinAmount <= 0 {
                    self.showToast(message: ToastMessages.invalidAmount, font: AppFont.regular(15).value)
                    return
                }
                
                if !self.btnToken.isHidden {
                   
                    self.delegate?.addFiatAmount(tokenAmount: self.txtCoinQuantity.text ?? "",type: "coin", value: "", walletType: "other")
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let str = self.lblYourCoinBal.text ?? ""
                    let stringWithoutPrefix = str.replacingOccurrences(of: "~", with: "")
                    print(stringWithoutPrefix)
                    if let result = self.extractSubstringBetweenWhitespaces(stringWithoutPrefix) {
                        print(result)
                        self.delegate?.addFiatAmount(tokenAmount: result,type: "currency",value: self.txtCoinQuantity.text ?? "",walletType: "other")
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            let cancelTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            // Add action buttons to the alert controller
            alertController.addAction(metaMaskAction)
            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)

            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }

    }
}
