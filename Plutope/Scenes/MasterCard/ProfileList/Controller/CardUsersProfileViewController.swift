//
//  CardUsersProfileViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/05/24.
//

import UIKit
import DGNetworkingServices
import ZendeskSDK
import ZendeskSDKMessaging
import IQKeyboardManagerSwift
struct UserFeaturs {
    var name : String?
    var image : UIImage?
}
class CardUsersProfileViewController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var ivCryptoLimit: UIImageView!
    @IBOutlet weak var ivFliatLimit: UIImageView!
    @IBOutlet weak var lblFlatLimitTitle: UILabel!
    @IBOutlet weak var lblFlatLimit: UILabel!
    @IBOutlet weak var lblCryptoLimitTitle: UILabel!
    @IBOutlet weak var lblCryptoLimit: UILabel!
    @IBOutlet weak var lblLimitTitle: UILabel!
    @IBOutlet weak var lblLimitMsg: UILabel!
    @IBOutlet weak var lblWaringMsg: UILabel!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvItems: UITableView!
    @IBOutlet weak var basicDetailsView: UIView!
    @IBOutlet weak var ivDone: UIImageView!
    var kyclevel = ""
    var kycStatus = ""
    var kycStatus2 = ""
    var kycLevel1Limit = ""
    var fiatLimit = ""
    let server = serverTypes
    var kycLimitArr : [KycLimitList] = []
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var kycViewModel: UpdateKYCViewModel = {
        UpdateKYCViewModel { _ ,_ in
        }
    }()
    lazy var signInViewModel: SignInViewModel = {
        SignInViewModel { _ ,_ in
        }
    }()
    var arrFeatures : [UserFeaturs] = []
    fileprivate func uiSetUp() {
        lblFlatLimitTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fiatlimitleft, comment: "")
        lblCryptoLimitTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cryptolimit, comment: "")
        btnIncrease.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.increase, comment: ""), for: .normal)
        self.arrFeatures = [UserFeaturs(name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.profiledetails, comment: ""), image: UIImage.icNewProfilePic),UserFeaturs(name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.settings, comment: ""), image: UIImage.icNewSetting),UserFeaturs(name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""), image: UIImage.icNewFAQ),UserFeaturs(name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.chatWithSupport, comment: ""),image: UIImage.icNewHelp),UserFeaturs(name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.logout, comment: ""), image: UIImage.icNewLogout)]
        
        lblUserName.font = AppFont.violetRegular(18).value
        lblFlatLimit.font = AppFont.violetRegular(20).value
        lblCryptoLimit.font = AppFont.violetRegular(20).value
        lblWaringMsg.font = AppFont.regular(14).value
        lblLimitMsg.font = AppFont.violetRegular(20).value
        lblFlatLimitTitle.font = AppFont.violetRegular(15).value
        lblCryptoLimitTitle.font = AppFont.violetRegular(15).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false)
        /// Table Register
        tableRegister()
        self.lblWaringMsg.isHidden = true
            getKycStatusNew()
            getKycLimitNew()
       
        let userName =  UserDefaults.standard.value(forKey: cardHolderfullName) as? String ?? ""
        let fiatlimit = UserDefaults.standard.value(forKey: fiateValue) as? String ?? ""
        if fiatlimit != "" {
            self.lblFlatLimit.text = fiatlimit
        }
        lblUserName.text = userName
        uiSetUp()

      }
    func zendeskInit() {
       let channelKey = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3BsdXRvcGVoZWxwZGVzay56ZW5kZXNrLmNvbS9tb2JpbGVfc2RrX2FwaS9zZXR0aW5ncy8wMUoyWlFZWFdNV0ZTNUVROENFODdLUFhZMi5qc29uIn0="
       
        Zendesk.initialize(withChannelKey: channelKey,messagingFactory: DefaultMessagingFactory()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.inputViewController?.showToast(message: "Initialization Successful", font: AppFont.regular(15).value)
                    
                    // Attempt to get the messaging view controller
                    if let chatVc = Zendesk.instance?.messaging?.messagingViewController() {
                       // viewController.HideKeyboardOnTouches()
     
//                        self.navigationController?.pushViewController(chatVc, animated: true)
                        if #available(iOS 17.0, *) {
                            chatVc.view?.keyboardLayoutGuide.keyboardDismissPadding = 20
                        } else {
                            // Fallback on earlier versions
                        }
                        chatVc.modalTransitionStyle = .crossDissolve
                        chatVc.modalPresentationStyle = .overFullScreen
                        
                        self.navigationController?.show(chatVc, sender: self)
                    } else {
                        self.inputViewController?.showSimpleAlert(Message: "Failed to retrieve messaging view controller.")
                        print("Zendesk.instance?.messaging?.messagingViewController() is nil.")
                    }
                    
                case .failure(let error):
                    self.inputViewController?.showSimpleAlert(Message: error.localizedDescription)
                    print("Zendesk initialization failed: \(error.localizedDescription)")
                }
            }
        }
        
   }
    @IBAction func btnIncreaseAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if self.kycStatus == "UNDEFINED" {
            let updateKycVC = UpdateKYCViewController()
            updateKycVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateKycVC, animated: true)
        } else if self.kycStatus == "APPROVED" {
//            self.showSimpleAlert(Message: "KYC APPROVED")
//            if self.kycStatus2 == "UNDEFINED" {
//              //  let updateKycVC = UpdateKYCViewController()
//            updateKycVC.hidesBottomBarWhenPushed = true
//              //  self.navigationController?.pushViewController(updateKycVC, animated: true)
//            } else if self.kycStatus2 == "APPROVED" {
//                self.showSimpleAlert(Message: "KYC2 APPROVED")
//                
//            } else {
//                self.showSimpleAlert(Message: "UNDEFINED")
//            }
        } else {
            self.showSimpleAlert(Message: "UNDEFINED")
        }
       
    }
    /// Table Register
    func tableRegister() {
        tbvItems.delegate = self
        tbvItems.dataSource = self
        tbvItems.register(SettingViewCell.nib, forCellReuseIdentifier: SettingViewCell.reuseIdentifier)

    }
    
    func logOut() {
        self.showYesNoAlertAndPerform(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.logoutmsg, comment: ""), noaction: { (action) in
                        self.dismiss(animated: true)
                    }) { (action) in
                            self.userLogoutNew()
                    }
    }
    func showYesNoAlertAndPerform(message: String, noaction: ((UIAlertAction) -> Void)?, yesAction: ((UIAlertAction) -> Void)?) {
            
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.no, comment: ""), style: .cancel, handler: noaction))
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yes, comment: ""), style: .default, handler: yesAction))
            
            self.present(alert, animated: true, completion: nil)
            
        }
}
