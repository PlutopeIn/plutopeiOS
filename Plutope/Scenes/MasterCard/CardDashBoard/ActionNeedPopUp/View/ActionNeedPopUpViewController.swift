//
//  ActionNeedPopUpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 03/06/24.
//

import UIKit
protocol ActionNeedPopUpDelegate : AnyObject {
    func refreshCards()
    func goToNextScreen(isStatus:String)
}
class ActionNeedPopUpViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
  
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var btnSubmit: GradientButton!
    @IBOutlet weak var btnCancel: GradientButton!
    weak var delegate : ActionNeedPopUpDelegate?
    var arrCardList : Card?
    var cardRequestId = 0
    var isStatus = ""
    var isFrom = ""
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.actionNeeded, comment: "")
        btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancelOrder, comment: ""), for: .normal)
        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
        if isFrom == "order" {
            btnCancel.isHidden = true
        } else {
            btnCancel.isHidden = false
        }
//        if isStatus == "support"  || isStatus == "inProgress" {
//            btnSubmit.setTitle("Contact Support", for: .normal)
//        }
            
        if isStatus == "Kyc" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.someOfTheSubmittedDocumentsDontMeetOurRequirements, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.resubmitDocuments, comment: ""), for: .normal)
        } else if isStatus == "addresss" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleaseUpdateYourShippingAddressYouHaventUpdatedItBefore, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.updateAddress, comment: ""), for: .normal)
        } else if isStatus == "additionalInfo" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleaseUpdateYourAdditionalPersonalInfo, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.updateAdditionalInfo, comment: ""), for: .normal)
        } else if isStatus == "paid" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pleaseCompletePaymentProcessYouhaventCompleteItBefore, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pay, comment: ""), for: .normal)
        } else if isStatus == "support" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourCardIsWaingForActivation, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contactSupport, comment: ""), for: .normal)
        } else if isStatus == "inProgress" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youCardIsInProgressAreYouSureyouWantoCancelCardOrder, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contactSupport, comment: ""), for: .normal)
        } else if isStatus == "kycForbiddenCountry" {
            lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.kycForbiddenCountryMsg, comment: "")
            btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.contactSupport, comment: ""), for: .normal)
        }
//        "additionalStatuses" : [ "ADDRESS", "PAID", "KYC", "TAXID", "ADDITIONAL_PERSONAL_INFO", "CARDHOLDER_NAME" ],

        // Do any additional setup after loading the view.
    }
    @IBAction func btnSubmitAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: false) {
            if self.isStatus == "Kyc" {
                self.delegate?.goToNextScreen(isStatus: "Kyc")
            } else if self.isStatus == "addresss" {
                self.delegate?.goToNextScreen(isStatus: "addresss")
            } else if self.isStatus == "additionalInfo" {
                self.delegate?.goToNextScreen(isStatus: "additionalInfo")
            } else if self.isStatus == "paid" {
                self.delegate?.goToNextScreen(isStatus: "paid")
            } else if self.isStatus == "support" {
                self.delegate?.goToNextScreen(isStatus: "support")
            } else if self.isStatus == "inProgress" {
                self.delegate?.goToNextScreen(isStatus: "inProgress")
            }
        }
       
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.cancelCardRequestsAPINew(cardRequestId: "\(self.cardRequestId)") { resStatus, resMsg ,dataValue in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
//                self.showToast(message: "OK", font: AppFont.regular(15).value)
                self.dismiss(animated: false) {
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
                    self.delegate?.refreshCards()
                
                }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.error, comment: ""), font: AppFont.regular(15).value)
            }
        }
     
    }
    
}
