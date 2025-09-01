//
//  CardDashBoardViewController+LiveApis.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/07/24.
//

import UIKit
extension CardDashBoardViewController {
    func getCardNew(completion: @escaping () -> Void) {
        if !isRefesh {
//            DGProgressView.shared.showLoader(to: view)
            clvSlider.showLoader()
        }

        myCardViewModel.getCardAPINew { status, msg, data in
            DispatchQueue.main.async {
                if status == 1 {
                    self.arrCardList = data ?? []
                    self.snakePageControl.isHidden = self.arrCardList.count <= 1
                    self.snakePageControl.pageCount = self.arrCardList.count
                    self.orderCardView.isHidden = true
                    if self.arrCardList.isEmpty {
                        self.orderCardView.isHidden = false
                        self.viewSlider.isHidden = true
                        self.getKycStatusNew()
                        self.lblCardCount.text = "0"
                        self.tbvDashboard.isHidden = true
                        self.lblBalance.text = ""
                        self.viewAddNewProduct.isHidden = true
                    } else {
                        self.lblCardCount.text = "\(self.arrCardList.count)"
                        self.tbvDashboard.isHidden = false
                        self.orderCardView.isHidden = true
                        self.viewSlider.isHidden = false
                        self.viewAddNewProduct.isHidden = true
                        self.tbvDashboard.reloadData()
                        self.tbvDashboard.restore()
                        self.clvSlider.reloadData()
                        self.clvSlider.restore()
                    }
                } else {
                    self.viewSlider.isHidden = true
                    self.tbvDashboard.isHidden = true
                    self.stackCard.isHidden = true
                    if msg == "You are not authorised for this request." || msg == "invalid_token"
                    {
                        self.logOut()
                    } else {
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                }
                self.clvSlider.hideLoader()
                self.tbvWallet.hideLoader()
                completion() // Notify DispatchGroup that this API call is done
            }
        }
    }

    func getKycStatusNew() {
      //  DGProgressView.shared.showLoader(to: view)
        self.orderCardView.isHidden = true
        myTokenViewModel.kycStatusAPINew { status, msg,data in
            if status == 1 {
               // DGProgressView.shared.hideLoader()
                self.kycStatus = data?.kyc1ClientData?.status ?? ""
                if self.kycStatus == "APPROVED" {
                    self.orderCardView.isHidden = true
                } else {
                    self.orderCardView.isHidden = false
                }
                self.viewSlider.isHidden = true
            } else {
                self.orderCardView.isHidden = true
                self.viewSlider.isHidden = false
//                DGProgressView.shared.hideLoader()
                if msg == "You are not authorised for this request." || msg == "invalid_token" {
                    self.logOut()
                } else {
                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            }
        }
    }
    
    func logOut() {
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
                if viewController is CardHomeViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
    func getProfileDataNew(completion: @escaping () -> Void) {
        cardUserProfileViewModel.getProfileAPINew { status, msg,data in
            if status == 1 {
                self.arrProfileList = data
                DispatchQueue.main.async {
                    self.lblUserName.text = "\(self.arrProfileList?.firstName ?? "") \(self.arrProfileList?.lastName ?? "")"
                    UserDefaults.standard.set(self.lblUserName.text, forKey: cardHolderfullName)
                }
            } else {
                if msg == "You are not authorised for this request." || msg == "invalid_token"
                {
                    self.logOut()
                } else {
//                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            }
            completion()
        }
    }
    func getWalletTokensNew(completion: @escaping () -> Void) {
        myTokenViewModel.getTokenAPINew { status,data,fiat,msg in
            if status == 1 {
                self.arrWalletList = data ?? []
                self.arrFiatList = fiat
                if !self.arrWalletList.isEmpty {
                    DispatchQueue.main.async {
                        self.tbvWallet.isHidden = false
                        self.lblSeeAll.isHidden = false
                        self.stackToken.isHidden = false
                        self.lblWalletCount.text = "\(self.arrWalletList.count)"
                        if let rate = fiat?.amount {
                            let rateValue: Double = {
                                switch rate {
                                case .int(let value):
                                    return Double(value)
                                case .double(let value):
                                    return value
                                }
                            }()

                            self.totalBalanceValue = "\(rateValue) \(fiat?.customerCurrency ?? "")"
                            self.lblBalance.text = String(repeating: "*", count: self.totalBalanceValue.count)
                            let openEyeImage = UIImage.closeEye
                            let templateImage = openEyeImage.withRenderingMode(.alwaysTemplate)
                            self.btnShowBalance.setImage(templateImage, for: .normal)
                            self.btnShowBalance.tintColor = UIColor.white
                            
                        } else {
                            self.lblBalance.text = ""
                        }
                        if let change = fiat?.change {
                            let changeValue: Double = {
                                switch change {
                                case .int(let value):
                                    return Double(value)
                                case .double(let value):
                                    return value
                                }
                            }()
                            self.changeValues = "\(changeValue)"
                            
                        } else {
                            self.changeValues = "0"
                        }

                        if let changePercent = fiat?.changePercent {
                            let changePercentValue: Double = {
                                switch changePercent {
                                case .int(let value):
                                    return Double(value)
                                case .double(let value):
                                    return value
                                }
                            }()
                            self.changePercentage = "\(changePercentValue)"
                            
                        } else {
                            self.changePercentage = "0"
                        }
                        let positiveValue = "\(self.changeValues)".replacingOccurrences(of: "-", with: "")
                        
                        let changePercent = Double(self.changePercentage) ?? 0.0
                        let changeValue = Double(self.changeValues) ?? 0.0
  
                        self.lblChangeValue.text = "\(changePercent)%  • \(positiveValue) \(fiat?.customerCurrency ?? "")"
                        self.tbvWallet.reloadData()
                        self.tbvWallet.restore()
                    }
                    
                } else {
                    self.lblSeeAll.isHidden = true
                    self.tbvWallet.isHidden = true
                    self.stackToken.isHidden = true
                }
            } else {
                self.lblSeeAll.isHidden = true
                self.tbvWallet.isHidden = true
                self.stackToken.isHidden = true
                if  msg == "You are not authorised for this request." || msg == "invalid_token" {
                    self.logOut()
                } else {
//                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            }
            completion()
        }
    }
     func uiSetUp() {
         lblTotalBalance.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalBalance, comment: "")
         
//        lblSeeAll.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.seeAll, comment: "")
         
         let text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.seeAll, comment: "")
         let attributedString = NSMutableAttributedString(string: text)
         attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))

         lblSeeAll.attributedText = attributedString
         
        lblCardTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cards, comment: "")
        lblDigitalAssetsTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.digitalAssets, comment: "")
        lblCardOrderMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardOrderMsg, comment: "")
        btnOrderCard.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.order, comment: ""), for: .normal)
        btnStartKyc.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.check, comment: ""), for: .normal)
        btnAddNewProduct.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addNewProduct, comment: ""), for: .normal)
         
         lblTotalBalance.font = AppFont.regular(19.06).value
         lblChangeValue.font = AppFont.regular(14.89).value
         lblChnageTitle.font = AppFont.regular(14.89).value
         lblSeeAll.font = AppFont.regular(13.98).value
         lblBalance.font = AppFont.violetRegular(46.16).value
         lblCardTitle.font = AppFont.violetRegular(17.11).value
         lblDigitalAssetsTitle.font = AppFont.violetRegular(17.11).value
         transctionsValueArr =  [DashboardTrnsactions(image: UIImage.receive, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds, comment: "")),DashboardTrnsactions(image: UIImage.send, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")),DashboardTrnsactions(image: UIImage.icWithdrow1, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.withdraw, comment: "")),DashboardTrnsactions(image: UIImage.swap, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchange, comment: ""))]
    }
}
