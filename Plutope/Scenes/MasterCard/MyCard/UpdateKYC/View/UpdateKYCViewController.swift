//
//  UpdateKYCViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import UIKit
//import OndatoSDK
import IdensicMobileSDK
class UpdateKYCViewController: UIViewController {

    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblSelfiInfo: UILabel!
    @IBOutlet weak var lblSnapItInfo: UILabel!
    @IBOutlet weak var lblPicDocumentInfo: UILabel!
    @IBOutlet weak var lblPicDocument: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblSnapIt: UILabel!
    @IBOutlet weak var btnStartKyc:GradientButton!
    @IBOutlet weak var lblSelfi: UILabel!
    var id = ""
    var kycStatus = ""
    lazy var viewModel: UpdateKYCViewModel = {
        UpdateKYCViewModel { _ ,_ in
        }
    }()
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
     var sdk: SNSMobileSDK!
    // Define a closure property that acts as a callback
   
    fileprivate func uiSetUp() {
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.kycInfo, comment: "")
        lblSelfi.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selfie, comment: "")
        
        lblSelfiInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selfieMsg, comment: "")
        lblSnapIt.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.snapIt, comment: "")
        lblSnapItInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.snapItMsg, comment: "")
        lblPicDocument.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.picDocument, comment: "")
        lblPicDocumentInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.picDocumentMsg, comment: "")
        btnStartKyc.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.statVarification, comment: ""), for: .normal)
        lblSelfi.font = AppFont.violetRegular(20).value
        lblSnapIt.font = AppFont.violetRegular(20).value
        lblPicDocument.font = AppFont.violetRegular(20).value
        lblPicDocumentInfo.font = AppFont.regular(15).value
        lblSelfiInfo.font = AppFont.regular(15).value
        lblSnapItInfo.font = AppFont.regular(15).value
        lblMsg.font = AppFont.regular(12).value
        btnStartKyc.titleLabel?.font = AppFont.violetRegular(18).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.verifyId, comment: ""), btnBackHidden: false)
        // uisetup
        uiSetUp()
        
    }
    func getKycStatus() {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.kycStatusAPINew { status, msg,data  in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.kycStatus = data?.kyc1ClientData?.status ?? ""
                 if self.kycStatus == "APPROVED" {
                    //self.showSimpleAlert(Message: "Your KYC is APPROVED")
//                     if let navigationController = self.navigationController {
//                         for viewController in navigationController.viewControllers {
//                             if viewController is CardDashBoardViewController {
//                                 NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
//                                 navigationController.popToViewController(viewController, animated: true)
//                                 break
//                                
//                             }
//                         }
//                     }
                } else {
                    self.startKycSumSub()
                }
             
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Server Error", font: AppFont.regular(15).value)
            }
        }
    }
    @IBAction func btnStartKycAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        getKycStatus()
    }
//    func startKyc() {
//        self.viewModel.startKYCAPI { resStatus, resData in
//            if resStatus == 1 {
//               
//                self.id = resData?["id"] as? String ?? ""
//                DispatchQueue.main.async {
//                    Ondato.sdk.setIdentityVerificationId(self.id)
//                    
//                    let serverTypes = UserDefaults.standard.value(forKey: serverType) as? String ?? ""
//                    print("serverType=>",serverType)
//                   // if serverTypes == "LIVE" {
//                        Ondato.sdk.configuration.mode = OndatoEnvironment.live
////                    } else {
////                        Ondato.sdk.configuration.mode = OndatoEnvironment.test
////                    }
//                    
//                    Ondato.sdk.delegate = self
//                    let viewController = Ondato.sdk.instantiateOndatoViewController()
//                    viewController.modalPresentationStyle = .fullScreen
//                    self.present(viewController, animated: true, completion: nil)
//                }
//            } else {
//                print("error")
//            }
//        }
//    }
    func startKycSumSub() {
        self.viewModel.apiStartKYCSumSub { resStatus, resData in
            if resStatus == 1 {
                DispatchQueue.main.async {
                    self.sdk = SNSMobileSDK(
                        accessToken:resData?.token ?? ""
                    )
                    guard self.sdk.isReady else {
                        print("Initialization failed: " + self.sdk.verboseStatus)
                        return
                    }
                    self.present(self.sdk.mainVC, animated: true, completion: nil)
                }
            } else {
                print("error")
            }
        }
    }
     func setupHandlers() {
        // MARK: verificationHandler
         self.sdk.verificationHandler { (isApproved) in
            print("verificationHandler: Applicant is " + (isApproved ? "approved" : "finally rejected"))
        }
        // MARK: dismissHandler
         self.sdk.dismissHandler { (sdk, mainVC) in
            mainVC.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        // MARK: actionResultHandler
         self.sdk.actionResultHandler { (sdk, result, onComplete) in
            
            print("Face Auth action result handler: actionId=\(result.actionId) answer=\(result.answer ?? "<none>")")
            onComplete(.continue)
        }
    }
    // swiftlint:disable cyclomatic_complexity
     func setupCallbacks() {
         self.sdk.onStatusDidChange { (sdk, prevStatus) in
                        
            let prevStatusDesc = sdk.description(for: prevStatus)
            let lastStatusDesc = sdk.description(for: sdk.status)
            let failReasonDesc = sdk.description(for: sdk.failReason)
            let description: String
            
            switch sdk.status {
            case .ready:
                description = "Ready to be presented"
            case .failed:
                description = "failReason: [\(failReasonDesc)] \(sdk.verboseStatus)"
            case .initial:
                description = "No verification steps are passed yet"
            case .incomplete:
                description = "Some but not all of the verification steps have been passed over"
            case .pending:
                description = "Verification is pending"
            case .temporarilyDeclined:
                description = "Applicant has been declined temporarily"
            case .finallyRejected:
                description = "Applicant has been finally rejected"
            case .approved:
                description = "Applicant has been approved"
            case .actionCompleted:
                description = "Face Auth action has been completed (see `sdk.actionResult` for details"
            }
            
            print("onStatusDidChange: [\(prevStatusDesc)] -> [\(lastStatusDesc)] \(description)")
        }
        
        // MARK: onEvent
         self.sdk.onEvent { (sdk, event) in
            switch event.eventType {
            case .applicantLoaded:
                if let event = event as? SNSEventApplicantLoaded {
                    print("onEvent: Applicant [\(event.applicantId)] has been loaded")
                }
            case .stepInitiated:
                if let event = event as? SNSEventStepInitiated {
                    print("onEvent: Step [\(event.idDocSetType)] has been initiated")
                }
            case .stepCompleted:
                if let event = event as? SNSEventStepCompleted {
                    print("onEvent: Step [\(event.idDocSetType)] has been \(event.isCancelled ? "cancelled" : "fulfilled")")
                }
            case .analytics:
                // Uncomment to see the details
                // if let event = event as? SNSEventAnalytics {
                //     log("onEvent: Analytics event [\(event.eventName)] has occured with payload=\(event.eventPayload ?? [:])")
                // }
                break
            @unknown default:
                print("onEvent: eventType=[\(event.description(for: event.eventType))] payload=\(event.payload)")
            }
            
        }

        // MARK: onDidDismiss : A way to be notified when `mainVC` is dismissed
         self.sdk.onDidDismiss { (sdk) in

            let lastStatusDesc = sdk.description(for: sdk.status)
            let failReasonDesc = sdk.description(for: sdk.failReason)
            
            var description: String
            
            switch sdk.status {
            case .actionCompleted:
                if let result = sdk.actionResult {
                    description = "Face Auth action result: actionId=\(result.actionId) answer=\(result.answer ?? "<none>")"
                } else {
                    description = "Face Auth action was cancelled"
                }
                    
            default:
                description = "Identity verification status is "
                if sdk.isFailed {
                    description += "[\(lastStatusDesc):\(failReasonDesc)] \(sdk.verboseStatus)"
                } else {
                    description += "[\(lastStatusDesc)]"
                }
            }
            
             print("onDidDismiss: \(description)")
            
             self.showToast(message: description, font: AppFont.regular(14).value)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    func finishKyc(identificationId:String) {
        self.viewModel.finishKYCAPI(identificationId: self.id) { resStatus, resData in
            if resStatus == 1 {
                DispatchQueue.main.async {
                    self.showToast(message: "\(identificationId) OK", font: AppFont.regular(15).value)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showToast(message: "\(identificationId) Error", font: AppFont.regular(15).value)
                }
            }
        }
    }
}
//extension UpdateKYCViewController: OndatoFlowDelegate {
//    func flowDidFail(identificationId: String?, error: OndatoServiceError) {
//        self.showSimpleAlert(Message: "Failure \(identificationId ?? "") reason: \(error)")
//        print("Failure \(identificationId ?? "") reason: \(error)")
//    }
//    
//    func flowDidSucceed(identificationId: String?) {
//        print("Success \(identificationId ?? "")")
//        self.showSimpleAlert(Message: "Success \(identificationId ?? "")")
//        self.finishKyc(identificationId: identificationId ?? "")
//    }
//}
