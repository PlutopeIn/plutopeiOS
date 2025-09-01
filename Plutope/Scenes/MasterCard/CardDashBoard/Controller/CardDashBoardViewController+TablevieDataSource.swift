//
//  CardDashBoardViewController+TablevieDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/05/24.
//

import Foundation
import UIKit
import SDWebImage
// MARK: - UITableViewDelegate methods
extension CardDashBoardViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvDashboard.cellForRow(at: indexPath) as? MyCardTableViewCell
            let tokenDashboardVC = TokenDashboardViewController()
           tokenDashboardVC.arrWallet =  self.arrWalletList[indexPath.row]
           tokenDashboardVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(tokenDashboardVC, animated: true)

    }
}
// MARK: - UITableViewDataSource methods
extension CardDashBoardViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return min(arrWalletList.count, 5)
    }
    
    fileprivate func tbvDashbordSetup(_ indexPath: IndexPath, _ cell: MyCardCollectionViewCell) {
        let data = arrCardList[indexPath.row]
//        cell.selectionStyle = .none
        cell.additionalStatuses = data.additionalStatuses ?? []
        cell.ivCard.isHidden = true
        if data.cardCompany == "VISA" {
            cell.ivCardCompany.image = UIImage(named: "visa")
        } else {
            cell.ivCardCompany.image = UIImage(named: "ic_masterCard1")
        }
        if data.cardDesignID == "BLUE" {
            cell.viewCard.backgroundColor = UIColor.c2B5AF3
        } else if data.cardDesignID == "ORANGE" {
            cell.viewCard.backgroundColor = UIColor.cffa500
        } else if data.cardDesignID == "BLACK" {
            cell.viewCard.backgroundColor = UIColor.black
        } else if data.cardDesignID == "GOLD" {
            cell.viewCard.backgroundColor = UIColor.cCBB28B
        } else if data.cardDesignID == "PURPLE" {
            cell.viewCard.backgroundColor = UIColor.c800080
        }
        cell.lblFreeze.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.frozon, comment: "")
        switch data.status?.lowercased() {
        case "active":
            if let price = data.balance?.value {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                self.cardPrice = "\(priceValue)"
            } else {
                self.cardPrice = "0"
            }
        
            cell.circularProgress.trackClr = UIColor.white
            cell.circularProgress.progressClr = UIColor.green
            cell.circularProgress.setProgressWithAnimation(duration: 1.0, value: 0.95)
            cell.lblToken.text = "\(self.cardPrice) \(data.balance?.currency ?? "")"
            var cardNumber = ""
            if data.number == "" || data.number?.isEmpty ?? false {
                cardNumber = "-"
            } else {
                cardNumber = showLastFourDigits(of: data.number ?? "")
            }
            cell.lblTokkenAddress.text = cardNumber
            cell.cardRequestId = data.cardRequestID
            cell.lblFreeze.isHidden = true
            cell.btnCheck.isHidden = true
//            cell.viewCheck.isHidden = true
//            cell.btnAdd.isHidden = false
        case "soft_blocked":
            if let price = data.balance?.value {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                self.cardPrice = "\(priceValue)"
            } else {
                self.cardPrice = "0"
            }
            
            cell.circularProgress.trackClr = UIColor.white
            cell.circularProgress.progressClr = UIColor.green
            cell.circularProgress.setProgressWithAnimation(duration: 1.0, value: 0.95)
            cell.lblToken.text = "\(self.cardPrice) \(data.balance?.currency ?? "")"
            var cardNumber = ""
            if data.number == "" || data.number?.isEmpty ?? false {
                cardNumber = "-"
            } else {
                cardNumber = showLastFourDigits(of: data.number ?? "")
            }
            cell.lblTokkenAddress.text = cardNumber
            cell.lblFreeze.isHidden = false
            cell.btnCheck.isHidden = true
//            cell.viewCheck.isHidden = true
//            cell.btnAdd.isHidden = false
            
        case "support":
            cell.lblToken.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.watingForActivation, comment: "")
            cell.lblTokkenAddress.text = data.cardType == "VIRTUAL" ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtualCard, comment: "") : "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            cell.btnCheck.isHidden = false
          //  cell.viewCheck.isHidden = false
//            cell.btnAdd.isHidden = true
            cell.circularProgress.isHidden = true
            cell.lblFreeze.isHidden = true
            
        case "in_progress":
            cell.lblToken.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.activationinProgress, comment: "")
            cell.lblTokkenAddress.text = data.cardType == "VIRTUAL" ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtualCard, comment: "") : "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            cell.btnCheck.isHidden = false
//            cell.btnAdd.isHidden = true
            cell.circularProgress.isHidden = true
            cell.lblFreeze.isHidden = true
        default:
            cell.lblToken.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.actionNeeded, comment: "")
            cell.lblTokkenAddress.text = data.cardType == "VIRTUAL" ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtualCard, comment: "") : "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            cell.btnCheck.isHidden = false
//            cell.btnAdd.isHidden = true
            cell.circularProgress.isHidden = true
            cell.lblFreeze.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == tbvDashboard {
//        let cell = tbvDashboard.dequeueReusableCell(indexPath: indexPath) as MyCardTableViewCell
//            tbvDashbordSetup(indexPath, cell)
//            cell.btnCheck.tag = indexPath.row
//            cell.btnCheck.isUserInteractionEnabled = true
//            cell.btnCheck.addTarget(self, action: #selector(btnStartKycAction(_:)), for: .touchUpInside)
//                return cell
//            
//        } else {
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = UIColor.systemGray3
            let cell = tbvWallet.dequeueReusableCell(indexPath: indexPath) as  MyTokenTableViewCell
        
            let data = arrWalletList[indexPath.row]
            cell.selectionStyle = .none
            if let price = data.fiat?.amount {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                cell.lblTokkenAddress.text = "\(priceValue) \(data.fiat?.customerCurrency ?? "")"
            } else {
                cell.lblTokkenAddress.text = "0"
            }
            cell.lblToken.text = "\(data.balanceString ?? "") \(data.currency ?? "")"
            
           // let server = serverTypes
//            if server == .live {
                cell.ivToken.sd_setImage(with: URL(string: "\(data.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
//            } else {
//                cell.ivToken.sd_setImage(with: URL(string: "\(data.image ?? "")"), placeholderImage: UIImage.icBank)
//            }
        cell.btnTopup.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds, comment: ""), for: .normal)
            cell.btnTopup.tag = indexPath.row
            cell.btnTopup.isUserInteractionEnabled = true
            cell.btnTopup.addTarget(self, action: #selector(addFund(_:)), for: .touchUpInside)
            return cell

    }
    @objc func btnAddAction(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        let vcToPresent = AddNewCardViewController()
        vcToPresent.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vcToPresent, animated: true)
    }
    @objc func btnStartKycAction(_ sender: UIButton) {
        HapticFeedback.generate(.light)
//        let cell = tbvDashboard.cellForRow(at: [sender.tag]) as? MyCardTableViewCell
        let data = arrCardList[sender.tag]
        
        if data.status == "SUPPORT" {
            let vcToPresent = ActionNeedPopUpViewController()
            vcToPresent.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
            vcToPresent.arrCardList = self.arrCardList.first
            vcToPresent.isStatus = "support"
            self.navigationController?.present(vcToPresent, animated: true)
        }
        if data.status == "IN_PROGRESS" {
            let vcToPresent = ActionNeedPopUpViewController()
            vcToPresent.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
            vcToPresent.arrCardList = self.arrCardList.first
            vcToPresent.isStatus = "inProgress"
            self.navigationController?.present(vcToPresent, animated: true)
        }
        if data.status == "KYC_FORBIDDEN_COUNTRY" {
            let vcToPresent = ActionNeedPopUpViewController()
            vcToPresent.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
            vcToPresent.arrCardList = self.arrCardList.first
            vcToPresent.isStatus = "kycForbiddenCountry"
            self.navigationController?.present(vcToPresent, animated: true)
        }
        
        if ((data.additionalStatuses?.contains("KYC")) == false) {
            presentActionNeedPopUpViewController(withStatus: "Kyc")
        }

        if ((data.additionalStatuses?.contains("ADDRESS")) == false) {
            presentActionNeedPopUpViewController(withStatus: "addresss")
        }

        if ((data.additionalStatuses?.contains("ADDITIONAL_PERSONAL_INFO")) == false) {
            presentActionNeedPopUpViewController(withStatus: "additionalInfo")
        }

        if ((data.additionalStatuses?.contains("PAID")) == false) {
            presentActionNeedPopUpViewController(withStatus: "paid")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == tbvDashboard {
//            let data = arrCardList[indexPath.row]
//            if data.status != "ACTIVE" || data.status != "SOFT_BLOCKKED" {
//                return 85
//            } else {
//                return UITableView.automaticDimension
//            }
//        } else {
            return 67
//        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
//        if tableView == tbvDashboard {
//            tbvCardHeight.constant = tbvDashboard.contentSize.height
//        } else {
            tbvwalletdHeight.constant = tbvWallet.contentSize.height
//        }
        }
    func setAttributedText(labelName : UILabel, labeltext: String, value: String, color: UIColor) {
        
        let commonAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: AppFont.regular(15).value]
        
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: AppFont.regular(12).value]
        
        let partOne = NSMutableAttributedString(string: labeltext, attributes: commonAttributes)
        let partTwo = NSMutableAttributedString(string: value, attributes: yourOtherAttributes)
        
        partOne.append(partTwo)
        labelName.attributedText = partOne
    }
    @objc func addCardBtnTapped(_ sender : UIButton) {
        HapticFeedback.generate(.light)
        let vcToPresent = AddNewCardViewController()
        vcToPresent.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vcToPresent, animated: true)
    }
    @objc func addFund(_ sender:UIButton) {
        HapticFeedback.generate(.light)
        let addFundsVC =  AddCardFundViewController()
        addFundsVC.arrWallet = self.arrWalletList[sender.tag]
        addFundsVC.isFrom = "dashboard"
        addFundsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addFundsVC, animated: true)
        
    }
}
extension CardDashBoardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvActions {
            self.transctionsValueArr.count
        } else {
            /*self.arrDashbordImges.count*/
            self.arrCardList.count
        }
    }
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
     func uiSetup(_ cell: ProductDetailsViewCell, _ indexPath: IndexPath, _ data: Card) {
         cell.btnCheck.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.check, comment: ""), for: .normal)
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.isUserInteractionEnabled = true
        cell.btnCheck.addTarget(self, action: #selector(btnStartKycAction(_:)), for: .touchUpInside)
         cell.btnAdd.tag = indexPath.row
         cell.btnAdd.isUserInteractionEnabled = true
         cell.btnAdd.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
        //            cell.selectionStyle = .none
        cell.additionalStatuses = data.additionalStatuses ?? []
        if data.cardCompany == "VISA" {
            cell.ivCardCompany.image = UIImage(named: "visa")
        } else {
            cell.ivCardCompany.image = UIImage(named: "ic_masterCard1")
        }
        if data.cardDesignID == "BLUE" {
            cell.viewCard.backgroundColor = UIColor.c2B5AF3
        } else if data.cardDesignID == "ORANGE" {
            cell.viewCard.backgroundColor = UIColor.cffa500
        } else if data.cardDesignID == "BLACK" {
            cell.viewCard.backgroundColor = UIColor.black
        } else if data.cardDesignID == "GOLD" {
            cell.viewCard.backgroundColor = UIColor.cCBB28B
        } else if data.cardDesignID == "PURPLE" {
            cell.viewCard.backgroundColor = UIColor.c800080
        }
        cell.lblFreeze.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.frozon, comment: "")
        switch data.status?.lowercased() {
        case "active":
            if let price = data.balance?.value {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                self.cardPrice = "\(priceValue)"
            } else {
                self.cardPrice = "0"
            }
            
            cell.lblToken.text = "\(self.cardPrice) \(data.balance?.currency ?? "")"
            var cardNumber = ""
            if data.number == "" || data.number?.isEmpty ?? false {
                cardNumber = "-"
            } else {
                cardNumber = showLastFourDigits(of: data.number ?? "")
            }
            cell.lblTokkenAddress.text = cardNumber
            cell.cardRequestId = data.cardRequestID
            cell.lblFreeze.isHidden = true
            cell.btnCheck.isHidden = true
            cell.viewCheck.isHidden = true
            if arrCardList.count == 2 {
                cell.btnAdd.isHidden = true
            } else {
                cell.btnAdd.isHidden = false
            }
            
        case "soft_blocked":
            if let price = data.balance?.value {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                self.cardPrice = "\(priceValue)"
            } else {
                self.cardPrice = "0"
            }
            cell.lblToken.text = "\(self.cardPrice) \(data.balance?.currency ?? "")"
            var cardNumber = ""
            if data.number == "" || data.number?.isEmpty ?? false {
                cardNumber = "-"
            } else {
                cardNumber = showLastFourDigits(of: data.number ?? "")
            }
            cell.lblTokkenAddress.text = cardNumber
            cell.lblFreeze.isHidden = false
            cell.btnCheck.isHidden = true
            cell.viewCheck.isHidden = true
            if arrCardList.count == 2 {
                cell.btnAdd.isHidden = true
            } else {
                cell.btnAdd.isHidden = false
            }
            
        case "support":
            cell.lblToken.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.watingForActivation, comment: "")
            cell.lblTokkenAddress.text = data.cardType == "VIRTUAL" ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtualCard, comment: "") : "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            cell.btnCheck.isHidden = false
            cell.viewCheck.isHidden = false
            cell.btnAdd.isHidden = true
            cell.lblFreeze.isHidden = true
            
        case "in_progress":
            cell.lblToken.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.activationinProgress, comment: "")
            cell.lblTokkenAddress.text = data.cardType == "VIRTUAL" ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtualCard, comment: "") : "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            cell.btnCheck.isHidden = false
            cell.viewCheck.isHidden = false
            cell.btnAdd.isHidden = true
            cell.lblFreeze.isHidden = true
        default:
            cell.lblToken.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.actionNeeded, comment: "")
            cell.lblTokkenAddress.text = data.cardType == "VIRTUAL" ? LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtualCard, comment: "") : "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            cell.btnCheck.isHidden = false
            cell.viewCheck.isHidden = false
            cell.btnAdd.isHidden = true
            cell.lblFreeze.isHidden = true
        }
    }
    // swiftlint:enable function_body_length
    // swiftlint:enable cyclomatic_complexity
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clvActions {
            
            let cell = clvActions.dequeueReusableCell(indexPath: indexPath) as WalletDashboardCell
            let data = transctionsValueArr[indexPath.row]
            cell.ivIcon.image = data.image
            cell.lblName.text = data.name
            cell.lblName.font = AppFont.regular(13.8).value
            return cell
        } else {
            let cell = clvSlider.dequeueReusableCell(indexPath: indexPath) as ProductDetailsViewCell
          
            let data = arrCardList[indexPath.row]
            
            uiSetup(cell, indexPath, data)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        if collectionView == clvActions {
            
//            let cell = clvActions.dequeueReusableCell(indexPath: indexPath) as WalletDashboardCell
            
            switch indexPath.row {
            case 0:
                let addFunds = AddCardFundViewController()
                addFunds.hidesBottomBarWhenPushed = true
                addFunds.isFromDashboard = true
                addFunds.arrWallet = self.arrWalletList.first
                self.navigationController?.pushViewController(addFunds, animated: true)
            case 1:
                let sendFunds = SendCardTokenViewController()
                sendFunds.isFromDashboard = true
                sendFunds.arrWallet = self.arrWalletList.first
                sendFunds.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sendFunds, animated: true)
            case 2:
                let withdrowFunds = WithdrowViewController()
                withdrowFunds.arrWallet = self.arrWalletList.first
                withdrowFunds.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(withdrowFunds, animated: true)
            case 3:
                let exchange = ExchangeCardViewController()
                exchange.isFromDashboard = true
                exchange.arrWallet = self.arrWalletList.first
                exchange.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(exchange, animated: true)
            default:
                break
            }
        } else {
            
            if self.arrCardList[indexPath.row].status == "ACTIVE" {
                let cardDetailsVC = MyCardDetailsViewController()
                cardDetailsVC.cardRequestId = self.arrCardList[indexPath.row].id
                cardDetailsVC.arrCardList =  self.arrCardList[indexPath.row]
                cardDetailsVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(cardDetailsVC, animated: true)
            } else if self.arrCardList[indexPath.row].status == "SOFT_BLOCKED"{
                let cardDetailsVC = MyCardDetailsViewController()
                cardDetailsVC.cardRequestId = self.arrCardList[indexPath.row].id
                cardDetailsVC.arrCardList =  self.arrCardList[indexPath.row]
                cardDetailsVC.status = "SOFT_BLOCKED"
                cardDetailsVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(cardDetailsVC, animated: true)
            } else {
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clvActions {
//            return CGSize(width: (screenWidth - 80) / 3, height: 63)
            return CGSize(width: (screenWidth - 40) / 4, height: 63)
        } else {
            return CGSize(width:clvSlider.frame.width , height: 57)
        }
        
    }
    // MARK: - For Display the page number in page controll of collection view Cell
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        snakePageControl.progress = progress
    }
}

extension CardDashBoardViewController {
    func showLastFourDigits(of input: String) -> String {
        let length = input.count
        guard length > 2 else {
            return input
        }
        let start = input.index(input.endIndex, offsetBy: -2)
        let lastFour = input[start..<input.endIndex]
        return "******" + lastFour
    }
}
extension CardDashBoardViewController : RefreshCardTokenDelegate {
    func refreshCardTokenDelegateToken() {
        DispatchQueue.main.async {
            self.getWalletTokensNew { }
        }
       
    }
}
