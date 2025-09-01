//
//  LoginViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 01/08/23.
//

import UIKit
import Combine
import PhoneNumberKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtPassword: customTextField!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblSignUpLogin: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobileNo: PhoneNumberTextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    let server = serverTypes
    private var cancellables = Set<AnyCancellable>()
    var countryCode : String? = ""
    lazy var signInViewModel: SignInViewModel = {
        SignInViewModel { _ ,message in
        }
    }()
    private var viewModel = CountryCodeViewModel()
    
    internal var pickerData: [Country] = []
    
    let pickerView = UIPickerView()
    internal var countryArr: [Country] = []
    fileprivate func uiSetUp() {
        
        self.lblForgotPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.forgotpassword, comment: "")
        self.lblPhoneNumber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumber, comment: "")
        self.lblPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.password, comment: "")
        self.lblSignUpLogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.logIn, comment: "")
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.logIn, comment: "")
        let font = AppFont.violetRegular(18).value
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.btnContinue.setAttributedTitle(attributedTitle, for: .normal)
        
        self.lblSupport.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.support, comment: "")
        setAttributedClickableText(labelName: lblSignUp, labelText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.haveNotAccount, comment: "") , value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.signup, comment: ""), color: UIColor.label, linkColor: UIColor.blue)
        setAttributedClickableText(labelName: lblForgotPassword, labelText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.forgotpassword, comment: "") , value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.restorePassword, comment: ""), color: UIColor.label, linkColor: UIColor.blue)
        
        lblSignUpLogin.font = AppFont.violetRegular(30).value
        lblSignUp.font = AppFont.violetRegular(15).value
        lblPassword.font = AppFont.violetRegular(15).value
        lblPhoneNumber.font = AppFont.violetRegular(15).value
        lblForgotPassword.font = AppFont.violetRegular(15).value
        txtPassword.font = AppFont.regular(15).value
        txtMobileNo.font = AppFont.regular(15).value
        txtMobileNo.textColor = .label
        txtPassword.textColor = .label
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }
    @IBAction func btnShowPasswordAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtPassword.isSecureTextEntry.toggle()
        if txtPassword.isSecureTextEntry {
            
            let closeEyeImage = UIImage.closeEye
            let templateImage = closeEyeImage.withRenderingMode(.alwaysTemplate)
            btnShowPassword.setImage(templateImage, for: .normal)
            btnShowPassword.tintColor = UIColor.label
        } else {
            let openEyeImage = UIImage.eye
            let templateImage = openEyeImage.withRenderingMode(.alwaysTemplate)
            btnShowPassword.setImage(templateImage, for: .normal)
            btnShowPassword.tintColor = UIColor.label
        }
    }
    
    func handleLoginAttempt(phoneNumber: String, isSuccess: Bool, completion: @escaping (Bool) -> Void) {
        let userDefaults = UserDefaults.standard
        
        if isAccountBlocked(for: phoneNumber) {
            let remainingTime = userDefaults.blockEndTime(for: phoneNumber)!.timeIntervalSinceNow
            self.showToast(message: "Account is blocked. Please try again in \(Int(remainingTime / 60)) minutes.", font: UIFont.systemFont(ofSize: 20))
            completion(false)
            return
        }
        
        if isSuccess {
            // Reset attempts on successful login
            userDefaults.resetAttempts(for: phoneNumber)
            completion(true)
        } else {
            // Increment attempt count and check if max attempts reached
            let currentAttemptCount = userDefaults.attemptCount(for: phoneNumber) + 1
            userDefaults.setAttemptCount(currentAttemptCount, for: phoneNumber)
            userDefaults.setLastAttemptTime(Date(), for: phoneNumber)
            
            if currentAttemptCount >= Constants.maxAttempts {
                // Block account
                userDefaults.setBlockEndTime(Date().addingTimeInterval(Constants.blockDuration), for: phoneNumber)
                self.showToast(message: "Account is blocked for 30 minutes.", font: UIFont.systemFont(ofSize: 20))
                completion(false)
            } else {
                self.showToast(message: "Incorrect password. Attempts remaining: \(Constants.maxAttempts - currentAttemptCount)", font: UIFont.systemFont(ofSize: 20))
                completion(false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // UI Setup
        uiSetUp()
        PhoneNumberKit.CountryCodePicker.alwaysShowsSearchBar = true
        txtMobileNo.withFlag = true
        txtMobileNo.withPrefix = true
        txtMobileNo.withExamplePlaceholder = true
        txtMobileNo.delegate = self
       // txtMobileNo.addTarget(self, action: #selector(phonNumberCheck), for: .editingDidEnd)
        /// Action Forgot Password
        lblForgotPassword.addTapGesture {
            HapticFeedback.generate(.light)
            // Code for action
            let forgotPassVC = ForgotPasswordViewController()
            forgotPassVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(forgotPassVC, animated: true)
        }
        self.lblSignUp.addTapGesture {
            HapticFeedback.generate(.light)
            let signUpVC = RegisterCardViewController()
            signUpVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
        //        self.lblSupport.addTapGesture {
        //            self.showWebView(for: URLs.faqURl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""))
        //        }
        let closeEyeImage = UIImage.closeEye
        let templateImage = closeEyeImage.withRenderingMode(.alwaysTemplate)
        btnShowPassword.setImage(templateImage, for: .normal)
        btnShowPassword.tintColor = UIColor.label
        
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
                return
            }
            let number = "\(txtMobileNo.text ?? "")"
//            _ = try PhoneNumberKit.parse(number)
        } catch {
            print(error.localizedDescription)
            self.showSimpleAlert(Message:error.localizedDescription)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = view.currentFirstResponder() as? UITextField else { return }
        
        // Calculate the visible area by subtracting the keyboard height
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // Check if the active text field is hidden by the keyboard
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardHeight
        
        if !visibleRect.contains(activeTextField.frame.origin) {
            let scrollPoint = CGPoint(x: 0, y: activeTextField.frame.origin.y - keyboardHeight / 2)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the scroll view content insets
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.setContentOffset(.zero, animated: true)
    }

    deinit {
        // Remove observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtMobileNo.textAlignment = .right
            txtPassword.textAlignment = .right
            txtCountryCode.textAlignment = .right
        } else {
            txtMobileNo.textAlignment = .left
            txtPassword.textAlignment = .left
            txtCountryCode.textAlignment = .left
        }
        IQKeyboardManager.shared.isEnabled = false
    }
    func removeSpaces(from string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }

    @IBAction func actionContinue(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtMobileNo.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumberEmpty, comment: ""), font: AppFont.regular(20).value)
        } else if txtPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emptyPassword, comment: ""), font: AppFont.regular(20).value)
        } else {
            let phoneNumber = removeSpaces(from: txtMobileNo.text ?? "")
                loginApiCallNew(phoneNumber)
        }
    }
    
    func storeTokenExpirationDate(expirationDate: Date) {
        UserDefaults.standard.set(expirationDate, forKey: loginApiTokenExpirey)
    }
    
    func loginApiCallNew(_ phoneNumber: String) {
        DGProgressView.shared.showLoader(to: view)
        signInViewModel.apiSignInNew(phone: phoneNumber, password: txtPassword.text ?? "") { status, message, data in
           // print("Status: \(status)")
           // print("Message: \(message)")
            if status == 1 {
                if let data = data {
                    DGProgressView.shared.hideLoader()
                    if let accessToken = data["access_token"] as? String {
                        if accessToken != "" {
                            DispatchQueue.main.async {
                            
                                let cardMainVC = CardDashBoardViewController()
                                cardMainVC.hidesBottomBarWhenPushed = false
                                self.navigationController?.pushViewController(cardMainVC, animated: true)
                            }
                        }
                        UserDefaults.standard.set(accessToken, forKey: loginApiToken)
                        let loginApiToken = UserDefaults.standard.value(forKey: loginApiToken)
                        print("loginApiToken=>",loginApiToken)
                    }
                    if let refreshToken = data["refresh_token"] as? String {
                        UserDefaults.standard.set(refreshToken, forKey: loginApiRefreshToken)
                        let loginApirefreshToken = UserDefaults.standard.value(forKey: loginApiRefreshToken)
                    }
                    if let tokenType = data["token_type"] as? String {
                        UserDefaults.standard.set(tokenType, forKey: loginApiTokenType)
                        let loginApireTokenType = UserDefaults.standard.value(forKey: loginApiTokenType)
                    }
                    if let expiresIn = data["expires_in"] as? Double {
                        let expirationDate = Date().addingTimeInterval(expiresIn)
                        self.storeTokenExpirationDate(expirationDate: expirationDate)
                    }
                } else {
                    
                }
            } else {
                DGProgressView.shared.hideLoader()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.showToast(message: message, font: AppFont.regular(20).value)
                }
            }
        }
    }
    func storeToken(token: String, expiresIn: TimeInterval) {
        let expiryDate = Date().addingTimeInterval(expiresIn)
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.set(expiryDate, forKey: "tokenExpiryDate")
        UserDefaults.standard.synchronize()
    }
    func isTokenValid() -> Bool {
        if let expiryDate = UserDefaults.standard.object(forKey: "tokenExpiryDate") as? Date {
            return expiryDate > Date()
        }
        return false
    }
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
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
    }
}
extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let responder = subview.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
