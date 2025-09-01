//
//  VerifyOtpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 21/03/24.
//

import UIKit
import IQKeyboardManagerSwift

protocol ResetCodeVCDelegate: AnyObject {
    func didVerifyOtp(phoneNumber:String,otp: String)
}
class VerifyOtpViewController: UIViewController {

    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var txtOtp: [UITextField]!
    @IBOutlet weak var btnNext: GradientButton!
    weak var delegate: ResetCodeVCDelegate?
    var otp = ""
    var phoneNumber = ""
    private var count = 30
    private var timer: Timer?
    var registerDic = [String:Any]()
    var isFromForgotPass = false
    lazy var cardUserViewModel: CardUserViewModel = {
        CardUserViewModel { _ ,message in
//            self.showToast(message: message, font: .systemFont(ofSize: 15))
           // self.btnDone.HideLoader()
        }
    }()
    
    lazy var resetConfirmCodeViewModel: ForgotPasswordViewModel = {
        ForgotPasswordViewModel { _ ,message in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // define Header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: true)
        for txtOTP in txtOtp {
            txtOTP.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmationsViaSMS, comment: "")
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.smsSendMsg, comment: "")
        self.btnNext.setTitle((LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: "")), for:.normal)
        lblTimer.isUserInteractionEnabled = false
        lblTimer.addTapGesture(target: self, action: #selector(self.handleTap(_:)))
        runTimer()
        
        lblTitle.font = AppFont.violetRegular(30).value
        lblMsg.font = AppFont.violetRegular(15).value
        // Do any additional setup after loading the view.
        
        setAttributedClickableText(labelName: lblResend, labelText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.dontReceiveOtp, comment: ""), value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.resendOtp, comment: ""), color: UIColor.label,linkColor: UIColor.blue)
    }
    @objc func handleTap(_ sender : UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
         self.resendOtpValue()
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
//           if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
//               txtOtp.textAlignment = .right
//              
//           } else {
//               txtOtp.textAlignment = .left
//           }
           
       }
    @objc private func updateTimer() {
        if count != 0 {
            count -= 1
            lblTimer.isUserInteractionEnabled = false
            lblTimer.text = "00:\(count) Sec"
        } else {
            invalidateTimer()
            lblTimer.isUserInteractionEnabled = true
            lblTimer.text = "Resend OTP"
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func resendOTP() {
        count = 30
        runTimer()
        self.resendOtpValue()
    }
    // resend otp
    func resendOtpValue() {
           let mobile = registerDic["mobile"] as? String ?? ""
           cardUserViewModel.resendOtpAPINew(mobile: mobile) { status, message, resData in
               if status == 1 {
                   IQKeyboardManager.shared.resignFirstResponder()
                   DispatchQueue.main.async {
                           self.showToast(message: resData?["result"] as? String ?? "", font: AppFont.regular(20).value)
                   }
                  
               } else {
                   IQKeyboardManager.shared.resignFirstResponder()
                   DispatchQueue.main.async {
                       self.showToast(message: message, font: AppFont.regular(20).value)
                   }
               }
           }
       }
    ///  continue button Action
        @IBAction func actionNext(_ sender: Any) {
            HapticFeedback.generate(.light)
            var otpText = ""
            for textField in txtOtp {
                if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    otpText += text
                }
            }
            if txtOtp.first?.text == "" {
                self.showSimpleAlert(Message: ToastMessages.otpEmpty)
            }
//            else if otp != otpText {
//                self.showSimpleAlert(Message: ToastMessages.otpvalid)
//            } 
            else {
                let mobile = registerDic["mobile"] as? String ?? ""
                let otp = otpText
                if isFromForgotPass == true {
                    DGProgressView.shared.showLoader(to: view)
                    resetConfirmCodeViewModel.resetConfirmCodeAPINew(code: otpText,phone: mobile) { status, message, resData in
                        
                        if status == 1 {
                            DGProgressView.shared.hideLoader()
                            
                            self.dismiss(animated: false) {
                                self.delegate?.didVerifyOtp(phoneNumber: mobile, otp: otpText)
                            }

                        } else {
                            DGProgressView.shared.hideLoader()
                            self.showSimpleAlert(Message: message)
                        }
                    }
                } else {
                    DGProgressView.shared.showLoader(to: view)
                    cardUserViewModel.signVerifyOtpAPINew(mobile: mobile , otp: otp) { status, message, resData in
                        
                        if status == 1 {
                            DGProgressView.shared.hideLoader()
                             let accessToken = resData?["access_token"] as? String  ?? ""
                                UserDefaults.standard.set(accessToken, forKey: loginApiToken)
                                let emailApiToken = UserDefaults.standard.value(forKey: loginApiToken)
                                print("emailApiToken=>",emailApiToken)
                            //}
                            
                            if self.isFromForgotPass == true {
                                let verifyEmailVC = VerifyEmailViewController()
                                verifyEmailVC.hidesBottomBarWhenPushed = true
                                //                        verifyEmailVC.phoneNo = mobile
                                self.navigationController?.pushViewController(verifyEmailVC, animated: true)
                                
                            } else {
                                let verifyEmailVC = VerifyEmailViewController()
                                verifyEmailVC.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(verifyEmailVC, animated: true)
                            }
                        } else {
                            DGProgressView.shared.hideLoader()
                            self.showSimpleAlert(Message: message)
                        }
                    }
                }
            }
        }
}
// MARK: - UITextFieldDelegate Methods
extension VerifyOtpViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 1 {
            textField.text = "\(String((textField.text?.last!)!))"
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if textField.text?.count ?? 0 > 0{
            if textField.tag == txtOtp.count - 1 {
                self.view.endEditing(true)
            } else {
                txtOtp[textField.tag + 1].becomeFirstResponder()
            }
        } else if textField.tag > 0{
            txtOtp[textField.tag - 1].becomeFirstResponder()
        }
        if textField.text?.count ?? 0 > 1{
            let currtext : String = textField.text ?? ""
            textField.text = "\(currtext.last!)"
        }
    }
    
    func setAttributedClickableText(labelName: UILabel, labelText: String, value: String, color: UIColor, linkColor: UIColor) {
        // Enable user interaction for the label
        labelName.isUserInteractionEnabled = true
        
        let commonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: AppFont.violetRegular(15).value
        ]
        
        let clickableAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: linkColor,
            .font: AppFont.violetRegular(15).value,
            .link: URL(string: "action://valueTapped")! // Custom URL scheme
        ]
        
        let partOne = NSMutableAttributedString(string: labelText, attributes: commonAttributes)
        let partTwo = NSMutableAttributedString(string: value, attributes: clickableAttributes)
        labelName.tintColor = UIColor.c2B5AF3
        partOne.append(partTwo)
        labelName.attributedText = partOne
        
        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap1))
        labelName.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleLabelTap1(_ gesture: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        self.resendOtpValue()
    }
}
