//
//  CardUsersProfileViewController+LiveUrl.swift
//  Plutope
//
//  Created by Trupti Mistry on 15/07/24.
//

import UIKit
import DGNetworkingServices
extension CardUsersProfileViewController {
    func getKycStatusNew() {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.kycStatusAPINew { status,msg ,data in
            DispatchQueue.main.async {
            
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.kyclevel = data?.kycLevel ?? ""
                self.kycStatus = data?.kyc1ClientData?.status ?? ""
//                self.lblLimitTitle.text = "Verification level 1"
                if let price2 = data?.remainingAmount?.value {
                    let price2Value: Double = {
                        switch price2 {
                        case .int(let value):
                            return Double(value)
                        case .double(let value):
                            return value
                        }
                    }()
                    self.lblFlatLimit.text = "\(price2Value) \(data?.remainingAmount?.currency ?? "")"
                    UserDefaults.standard.set("\(price2Value) \(data?.remainingAmount?.currency ?? "")", forKey: fiateValue)
                } else {
                    self.lblFlatLimit.text = "0"
                }
               
                if self.kycStatus == "APPROVED" {
                    self.lblLimitTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxLimit, comment: "")
                    self.btnIncrease.isHidden = true
                    self.ivDone.isHidden = false
                    self.lblLimitMsg.isHidden = true
                    self.lblWaringMsg.isHidden = true
                    // self.kycStatus2 = data?.kyc2ClientData?.status ?? ""
                    
                    //                    if self.kycStatus2 == "APPROVED" {
                    //                        self.btnIncrease.isHidden = true
                    //                        self.lblLimitMsg.text = "KYC APPROVED".capitalizingFirstLetter()
                    //                        self.lblWaringMsg.isHidden = true
                    //                    } else if self.kycStatus2 == "DENIED" {
                    //                        self.btnIncrease.isEnabled = true
                    //                        self.lblLimitMsg.text = "Action needed"
                    //                        self.lblWaringMsg.isHidden = false
                    //                        self.btnIncrease.setTitle("Resubmit", for: .normal)
                    //                    } else if self.kycStatus2 == "UNDEFINED" {
                    //                        self.btnIncrease.isHidden = false
                    //                        self.lblLimitTitle.text = "Verification level 2"
                    //                        self.lblLimitMsg.text = "Limits"
                    //                        self.lblWaringMsg.isHidden = false
                    //                        self.lblWaringMsg.text = "Level up your verification to add \(self.kycLevel1Limit) to fiat limit"
                    //                        self.btnIncrease.setTitle("Increase", for: .normal)
                    //                    } else {
                    //                        self.lblLimitMsg.text = "Under review"
                    //                        self.lblWaringMsg.isHidden = false
                    //                        self.btnIncrease.isHidden = true
                    //                        self.lblWaringMsg.text = "Verification process shouldn't take more than 30 minutes"
                    //                        self.btnIncrease.setTitle("Increase", for: .normal)
                    //                    }
                    
                } else if self.kycStatus == "DENIED" {
                    self.lblLimitTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.verificationLevel1, comment: "")
                    self.ivDone.isHidden = true
                    self.lblLimitMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.actionNeeded, comment: "")
                    self.lblWaringMsg.isHidden = false
                    self.btnIncrease.isHidden = false
                    self.btnIncrease.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.resubmit, comment: ""), for: .normal)
                } else if self.kycStatus == "UNDEFINED" {
                    self.lblLimitTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.verificationLevel1, comment: "")
                    self.btnIncrease.isHidden = false
                    self.ivDone.isHidden = true
                    self.lblLimitMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.limits, comment: "")
                    self.lblWaringMsg.isHidden = false
//                    self.lblWaringMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.level1Msg1, comment: "")
                    // Fetch the localized string with format specifier
                            let localizedString = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.level1Msg1, comment: "")
                            print("Localized string: \(localizedString)")  // Debugging line
                            
                            // Format the string with the dynamic value
                    let formattedString = String(format: localizedString, self.kycLevel1Limit)
                            
                            // Debugging output
                            print("Formatted string: \(formattedString)")
                    self.lblWaringMsg.text = formattedString
                    self.btnIncrease.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.increase, comment: ""), for: .normal)
                } else if self.kycStatus == "UNDER_REVIEW" {
                    self.lblLimitTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.verificationLevel1, comment: "")
                    self.ivDone.isHidden = true
                    self.lblLimitMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.underReview, comment: "")
                    self.lblWaringMsg.isHidden = false
                    self.btnIncrease.isHidden = true
                    self.lblWaringMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.level1Msg2, comment: "")
                    self.btnIncrease.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.increase, comment: ""), for: .normal)
                }
                
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
        }
    }
    func getKycLimitNew() {
        kycViewModel.apiGetKycLimitNew { status,msg, data in
            if status == 1 {
                // Safely unwrap the optional dictionary
                if let kycLimits = data {
                    // Access specific values
                    if let kyc0Limit = kycLimits["kyc1Limit"] {
                        if let value = kyc0Limit.value, let currency = kyc0Limit.currency {
                            print("kyc0Limit - Value: \(value), Currency: \(currency)")
                           // DispatchQueue.main.async {
                                self.kycLevel1Limit = "\(value) \(currency)"

                           // }
                        } else {
                            print("kyc0Limit has missing value or currency")
                        }
                    } else {
                        print("No kyc0Limit found")
                    }
                }
                
            } else {
                print("error in kycLimit")
            }
        }
    }
     func userLogoutNew() {

        DGProgressView.shared.showLoader(to: view)
        signInViewModel.apiSignoutNew(isfromRegister: true) { resStatus, message, dataValue in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                UserDefaults.standard.removeObject(forKey: loginApiToken)
                UserDefaults.standard.removeObject(forKey: loginPhoneNumber)
                UserDefaults.standard.removeObject(forKey: loginPassword)
                UserDefaults.standard.removeObject(forKey: loginApiRefreshToken)
                UserDefaults.standard.removeObject(forKey: cardHolderfullName)
                UserDefaults.standard.removeObject(forKey: cryptoCardNumber)
                UserDefaults.standard.removeObject(forKey: mainPublicKey)
                UserDefaults.standard.removeObject(forKey: mainPrivetKey)
                UserDefaults.standard.removeObject(forKey: loginApiTokenExpirey)
                UserDefaults.standard.removeObject(forKey: cardTypes)
                UserDefaults.standard.removeObject(forKey: fiateValue)
                UserDefaults.standard.removeObject(forKey: cardCurrency)
                UserDefaults.standard.removeObject(forKey: serverType)
           
                if let navigationController = self.navigationController {
                    for viewController in navigationController.viewControllers {
                        print("viewController",viewController)
                        if viewController is CardHomeViewController {
                            navigationController.popToViewController(viewController, animated: true)
                            break
                        }
                    }
                }
                
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: message, font: AppFont.regular(15).value)
                UserDefaults.standard.removeObject(forKey: loginApiToken)
                UserDefaults.standard.removeObject(forKey: loginPhoneNumber)
                UserDefaults.standard.removeObject(forKey: loginPassword)
                UserDefaults.standard.removeObject(forKey: cryptoCardNumber)
                if let navigationController = self.navigationController {
                    for viewController in navigationController.viewControllers {
                        print("viewController",viewController)
                        if viewController is CardHomeViewController {
                            navigationController.popToViewController(viewController, animated: true)
                            
                        }
                    }
                }
            }
        }
    }
}
