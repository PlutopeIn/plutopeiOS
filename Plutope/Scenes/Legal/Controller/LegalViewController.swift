//
//  LegalViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
class LegalViewController: UIViewController, Reusable {
    @IBOutlet weak var ivCheckUncheck: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var viewAgreement: UIView!
    @IBOutlet weak var viewPrivacyPolicy: UIView!
    @IBOutlet weak var viewTermCondition: UIView!
    @IBOutlet weak var lblReviewPlutoPe: UILabel!
    @IBOutlet weak var lblTermsOfService: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    
    @IBOutlet weak var lblMsg: UILabel!
    var isChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
        defineHeader(headerView: headerView, titleText:LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.legal, comment: ""))
        
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblReviewPlutoPe.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleasereviewtheplutopetermsofservicesandprivacypolicy, comment: "")
        self.lblPrivacy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.privacypolicy, comment: "")
        self.lblTermsOfService.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsofservice, comment: "")
        self.lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.legalMsg, comment: "")
        /// Agreement view tap action
        viewAgreement.addTapGesture(target: self, action: #selector(agreementViewTapped))
        viewPrivacyPolicy.addTapGesture(target: self, action: #selector(privacyPolicyTapped))
        viewTermCondition.addTapGesture(target: self, action: #selector(termsConditionTapped))
        
        /// Default continue button will remain disabled
        if !isChecked {
            self.btnContinue.alpha = 0.5
            self.btnContinue.isEnabled = false
        }
    }
    
    @objc func agreementViewTapped(_ sender: UITapGestureRecognizer) {
        isChecked.toggle()
        if isChecked {
            self.ivCheckUncheck.image = UIImage.check
            self.btnContinue.alpha = 1
            self.btnContinue.isEnabled = true
        } else {
            self.ivCheckUncheck.image = UIImage.uncheck
            self.btnContinue.alpha = 0.5
            self.btnContinue.isEnabled = false
        }
    }
    
    @objc func privacyPolicyTapped(_ sender: UITapGestureRecognizer) {
        //showWebView(for: URLs.privacyUrl, onVC: self, title: StringConstants.privacyPolicy)
        showWebView(for: URLs.privacyUrl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.privacypolicy, comment: ""))
    }
    
    @objc func termsConditionTapped(_ sender: UITapGestureRecognizer) {
        //showWebView(for: URLs.termConditionUrl, onVC: self, title: StringConstants.termCondition)
        showWebView(for: URLs.termConditionUrl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsofservice, comment: ""))
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        let viewToNavigate = CreatePasscodeViewController()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
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
