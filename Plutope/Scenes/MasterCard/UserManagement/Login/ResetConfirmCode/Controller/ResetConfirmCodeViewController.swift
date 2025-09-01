//
//  ResetConfirmCodeViewController.swift
//  Plutope
//
//  Created by sonoma on 17/05/24.
//

import UIKit

class ResetConfirmCodeViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtConfirmPassword: customTextField!
    @IBOutlet weak var lblConfirmPass: UILabel!
    @IBOutlet weak var lblNewPass: UILabel!
    @IBOutlet weak var txtNewpassword: customTextField!
    @IBOutlet weak var btnHideConfirmPass: UIButton!
    @IBOutlet weak var lblInfoMsg: UILabel!
    @IBOutlet weak var btnHideNewPass: UIButton!
    @IBOutlet weak var btnContinue: GradientButton!
    
    var phoneNumber = ""
    var otp = ""
    
    lazy var forgotPasswordViewModel: ForgotPasswordViewModel = {
        ForgotPasswordViewModel { _ ,message in
        }
    }()
    
    fileprivate func uiSetUp() {
        self.lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createaNewPassword, comment: "")
        self.txtNewpassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.newPassword, comment: "")
        self.txtConfirmPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmPassword, comment: "")
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")
        let font = AppFont.violetRegular(18).value
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        
        self.lblInfoMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardInfoMsg, comment: "")
        
        self.lblHeading.font = AppFont.violetRegular(30).value
        self.lblInfoMsg.font = AppFont.regular(15).value
        self.txtNewpassword.font = AppFont.regular(15).value
        self.txtConfirmPassword.font = AppFont.regular(15).value
        
    }
    
    @IBAction func btnConfirmShowPasswordAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtConfirmPassword.isSecureTextEntry.toggle()
        if txtConfirmPassword.isSecureTextEntry {
            btnHideConfirmPass.setImage(UIImage.closeEye, for: .normal)
        } else {
            btnHideConfirmPass.setImage(UIImage.eye, for: .normal)
        }
    }
    @IBAction func btnNewShowPasswordAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtNewpassword.isSecureTextEntry.toggle()
        if txtNewpassword.isSecureTextEntry {
            btnHideNewPass.setImage(UIImage.closeEye, for: .normal)
        } else {
            btnHideNewPass.setImage(UIImage.eye, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // define Header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false)
        uiSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
               txtNewpassword.textAlignment = .right
               txtConfirmPassword.textAlignment = .right
           } else {
               txtNewpassword.textAlignment = .left
               txtConfirmPassword.textAlignment = .left
           }
           
       }
    @IBAction func btnNextAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtConfirmPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyPassword, comment: ""), font: AppFont.regular(20).value)
        }
//        else if !txtConfirmPassword.isValidPassword(txtConfirmPassword.text ?? "") {
//            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.validPassword, comment: ""), font: UIFont.systemFont(ofSize: 20))
//        } 
        else if txtNewpassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyPassword, comment: ""), font: AppFont.regular(20).value)
        }
//        else if !txtNewpassword.isValidPassword(txtNewpassword.text ?? "") {
//            self.showToast(message: "Please Enter valid Password", font: UIFont.systemFont(ofSize: 20))
//        }
        else if txtConfirmPassword.text != txtNewpassword.text {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmPasswordNotMatch, comment: ""), font: UIFont.systemFont(ofSize: 20))
        } else {
            do {
                DGProgressView.shared.showLoader(to: view)
                forgotPasswordViewModel.apiResetPasswordNew(code: self.otp, password: txtNewpassword.text ?? "", phone: self.phoneNumber) { resStatus, message, dataValue in
                    if resStatus == 1 {
                        DGProgressView.shared.hideLoader()
                        DispatchQueue.main.async {
                            self.showToast(message: message, font: UIFont.systemFont(ofSize: 20))
                        }
                        
                        let verifyOtpVC = LoginViewController()
                        verifyOtpVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(verifyOtpVC, animated: true)
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
