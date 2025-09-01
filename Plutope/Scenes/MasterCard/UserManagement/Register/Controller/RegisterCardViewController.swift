//
//  RegisterCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/03/24.
//

import UIKit
import Combine
import PhoneNumberKit
class RegisterCardViewController: UIViewController {
    
    
    @IBOutlet weak var txtconfirmPassword: customTextField!
    @IBOutlet weak var lblconfirmPassword: UILabel!
    
    @IBOutlet weak var btnShowConfirmPassword: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var lblInfoMsg: UILabel!
    @IBOutlet weak var txtPassword: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSignIn: UILabel!
    
    @IBOutlet weak var viewAgreement: UIView!
    
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var lblPhoneTitle: UILabel!
    
    @IBOutlet weak var lblPasswordTitle: UILabel!
    @IBOutlet weak var txtMobileNo: PhoneNumberTextField!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var ivCheckUncheck: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var passwordInfoView: UIView!
    
    @IBOutlet weak var viewTxtphone: UIView!
    
    @IBOutlet weak var imgInfoMsg: UIImageView!
    var isChecked: Bool = false
    let server = serverTypes

    lazy var cardUserViewModel: CardUserViewModel = {
        CardUserViewModel { _ ,message in
//            self.showToast(message: message, font: .systemFont(ofSize: 15))
           // self.btnDone.HideLoader()
        }
    }()
    
    fileprivate func uiSetUp() {
        
        lblPasswordTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.password, comment: ""))"
        lblconfirmPassword.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmpassword, comment: ""))"
        lblPhoneTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumber, comment: ""))"
        setAttributedClickableText(labelName: lblSignIn, labelText: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.haveAccount, comment: "")) ", value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.logIn, comment: ""), color: UIColor.label, linkColor: UIColor.blue)
        
        setAttributedClickableText(labelName: lblMsg, labelText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardPolicyMsg, comment: ""), value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsAndConditions, comment: ""), color: UIColor.label,linkColor: UIColor.blue)
        
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createAccount, comment: "")
        lblInfoMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardInfoMsg, comment: "")
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getStared, comment: "")
                let font = AppFont.violetRegular(18).value
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font
                ]

                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        
        
        self.lblSupport.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.support, comment: "")
        
        let btnContinueTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.getStared, comment: "")
        let btnContinueAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFont.violetRegular(18).value, // Replace "YourFontName" with your custom font name and 17 with desired font size
            .foregroundColor: UIColor.systemBackground // Adapts to light/dark mode
        ]
        let btnContinueAttributTitle = NSAttributedString(string: btnContinueTitle, attributes: btnContinueAttributes)

        // Set the attributed title for the button
        btnContinue.setAttributedTitle(btnContinueAttributTitle, for: .normal)
        btnContinue.backgroundColor = UIColor.secondarySystemFill
        
        if let closeEyeImage = UIImage(named: "closeEye")?.withRenderingMode(.alwaysTemplate) {
            btnShowPassword.setImage(closeEyeImage, for: .normal)
            btnShowPassword.tintColor = UIColor.label
        }
        if let closeEyeConfirmPwdImage = UIImage(named: "closeEye")?.withRenderingMode(.alwaysTemplate) {
            btnShowConfirmPassword.setImage(closeEyeConfirmPwdImage, for: .normal)
            btnShowConfirmPassword.tintColor = UIColor.label
        }
        txtMobileNo.textColor = UIColor.label
        lblTitle.font = AppFont.violetRegular(30).value
        lblSignIn.font = AppFont.violetRegular(20).value
        lblPhoneTitle.font = AppFont.violetRegular(15).value
        lblPasswordTitle.font = AppFont.violetRegular(15).value
        lblMsg.font = AppFont.violetRegular(15.31).value
        lblInfoMsg.font = AppFont.violetRegular(15.31).value
        
        self.ivCheckUncheck.imageTintColor = UIColor.label
    }
    
    
    @IBAction func btnShowConfirmPasswordAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtconfirmPassword.isSecureTextEntry.toggle()
        if txtconfirmPassword.isSecureTextEntry {
            if let closeEyeImage = UIImage(named: "closeEye")?.withRenderingMode(.alwaysTemplate) {
                btnShowConfirmPassword.setImage(closeEyeImage, for: .normal)
                btnShowConfirmPassword.tintColor = UIColor.black
            }
            
        } else {
            if let eyeImage = UIImage(named: "Eye")?.withRenderingMode(.alwaysTemplate) {
                btnShowConfirmPassword.setImage(eyeImage, for: .normal)
                btnShowConfirmPassword.tintColor = UIColor.black
            }
        }
    }
    @IBAction func btnShowPasswordAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPassword.isSecureTextEntry.toggle()
        if txtPassword.isSecureTextEntry {
            if let closeEyeImage = UIImage(named: "closeEye")?.withRenderingMode(.alwaysTemplate) {
                btnShowPassword.setImage(closeEyeImage, for: .normal)
                btnShowPassword.tintColor = UIColor.black
            }
            
        } else {
            if let eyeImage = UIImage(named: "Eye")?.withRenderingMode(.alwaysTemplate) {
                btnShowPassword.setImage(eyeImage, for: .normal)
                btnShowPassword.tintColor = UIColor.black
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // define Header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false,btnRightImage: UIImage(named: "ic_support"),btnRightAction: {
            HapticFeedback.generate(.light)
            self.showWebView(for: URLs.faqURl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""))
        })
        // UI Setup
        uiSetUp()
        PhoneNumberKit.CountryCodePicker.alwaysShowsSearchBar = true
        txtMobileNo.withFlag = true
        txtMobileNo.withPrefix = true
        txtMobileNo.delegate = self
        
        self.lblSupport.addTapGesture {
            HapticFeedback.generate(.light)
            self.showWebView(for: URLs.faqURl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""))
        }
        // Set up tap gesture recognizer
         let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap1(_:)))
        lblMsg.addGestureRecognizer(tapGesture1)
        lblSignIn.addTapGesture {
            HapticFeedback.generate(.light)
            print("login")
                let loginVc = LoginViewController()
                self.navigationController?.pushViewController(loginVc, animated: true)
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
        /// Default continue button will remain disabled
        if !isChecked {
            self.btnContinue.isEnabled = false
            btnContinue.backgroundColor = UIColor.secondarySystemFill
        }
        ivCheckUncheck.addTapGesture {
            HapticFeedback.generate(.light)
            self.isChecked.toggle()
            if self.isChecked {
                self.ivCheckUncheck.image = UIImage.icNewcheck.sd_tintedImage(with: UIColor.label)
                self.ivCheckUncheck.imageTintColor = UIColor.label
                self.btnContinue.isEnabled = true
                self.btnContinue.backgroundColor = UIColor.label
            } else {
                self.ivCheckUncheck.image = UIImage.newuncheck.sd_tintedImage(with: UIColor.label)
                self.ivCheckUncheck.imageTintColor = UIColor.label
                self.btnContinue.isEnabled = false
                self.btnContinue.backgroundColor = UIColor.secondarySystemFill
            }
        }
        passwordInfoView.addTapGesture(target: self, action:#selector(passwordInfoViewTapped) )
    }
    @objc func passwordInfoViewTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        let viewToNavigate = PasswordInfoPopUpViewController()
        viewToNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewToNavigate, animated: false)

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
 override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtMobileNo.textAlignment = .right
            txtPassword.textAlignment = .right
        } else {
            txtMobileNo.textAlignment = .left
            txtPassword.textAlignment = .left
        }
        
    }
    
    fileprivate func signUpApiNew(_ phoneNumber: String) {
        cardUserViewModel.signUpAPINew(phone: phoneNumber, password: txtPassword.text ?? "") { resStatus, message, _ in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.showToast(message: message, font: UIFont.systemFont(ofSize: 20))
                var dict = [String:Any]()
                dict = ["mobile" :phoneNumber]
                
                let verifyOtpVC = VerifyOtpViewController()
                verifyOtpVC.otp = ""
                verifyOtpVC.registerDic = dict
                verifyOtpVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(verifyOtpVC, animated: true)
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: message, font: AppFont.regular(20).value)
            }
        }
    }
    @IBAction func btnNextAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtMobileNo.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumberEmpty, comment: ""), font: AppFont.regular(20).value)
        } else if txtPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyPassword, comment: ""), font: AppFont.regular(20).value)
        } else if !txtPassword.isValidPassword(txtPassword.text ?? "") {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.validPassword, comment: ""), font: UIFont.systemFont(ofSize: 20))
        } else if txtconfirmPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyConfirmPassword, comment: ""), font: AppFont.regular(20).value)
        } else if txtPassword.text != txtconfirmPassword.text {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmPasswordNotMatchReg, comment: ""), font: UIFont.systemFont(ofSize: 20))
        } else {
            do {
                let phoneNumber = removeSpaces(from: txtMobileNo.text ?? "")
                print(phoneNumber)
                DGProgressView.shared.showLoader(to: view)
               // signUpApi(phoneNumber)
                signUpApiNew(phoneNumber)
            } catch {
                DGProgressView.shared.hideLoader()
               self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.validMobileNo, comment: ""), font: AppFont.regular(20).value)
            }
        }
    }
    func removeSpaces(from string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    @objc func agreementViewTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        isChecked.toggle()
        if isChecked {
            self.ivCheckUncheck.image = UIImage.icNewcheck.sd_tintedImage(with: UIColor.label)
//            self.btnContinue.alpha = 1
            self.btnContinue.isEnabled = true
            btnContinue.backgroundColor = UIColor.label
        } else {
            self.ivCheckUncheck.image = UIImage.newuncheck.sd_tintedImage(with: UIColor.label)
//            self.btnContinue.alpha = 0.5
            self.btnContinue.isEnabled = false
            btnContinue.backgroundColor = UIColor.secondarySystemFill
        }
    }

    /// set attributed text
    func setAttributedText(labelName : UILabel,labeltext: String,value: String,color: UIColor) {
        
        let commonAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: AppFont.regular(14).value]
        
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: AppFont.regular(14).value]
        
        let partOne = NSMutableAttributedString(string: labeltext, attributes: commonAttributes)
        let partTwo = NSMutableAttributedString(string: value, attributes: yourOtherAttributes)
        
        partOne.append(partTwo)
        labelName.attributedText = partOne
    }
}
extension RegisterCardViewController {
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
        showWebView(for: URLs.registerTermsUrl, onVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsAndConditions, comment: ""))
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
}
