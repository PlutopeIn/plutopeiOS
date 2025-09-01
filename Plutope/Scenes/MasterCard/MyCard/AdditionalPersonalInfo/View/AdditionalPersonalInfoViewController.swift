//
//  AdditionalPersonalInfoViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/06/24.
//

import UIKit
import Combine
class AdditionalPersonalInfoViewController: UIViewController {
    
    @IBOutlet weak var lblCountryTitle: UILabel!
    @IBOutlet weak var viewYes: UIView!
    @IBOutlet weak var viewNo: UIView!
    @IBOutlet weak var lblIsUsaTitle: UILabel!
    
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var txtCountry: customTextField!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var txtTaxId: customTextField!
    @IBOutlet weak var lblTaxId: UILabel!
    @IBOutlet weak var ivInfo: UIImageView!
    @IBOutlet weak var btnSunbmit: GradientButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnBack: UIImageView!
    var isFrom = ""
    var cardRequestId : Int?
    var countryCode = ""
    var isUsRelated : Bool?
    var usRelated = String()
    var cardType = ""
    var address = ""
    var isNoChecked: Bool = false
    var isYesChecked: Bool = false
    var additionalStatuses:[String] = []
    //    var arrAdditionalInfoList : GetAdditionalInfoList?
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    private var viewModel = CountryCodeViewModel()
    private var cancellables = Set<AnyCancellable>()
    var countryData: [Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.additionalPersonalInfo, comment: ""), btnBackHidden: true)
        
        viewModel.getCountryCode()
        viewModel.$countries
            .sink { [weak self] countries in
                // Handle the updated countries data here
                self?.countryData = countries
                //                if self?.server == .live {
                self?.getPersionalInfo()
                //                } else {
                //                    self?.getProfileData()
                //                }
                
                //                print(countries)
            }
            .store(in: &cancellables)
        
        txtCountry.isUserInteractionEnabled = true
        
        // Add a tap gesture recognizer to the text field
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap1))
        txtCountry.addGestureRecognizer(tapGesture1)
        /// Agreement view tap action
        lblCountry.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.taxCountry, comment: "")
        lblTaxId.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.taxID, comment: "")
        lblIsUsaTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.isUsCountry, comment: "")
        btnYes.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yes, comment: ""), for: .normal)
        btnNo.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.no, comment: ""), for: .normal)
        btnSunbmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.goToPayment, comment: ""), for: .normal)
        
        btnBack.addTapGesture {
            HapticFeedback.generate(.light)
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is CardDashBoardViewController {
                        navigationController.popToViewController(viewController, animated: true)
                        
                    }
                }
            }
        }
    }
    func getPersionalInfo() {
        myCardViewModel.apiGetAdditionalPersonalInfoNew { status,msg, data in
            if status == 1 {
                DispatchQueue.main.async {
                    let targetCode = data?.taxCountry
                    if let country = self.countryData.first(where: { $0.code == targetCode }) {
                        if let countryName = country.name {
                            self.txtCountry.text = countryName
                        } else {
                        }
                    } else {
                    }
                    self.txtTaxId.text = data?.taxID ?? ""
                    if data?.usRelated == true {
                        self.btnYes.setImage(UIImage.check.sd_tintedImage(with: UIColor.label), for: .normal)
                        self.btnNo.setImage(UIImage.uncheck.sd_tintedImage(with: UIColor.label), for: .normal)
                        self.isUsRelated = true
                        self.usRelated = "yes"
                    } else {
                        self.btnYes.setImage(UIImage.uncheck.sd_tintedImage(with: UIColor.label), for: .normal)
                        self.btnNo.setImage(UIImage.check.sd_tintedImage(with: UIColor.label), for: .normal)
                        self.isUsRelated = false
                        self.usRelated = "no"
                    }
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.txtCountry.text = ""
                    self.txtTaxId.text = ""
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtCountry.textAlignment = .right
            txtTaxId.textAlignment = .right
            
        } else {
            txtCountry.textAlignment = .left
            txtTaxId.textAlignment = .left
            
        }
    }
    @IBAction func btnYesAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.btnYes.isSelected = true
        self.btnNo.isSelected = false
        isUsRelated = true
        usRelated = "yes"
        btnYes.setImage(UIImage.check.sd_tintedImage(with: UIColor.label), for: .normal)
        btnNo.setImage(UIImage.uncheck.sd_tintedImage(with: UIColor.label), for: .normal)
        
    }
    
    @IBAction func btnNoAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.btnNo.isSelected = true
        self.btnYes.isSelected = false
        isUsRelated = false
        usRelated = "no"
        btnNo.setImage(UIImage.check.sd_tintedImage(with: UIColor.label), for: .normal)
        btnYes.setImage(UIImage.uncheck.sd_tintedImage(with: UIColor.label), for: .normal)
        
    }
    internal func alltextFieldsValid() -> Bool {
        
        guard let countryText = self.txtCountry.text?.trimingChar(), !countryText.isEmpty else {
            self.showSimpleAlert(Message: ToastMessages.emptyCountry)
            return false
        }
        guard let taxIdText = self.txtTaxId.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !taxIdText.isEmpty || taxIdText.count >= 4 else {
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.taxInfoValid1, comment: ""))
            return false
        }
        guard usRelated != "" else {
            self.showSimpleAlert(Message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.taxInfoValid2, comment: ""))
            return false
        }
        return true
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        if alltextFieldsValid() {
            DGProgressView.shared.showLoader(to: view)
            
            myCardViewModel.additionalPersonalInfoAPINew(taxId: txtTaxId.text ?? "", isUsRelated: self.isUsRelated ?? false, taxCountry: self.countryCode) { resStatus, resMsg, dataValue in
                if resStatus == 1 {
                    DGProgressView.shared.hideLoader()
                    let cardPaymentVC = CardPaymentViewControllerNew()
                    cardPaymentVC.cardRequestId = self.cardRequestId ?? 0
                    cardPaymentVC.cardType = self.cardType
                    cardPaymentVC.address = self.address
                    cardPaymentVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(cardPaymentVC, animated: true)
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMsg, font: AppFont.regular(15).value)
                }
            }
        } else {
            
        }
    }
    
    @objc func handleTextFieldTap1() {
        // Present the new view controller
        HapticFeedback.generate(.light)
        let popUpVc = CountryPopUpViewController()
        popUpVc.modalTransitionStyle = .crossDissolve
        popUpVc.modalPresentationStyle = .overFullScreen
        popUpVc.isFrom = "additionalInfo"
        popUpVc.isCountry = true
        popUpVc.delegate = self
        present(popUpVc, animated: true, completion: nil)
    }
}
extension AdditionalPersonalInfoViewController: SelectedCountryDelegate {
    func getSelectedCountry(name: String, code: String, dialCode: String, flag: String, isCountry: Bool?) {
        DispatchQueue.main.async {
            self.countryCode = code
            self.txtCountry.text = name
            
        }
    }
    
}
