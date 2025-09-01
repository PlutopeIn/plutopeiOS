//
//  VerifyOtpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 21/03/24.
//

import UIKit

class VerifyEmailViewController: UIViewController {
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtEmail: customTextField!
    @IBOutlet weak var btnNext: GradientButton!
    var phoneNo = ""
    var isFrom = ""
    let server = serverTypes
    lazy var cardUserViewModel: CardUserViewModel = {
        CardUserViewModel { _ ,message in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFrom == "settings" {
            // define Header
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.changeEmails, comment: ""), btnBackHidden: false)
            lblTitle.isHidden = true
            lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.changeEmails, comment: "")
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emailValidDescription, comment: "")
            self.btnNext.setTitle((LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")), for:.normal)
        } else {
            // define Header
            defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enteryouremail, comment: ""), btnBackHidden: false)
            lblTitle.isHidden = true
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emailValidDescription, comment: "")
            self.btnNext.setTitle((LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")), for:.normal)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
               txtEmail.textAlignment = .right
              
           } else {
               txtEmail.textAlignment = .left
           }
           
       }

    func changeEmailApiCallNew() {
       if isFrom == "settings" {
           DGProgressView.shared.showLoader(to: view)
           cardUserViewModel.addEmailAPINew(email: self.txtEmail.text ?? "") { status, message, resData in
               if status == 1 {
                   DGProgressView.shared.hideLoader()
                   self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.changeEmail, comment: ""), font: AppFont.regular(15).value)
                   if let navigationController = self.navigationController {
                       for viewController in navigationController.viewControllers {
                           if viewController is CardSettingsViewController {
                               navigationController.popToViewController(viewController, animated: true)
                               break
                           }
                       }
                   }
                   
               } else {
                   DGProgressView.shared.hideLoader()
                   self.showSimpleAlert(Message: message)
               }
           }
       } else {
           DGProgressView.shared.showLoader(to: view)
           cardUserViewModel.addEmailAPINew(email: self.txtEmail.text ?? "") { status, message, resData in
               if status == 1 {
                   DGProgressView.shared.hideLoader()
                   let cardUserProfileVC = CardUserProfileViewController()
                   cardUserProfileVC.isFromRegister = true
                   cardUserProfileVC.hidesBottomBarWhenPushed = true
                   self.navigationController?.pushViewController(cardUserProfileVC, animated: true)
               } else {
                   DGProgressView.shared.hideLoader()
                   self.showSimpleAlert(Message: message)
               }
           }
       }
   }
    ///  continue button Action
    @IBAction func actionNext(_ sender: Any) {
        HapticFeedback.generate(.light)
        if txtEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showSimpleAlert(Message: ToastMessages.emailEmpty)
        } else {
                changeEmailApiCallNew()
        }
    }
}
