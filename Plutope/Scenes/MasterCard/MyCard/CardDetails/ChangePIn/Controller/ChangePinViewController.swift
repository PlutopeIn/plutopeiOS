//
//  ChangePinViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/09/24.
//

import UIKit
import SVPinView
import DGNetworkingServices
class ChangePinViewController: UIViewController {
    
    @IBOutlet weak var otpViewTextField: SVPinView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var btnClose: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var txtOtp: [UITextField]!
    @IBOutlet var lblValidationText: UILabel!
    @IBOutlet weak var btnSubmit: GradientButton!
    weak var delegate : MasterCardInfoDetailsDelegate?
    var payinDataArr: PayinCreateOfferList?
    var arrCardList : Card?
    var cardNumber = ""
    var code = ""
    var pinNo = ""
    var publicKey = ""
    var privetKey = ""
    var isFromCardDetails = false
    var isFromCardFreeze = false
    var isFromCardUnFreeze = false
    var isFromBuyCrypto = false
    var isFrom = ""
    var isFromDashboard = ""
    
    //// buy crypto
    var fromAmount = ""
    var fromCurrency = ""
    var toCurrency = ""
    var toAmount = ""
    var address = ""
    var cvv = ""
    var cardId = ""
    var offerId = ""
    
    lazy var changeCardPinViewModel: ChangeCardPinViewModel = {
        ChangeCardPinViewModel { _ ,_ in
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnClose.addTapGesture(target: self, action: #selector(closeScreen))
        //OTP filed setups
        otpViewTextField.style = .box
        otpViewTextField.font = AppFont.regular(13).value
        lblValidationText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.comeupWithPinWarning, comment: "")
        btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.done, comment: ""), for: .normal)
        if isFrom == "buyCrypto" {
            otpViewTextField.pinLength = 3
            //txtOtp[2].isHidden = true
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.comeupWithPin, comment: "")
        } else {
          //  txtOtp[2].isHidden = false
            otpViewTextField.pinLength = 4
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.comeupWithPin, comment: "")
        }
    }
    
    func pinView(_ pinView: SVPinView, didEnter pin: String) {
        if isValidPin(pin) {
            // PIN is valid
            lblValidationText.textColor = UIColor.label
            // Proceed with the next steps
        } else {
            // PIN is invalid
            lblValidationText.textColor = UIColor.systemRed
            // Show an error message or prompt the user to try again
        }
    }
    
    func isValidPin(_ pin: String) -> Bool {
        // Check if the PIN length is exactly 4 characters
        guard pin.count >= 4 else {
            return false
        }
        
        // Convert the PIN into an array of characters for easier access
        let pinArray = Array(pin)
        
        // Check for three identical consecutive numbers
        for objI in 0..<pinArray.count - 2 {
            if pinArray[objI] == pinArray[objI + 1] && pinArray[objI] == pinArray[objI + 2] {
                return false
            }
        }
        
        // Check for sequential numbers
        for objJ in 0..<pinArray.count - 2 {
            if let num1 = pinArray[objJ].wholeNumberValue,
               let num2 = pinArray[objJ + 1].wholeNumberValue,
               let num3 = pinArray[objJ + 2].wholeNumberValue {
                if num2 == num1 + 1 && num3 == num2 + 1 {
                    return false
                }
            }
        }
        
        return true
    }
    
    @objc func closeScreen() {
        HapticFeedback.generate(.light)
        if isFrom == "buyCrypto" {
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: false)
        } else {
            self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: false)
        }
    }
    func changeCardPin(otp: String) {
        DGProgressView.shared.showLoader(to: view)
        changeCardPinViewModel.apiChangeCardPin(cardId: self.cardId, code: otp) { status, msg, data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.dismiss(animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.showToast(message: "Your Pin Change Successfully", font: AppFont.regular(15).value)
                        }
                    }
                }
            } else {
                DGProgressView.shared.hideLoader()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showToast(message: "\(msg)", font: AppFont.regular(15).value)
                }
            }
        }
        
        
        //let apiUrl = "\(ServiceNameConstant.BaseUrl.baseUrlNew)\(ServiceNameConstant.appVersion)\(ServiceNameConstant.BaseUrl.card)\(cardId)\(ServiceNameConstant.changeCardPin)"
//        let header = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
//        print(header)
//
//        var parameter = [String:Any]()
//        parameter["code"] = code
////        parameter["publicKey"] = publicKey
//        print("Param =",parameter)
        
//        var request = URLRequest(url: URL(string: "https://api.crypterium.com/v2/card/\(arrCardList?.id ?? 0)/pin?cp=CP_2")!,timeoutInterval: Double.infinity)
//        
//        let parameters = "{\r\n    \"pin\" : \"\(otp)\"\r\n}"
//        let postData = parameters.data(using: .utf8)
//        
//        print("Param: \(parameters)")
//        print("URL: \(request)")
//        
//        request.addValue("Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")", forHTTPHeaderField: "authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//        
//        let task = URLSession.shared.dataTask(with:  request) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                return
//            }
//            print("Result Data:- \(String(data: data, encoding: .utf8)!)")
//            do {
//                DGProgressView.shared.hideLoader()
//                // Decode the data to your ChangeCardPInResponseDataModel
//                let decoder = JSONDecoder()
//                let responseData = try decoder.decode(ChangeCardPInResponseDataModel.self, from: data)
//                
//                // Now you can use the responseData object
//               // print("Message: \(responseData.message ?? "No message")")
//                //print("Error ID: \(String(describing: responseData.errorID))")
//                //print("System ID: \(responseData.systemID ?? "No system ID")")
//                //print("Error: \(responseData.error ?? "No error")")
//                print("Response Data: \(responseData)")
//                if responseData.message == nil && responseData.error == nil && responseData.systemID == nil && responseData.error == nil {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//                        self.dismiss(animated: true) {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                                self.showToast(message: "Your Pin Change Successfully", font: AppFont.regular(15).value)
//                            }
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        self.showToast(message: "\(responseData.message ?? "")", font: AppFont.regular(15).value)
//                    }
//                }
//                
//            } catch let decodingError {
//                print("Decoding Error: \(decodingError)")
//            }
//        }
//        task.resume()
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        print(otpViewTextField.getPin())
        
        if otpViewTextField.getPin().count > 0 {
            changeCardPin(otp: otpViewTextField.getPin())
        } else {
            self.showSimpleAlert(Message: ToastMessages.otpEmpty)
        }
    }

}
