//
//  CardUserProfileDetailsViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/05/24.
//

import UIKit
import Combine
import MessageUI
class CardUserProfileDetailsViewController: UIViewController {

    @IBOutlet weak var btnDeleteAccount: UIButton!
    @IBOutlet weak var lblPhonenumberTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblFirstNameTitle: UILabel!
    @IBOutlet weak var lblLastNameTitle: UILabel!
    @IBOutlet weak var lblDOBTitle: UILabel!
    @IBOutlet weak var lblCountryTitle: UILabel!
    @IBOutlet weak var lblCityTitle: UILabel!
    @IBOutlet weak var lblStreetTitle: UILabel!
    @IBOutlet weak var lblZipTitle: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblFirstName: UILabel!
    
    @IBOutlet weak var lblLastName: UILabel!

    @IBOutlet weak var lblDOB: UILabel!
    
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
   
    @IBOutlet weak var lblStreet: UILabel!
   
    @IBOutlet weak var lblZip: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmailResend: UILabel!
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var btnUpdate: GradientButton!
    var arrProfileList : CardUserDataList?
    let server = serverTypes

    lazy var cardUserProfileViewModel: CardUserProfileViewModel = {
        CardUserProfileViewModel { _ ,message in
        }
    }()
    lazy var cardUserViewModel: CardUserViewModel = {
        CardUserViewModel { _ ,message in
        }
    }()
    private var viewModel = CountryCodeViewModel()
    var countryData: [Country] = []
    fileprivate func uiSetup() {
        lblEmailTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.email, comment: "")
        lblPhonenumberTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.phoneNumber1, comment: "")
        lblFirstNameTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.firstName, comment: "")
        lblLastNameTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lastName, comment: "")
        lblDOBTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.dob, comment: "")
        lblCountryTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.country, comment: "")
        lblCityTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.city1, comment: "")
        lblStreetTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.street, comment: "")
        lblZipTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.zipCode, comment: "")
        btnUpdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.edit, comment: ""), for: .normal)
        btnDeleteAccount.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.deleteAccount, comment: ""), for: .normal)
        // Call the setAttributedText function
        setAttributedClicableText(labelName: lblEmailResend, labelText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.emailResendMsg, comment: ""), value: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.clickHere, comment: ""), color: UIColor.secondaryLabel)
        
        lblEmail.font = AppFont.regular(15).value
        lblEmailTitle.font = AppFont.violetRegular(15).value
        lblEmailResend.font = AppFont.regular(12).value
        lblPhone.font = AppFont.regular(15).value
        lblPhonenumberTitle.font = AppFont.violetRegular(15).value
        lblFirstName.font = AppFont.regular(15).value
        lblLastName.font = AppFont.regular(15).value
        lblDOB.font = AppFont.regular(15).value
        lblCountry.font = AppFont.regular(15).value
        lblCity.font = AppFont.regular(15).value
        lblStreet.font = AppFont.regular(15).value
        lblZip.font = AppFont.regular(15).value
        lblFirstNameTitle.font = AppFont.violetRegular(15).value
        lblLastNameTitle.font = AppFont.violetRegular(15).value
        lblDOBTitle.font = AppFont.violetRegular(15).value
        lblCountryTitle.font = AppFont.violetRegular(15).value
        lblCityTitle.font = AppFont.violetRegular(15).value
        lblStreetTitle.font = AppFont.violetRegular(15).value
        lblZipTitle.font = AppFont.violetRegular(15).value
        btnUpdate.titleLabel?.font = AppFont.violetRegular(17).value
        btnDeleteAccount.titleLabel?.font = AppFont.violetRegular(17).value
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.profile, comment: ""), btnBackHidden: false)
          
        uiSetup()
        // Set up tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
//        lblEmailResend.addGestureRecognizer(tapGesture)
        lblEmailResend.addTapGesture {
            HapticFeedback.generate(.light)
            DGProgressView.shared.showLoader(to: self.view)

            self.cardUserViewModel.apiMobileEmailVerifyResendNew { resStatus, message in
                if resStatus == 1 {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendEmailSuccess, comment: ""), font: AppFont.regular(15).value)
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: message, font: AppFont.regular(15).value)
                }
            }
        }
        /// fetch the country codes
        viewModel.getCountryCode()
        viewModel.$countries
            .sink { [weak self] countries in
                // Handle the updated countries data here
                self?.countryData = countries
//                if self?.server == .live {
                    self?.getProfileDataNew()
//                } else {
//                    self?.getProfileData()
//                }
                
//                print(countries)
            }
            .store(in: &cancellables)
       
    }
    @objc func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
            guard let label = gesture.view as? UILabel else { return }
            let text = label.attributedText?.string ?? ""
            let range = (text as NSString).range(of: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.resendIt, comment: ""))
            
            let locationOfTouchInLabel = gesture.location(in: label)
            let textBoundingBox = label.textRect(forBounds: label.bounds, limitedToNumberOfLines: label.numberOfLines)
            let textContainerOffset = CGPoint(
                x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
            )
            let locationOfTouchInTextContainer = CGPoint(
                x: locationOfTouchInLabel.x - textContainerOffset.x,
                y: locationOfTouchInLabel.y - textContainerOffset.y
            )
            
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: CGSize(width: label.bounds.size.width, height: label.bounds.size.height + 100))
            let textStorage = NSTextStorage(attributedString: label.attributedText!)
            
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            
            textContainer.lineFragmentPadding = 0.0
            textContainer.lineBreakMode = label.lineBreakMode
            textContainer.maximumNumberOfLines = label.numberOfLines
            let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            if NSLocationInRange(indexOfCharacter, range) {
                // Handle the tap on the clickable text (partTwo)
                print("Clickable text tapped!")
                DGProgressView.shared.showLoader(to: view)

                cardUserViewModel.apiMobileEmailVerifyResendNew { resStatus, message in
                    if resStatus == 1 {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendEmailSuccess, comment: ""), font: AppFont.regular(15).value)
                    } else {
                        DGProgressView.shared.hideLoader()
                        self.showToast(message: message, font: AppFont.regular(15).value)
                    }
                }
            }
        }
    func getProfileData() {
        DGProgressView.shared.showLoader(to: view)
        cardUserProfileViewModel.getProfileAPINew { status,msg, data in
            if status == 1 {
                self.arrProfileList = data
                    DGProgressView.shared.hideLoader()
                    self.lblEmail.text = self.arrProfileList?.email ?? ""
                    self.lblPhone.text = self.arrProfileList?.phone ?? ""
                    self.lblFirstName.text = self.arrProfileList?.firstName ?? ""
                    self.lblLastName.text = self.arrProfileList?.lastName ?? ""
                if self.arrProfileList?.confirmedEmail == false {
                    self.lblEmailResend.isHidden = false
                } else {
                    self.lblEmailResend.isHidden = true
                }
//                    self.lblCountry.text =  ?? ""
                let targetCode = self.arrProfileList?.residenceCountry
                if let country = self.countryData.first(where: { $0.code == targetCode }) {
                    if let countryName = country.name {
                        print("Country name: \(countryName)")
                        self.lblCountry.text = countryName
                    } else {
                        print("Country name not found")
                    }
                } else {
                    print("Country with code \(targetCode ?? "") not found")
                }
                
                    self.lblStreet.text = self.arrProfileList?.residenceStreet ?? ""
                    self.lblCity.text = self.arrProfileList?.residenceCity ?? ""
                    self.lblZip.text = self.arrProfileList?.residenceZipCode ?? ""
                let dob = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy", timeZone: nil).0
                  self.lblDOB.text = dob ?? ""
                
            } else {
                DGProgressView.shared.hideLoader()
//                self.showToast(message: "No Data", font: AppFont.regular(15).value)
            }
        }
    }
    func getProfileDataNew() {
        DGProgressView.shared.showLoader(to: view)
        cardUserProfileViewModel.getProfileAPINew { status, msg,data in
            if status == 1 {
                self.arrProfileList = data
                    DGProgressView.shared.hideLoader()
                    self.lblEmail.text = self.arrProfileList?.email ?? ""
                    self.lblPhone.text = self.arrProfileList?.phone ?? ""
                    self.lblFirstName.text = self.arrProfileList?.firstName ?? ""
                    self.lblLastName.text = self.arrProfileList?.lastName ?? ""
                if self.arrProfileList?.confirmedEmail == false {
                    self.lblEmailResend.isHidden = false
                } else {
                    self.lblEmailResend.isHidden = true
                }
//                    self.lblCountry.text =  ?? ""
                let targetCode = self.arrProfileList?.residenceCountry
                if let country = self.countryData.first(where: { $0.code == targetCode }) {
                    if let countryName = country.name {
                        print("Country name: \(countryName)")
                        self.lblCountry.text = countryName
                    } else {
                        print("Country name not found")
                    }
                } else {
                    print("Country with code \(targetCode) not found")
                }
                
                    self.lblStreet.text = self.arrProfileList?.residenceStreet ?? ""
                    self.lblCity.text = self.arrProfileList?.residenceCity ?? ""
                    self.lblZip.text = self.arrProfileList?.residenceZipCode ?? ""
                let dob = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy", timeZone: nil).0
                  self.lblDOB.text = dob ?? ""
                
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    @IBAction func btnUpdateAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let updateProfileVC = CardUserProfileViewController()
        updateProfileVC.isFromDetails = true
        updateProfileVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(updateProfileVC, animated: true)
    }
    
    @IBAction func btnDeleteAccountAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.deleteAccount, comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.deleteAccountMsg, comment: ""),  preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            self.sendEmail()
        }))
        alert.addAction(UIAlertAction(title: "CANCLE", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    func sendEmail() {
            // Check if the device is configured to send emails
            guard MFMailComposeViewController.canSendMail() else {
                // Show alert or message to the user
                let alert = UIAlertController(title: "Error", message: "This device is not configured to send emails.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }

            // Create the mail composer view controller
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            // Set the recipient email address
            mailComposeVC.setToRecipients(["hey@plutope.io"])
            
            // Set the email subject
            mailComposeVC.setSubject("Close Plutope Card account")
            
            // Set the email message body
            let messageBody = """
        Hi,

        If you want to close your Plutope Card account, please specify in the message (the comment is required):

        * The phone number linked to the account,
        * The reason for deletion.

        Please note that having an account does not cost anything, so you can use it whenever you need it.

        Thank you.
        """
            mailComposeVC.setMessageBody(messageBody, isHTML: false)
            
            // Present the mail composer
            present(mailComposeVC, animated: true, completion: nil)
        }
}
extension CardUserProfileDetailsViewController {
    func setAttributedClicableText(labelName: UILabel, labelText: String, value: String, color: UIColor) {
        // Enable user interaction for the label
        labelName.isUserInteractionEnabled = true
        
        let commonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: AppFont.regular(12).value
        ]
        
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: AppFont.regular(12).value,
            .link: URL(string: "action://valueTapped")! // Custom URL scheme
        ]
        
        let partOne = NSMutableAttributedString(string: labelText, attributes: commonAttributes)
        let partTwo = NSMutableAttributedString(string: value, attributes: yourOtherAttributes)
        labelName.tintColor = UIColor.c2B5AF3
        partOne.append(partTwo)
        labelName.attributedText = partOne
        
        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        labelName.addGestureRecognizer(tapGesture)
        
    }

}
// MARK: - MFMailComposeViewControllerDelegate
extension CardUserProfileDetailsViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
            
            // Handle the result of the email composition (optional)
            switch result {
            case .cancelled:
                print("Email cancelled")
            case .saved:
                print("Email saved as draft")
            case .sent:
                print("Email sent successfully")
            case .failed:
                print("Failed to send email: \(error?.localizedDescription ?? "Unknown error")")
            @unknown default:
                break
            }
        }
}
