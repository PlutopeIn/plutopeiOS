//
//  ChangePasswordViewController.swift
//  Plutope
//
//  Created by sonoma on 24/05/24.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordInfoView: UIView!
    @IBOutlet weak var btnHideConfirmPass: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtOldPassword: customTextField!
   
    @IBOutlet weak var txtNewpassword: customTextField!
    @IBOutlet weak var btnHideOldPass: UIButton!
    @IBOutlet weak var lblInfoMsg: UILabel!
    @IBOutlet weak var btnHideNewPass: UIButton!
    @IBOutlet weak var btnContinue: GradientButton!
   
    @IBOutlet weak var txtConfirmPas: customTextField!
    let server = serverTypes
    var phoneNumber = ""
    var otp = ""
    
    lazy var forgotPasswordViewModel: ForgotPasswordViewModel = {
        ForgotPasswordViewModel { _ ,message in
        }
    }()
    
    fileprivate func uiSetUp() {
        self.lblHeading.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.changepassword, comment: "")

        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")
                let font = AppFont.violetRegular(18).value
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font
                ]

                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        self.lblInfoMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardInfoMsg, comment: "")
      
        txtNewpassword.font = AppFont.regular(15).value
        txtConfirmPas.font = AppFont.regular(15).value
        lblInfoMsg.font = AppFont.regular(13).value
    }
    @IBAction func btnHideConfirmPassAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtConfirmPas.isSecureTextEntry.toggle()
        if txtConfirmPas.isSecureTextEntry {
            btnHideConfirmPass.setImage(UIImage.closeEye, for: .normal)
        } else {
            btnHideConfirmPass.setImage(UIImage.eye, for: .normal)
        }
    }
    @IBAction func btnOldShowPasswordAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtOldPassword.isSecureTextEntry.toggle()
        if txtOldPassword.isSecureTextEntry {
            btnHideOldPass.setImage(UIImage.closeEye, for: .normal)
        } else {
            btnHideOldPass.setImage(UIImage.eye, for: .normal)
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
        passwordInfoView.addTapGesture(target: self, action:#selector(passwordInfoViewTapped) )
    }
    @objc func passwordInfoViewTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        let viewToNavigate = PasswordInfoPopUpViewController()
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
               txtNewpassword.textAlignment = .right
               txtOldPassword.textAlignment = .right
               txtConfirmPas.textAlignment = .right
           } else {
               txtNewpassword.textAlignment = .left
               txtOldPassword.textAlignment = .left
               txtConfirmPas.textAlignment = .left
           }
           
       }
    @IBAction func btnNextAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtOldPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: "Enter currunt password", font: AppFont.regular(20).value)
        } else if txtNewpassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: "Enter new password", font: AppFont.regular(20).value)

        } else if txtConfirmPas.text!.trimmingCharacters(in: .whitespaces).isEmpty {

            self.showToast(message: "Enter confirm password", font: AppFont.regular(20).value)
        } else if txtNewpassword.text != txtConfirmPas.text {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmPasswordNotMatch, comment: ""), font: AppFont.regular(20).value)
        }
 
        else {
            do {
                DGProgressView.shared.showLoader(to: view)
                    forgotPasswordViewModel.apiChangePasswordNew(currentPassword: txtOldPassword.text ?? "", newPassword: txtNewpassword.text ?? "") { resStatus, message, dataValue in
                        if resStatus == 1 {
                            DGProgressView.shared.hideLoader()
                            self.showToast(message: message, font: AppFont.regular(15).value)
                            
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            DGProgressView.shared.hideLoader()
                            self.showToast(message: message, font: AppFont.regular(15).value)
                        }
                    }

                
            } catch {
                DGProgressView.shared.hideLoader()
               self.showToast(message: "Please enter valid mobile number", font: AppFont.regular(20).value)
            }
        }
    }
}
