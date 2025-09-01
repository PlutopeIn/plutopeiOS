//
//  ForgotPasswordViewController.swift
//  Plutope
//
//  Created by sonoma on 16/05/24.
//

import UIKit
import Combine
import PhoneNumberKit

class ForgotPasswordViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitleForgetPass: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobileNo: PhoneNumberTextField!
    var countryCode : String? = ""
    
    lazy var forgotPasswordViewModel: ForgotPasswordViewModel = {
        ForgotPasswordViewModel { _ ,message in
        }
    }()
    
    fileprivate func uiSetUp() {
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")
                let font = AppFont.violetRegular(18).value
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font
                ]

                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        
        
        self.lblPhoneNumber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumber, comment: "")
        self.lblInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.restorePasswordMsg, comment: "")
        self.lblTitleForgetPass.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.forgotPassword, comment: "")
        self.lblSupport.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.support, comment: "")
        
        self.lblTitleForgetPass.font = AppFont.violetRegular(30).value
        self.lblInfo.font = AppFont.regular(15).value
        self.lblPhoneNumber.font = AppFont.regular(15).value
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
               txtMobileNo.textAlignment = .right
           } else {
               txtMobileNo.textAlignment = .left
              
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // define Header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false)
        // UI Setup
        uiSetUp()
        PhoneNumberKit.CountryCodePicker.alwaysShowsSearchBar = true
        txtMobileNo.withFlag = true
        txtMobileNo.withPrefix = true
        txtMobileNo.withExamplePlaceholder = true
        txtMobileNo.delegate = self
        self.lblSupport.addTapGesture {
            HapticFeedback.generate(.light)
            self.showWebView(for: URLs.faqURl, onVC: self, title:  "FAQ")
        }
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
    }
    @objc func phonNumberCheck() {
            do {
                if txtMobileNo.text == "" {
                   // lblValidNumber.isHidden = true
                    return
                }
                let number = "\(txtMobileNo.text ?? "")"
//                _ = try PhoneNumberKit.parse(number)
            } catch {
                print(error.localizedDescription)
                self.showSimpleAlert(Message:error.localizedDescription)
            }
        }
    func removeSpacesAndPrefix(from string: String) -> String {
        var modifiedString = string.replacingOccurrences(of: " ", with: "")
        
        // Remove leading `+` if it exists
        if modifiedString.hasPrefix("+") {
            modifiedString.removeFirst()
        }
        
        return modifiedString
    }
    @IBAction func actionContinue(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtMobileNo.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumberEmpty, comment: ""), font: AppFont.regular(20).value)
        } else {
            do {
                let phoneNumber = removeSpacesAndPrefix(from: txtMobileNo.text ?? "")
                print(phoneNumber)
                DGProgressView.shared.showLoader(to: view)
                forgotPasswordViewModel.apiForgotPasswordNew(phone: phoneNumber) { resStatus, message, dataValue in
                    if resStatus == 1 {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: message, font: UIFont.systemFont(ofSize: 20))
                        var dict = [String:Any]()
                        dict = ["mobile" :phoneNumber]

                        let verifyOtpVC = VerifyOtpViewController()
                        verifyOtpVC.otp = ""
                        verifyOtpVC.phoneNumber = "\(phoneNumber)"
                        verifyOtpVC.registerDic = dict
                        verifyOtpVC.isFromForgotPass = true
                        verifyOtpVC.delegate = self
                        self.present(verifyOtpVC, animated: true)
                    } else {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: message, font: AppFont.regular(20).value)
                    }
                }
            } catch {
                DGProgressView.shared.hideLoader()
               self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.validMobileNo, comment: ""), font: AppFont.regular(20).value)
            }
        }
    }
}
extension ForgotPasswordViewController : ResetCodeVCDelegate {
    func didVerifyOtp(phoneNumber: String, otp: String) {
        let resetCodeVC = ResetConfirmCodeViewController()
        
        resetCodeVC.phoneNumber = phoneNumber
        resetCodeVC.otp = otp
        resetCodeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resetCodeVC, animated: true)
    }
}
