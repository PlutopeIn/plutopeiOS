//
//  MyCardDetailsViewController+TableViewDatasource,Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 01/07/24.
//

import UIKit

extension MyCardDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        if indexPath.row == 0 { //TopUp
            let topupCardVC = TopUpCardViewController()
            topupCardVC.cardRequestId = self.cardRequestId
            topupCardVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(topupCardVC, animated: true)
        } else if indexPath.row == 1 { //Freeze
            if isFreeze == false {
                myCardDetailsViewModel.apiCardFreezeCodeSendNew(cardId: "\(arrCardList?.id ?? 0)", code: "") { resStatus,resMsg, dataValue in
                    if resStatus == 1 {
                        //                    DispatchQueue.main.async {
                        //                        self.btnFreeze.setImage(UIImage.icUnfreeze, for: .normal)
                        //                        self.isFreeze = true
                        //                        self.lblFrize.text = "UnFreeze"
                        //                    }
                        let presentInfoVc = ShowOTPViewController()
                        //                presentInfoVc.alertData = .sellCryptoWarning
                        presentInfoVc.modalTransitionStyle = .crossDissolve
                        presentInfoVc.modalPresentationStyle = .overFullScreen
                        presentInfoVc.delegate = self
                        presentInfoVc.arrCardList = self.arrCardList
                        presentInfoVc.publicKey = self.publicKey
                        presentInfoVc.code = ""
                        presentInfoVc.isFromCardFreeze = true
                        presentInfoVc.isFromCardDetails = false
                        presentInfoVc.isFromCardUnFreeze = false
                        self.present(presentInfoVc, animated: true, completion: nil)
                    } else {
                        self.showToast(message: "err", font: AppFont.regular(15).value)
                    }
                }
            } else {
                myCardDetailsViewModel.apiCardUnFreezeCodeSendNew(cardId: "\(arrCardList?.id ?? 0)", code: "") { resStatus,resMsg, dataValue in
                    if resStatus == 1 {
                        //                    DispatchQueue.main.async {
                        //                        self.btnFreeze.setImage(UIImage.icFreeze, for: .normal)
                        //                        self.isFreeze = false
                        //                        self.lblFrize.text = "Freeze"
                        //                    }
                        let presentInfoVc = ShowOTPViewController()
                        //                presentInfoVc.alertData = .sellCryptoWarning
                        presentInfoVc.modalTransitionStyle = .crossDissolve
                        presentInfoVc.modalPresentationStyle = .overFullScreen
                        presentInfoVc.delegate = self
                        presentInfoVc.arrCardList = self.arrCardList
                        presentInfoVc.publicKey = self.publicKey
                        presentInfoVc.code = ""
                        presentInfoVc.isFromCardFreeze = false
                        presentInfoVc.isFromCardDetails = false
                        presentInfoVc.isFromCardUnFreeze = true
                        self.present(presentInfoVc, animated: true, completion: nil)
                    } else {
                        self.showToast(message: "err", font: AppFont.regular(15).value)
                    }
                }
            }
        } else if indexPath.row == 2 { //Details
            /*let cryptoCardNumber =  UserDefaults.standard.value(forKey: cryptoCardNumber) as? String ?? ""
            if cryptoCardNumber != "" {
                self.lblCardNumber.text = cryptoCardNumber
            } else {
                getCardNumber()
            }*/
            if isFromPinNumber == true {
                isFromPinNumber = false
                self.lblCVVNumber.text = "****"
                self.arrMenuOptions[2] = MenuOptionsList(title: "Details", image: UIImage.icDetailsHide)
                self.clvMenuOptions.reloadData()
            } else {
                isFromPinNumber = true
                self.getCardInfoCode(isFrom:"pinNo")
            }
            if isFromExpiry == true {
                isFromExpiry = false
                self.lblExpiryDate.text = "**/**"
                self.lblCVVNumber.text = "****"
                self.arrMenuOptions[2] = MenuOptionsList(title: "Details", image: UIImage.icDetailsHide)
                self.clvMenuOptions.reloadData()
            } else {
                isFromExpiry = true
                self.getCardInfoCode(isFrom: "cardExpiry")
            }
        } else if indexPath.row == 3 { // Change Pin
            let presentPinVc = ChangePinViewController()
            presentPinVc.modalTransitionStyle = .crossDissolve
            presentPinVc.modalPresentationStyle = .overFullScreen
            presentPinVc.delegate = self
            presentPinVc.arrCardList = self.arrCardList
            presentPinVc.publicKey = self.publicKey
            presentPinVc.code = ""
            presentPinVc.isFromCardFreeze = true
            presentPinVc.isFromCardDetails = false
            presentPinVc.isFromCardUnFreeze = false
            self.present(presentPinVc, animated: true, completion: nil)
            
        } else if indexPath.row == 4 { //Orders
            
        } else {
            
        }
    }
}

extension MyCardDetailsViewController: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrMenuOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvMenuOptions.dequeueReusableCell(indexPath: indexPath) as OptionMenuCollectionCell
        let arrData = self.arrMenuOptions[indexPath.row]
        cell.lblTitle.text = arrData.title
        cell.imgOptions.image = arrData.image
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //            return CGSize(width: (screenWidth - 80) / 3, height: 63)
        return CGSize(width:clvMenuOptions.frame.width / 4, height: 120)
    }
    
}

extension MyCardDetailsViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tbvHistory.cellForRow(at: indexPath) as? AllTranscationHistryTbvCell
//        let transactionsData = self.transactionData?[indexPath.row]
//        let historyDetailsVC = TranscationHistoryDetailViewController()
//        historyDetailsVC.allTransactionData = transactionsData
//    historyDetailsVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(historyDetailsVC, animated: true)
//
//    }
}
extension MyCardDetailsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return min(transactionsByDate.count, 2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsByDate[section].data?.count ?? 0
    }
    fileprivate func topUpCardModel(_ transactionsData: CardHistoryListNew?, _ cell: CardHistryTbvCell) {
        cell.ivTansaction.image = UIImage.buy
        cell.lblPrice.textColor = .green
        if let creditAmount = transactionsData?.topUpCardModel?.amount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            // cell.lblPrice.textColor = UIColor.c099817
            cell.lblPrice.text = "+ \(creditAmountValue) \(transactionsData?.topUpCardModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.text = "Add funds to card"
    }
    fileprivate func reapClearedTransactionModel(_ transactionsData: CardHistoryListNew?, _ cell: CardHistryTbvCell) {
        cell.ivTansaction.image = UIImage.icBankCard
        cell.lblPrice.textColor = .red
        if let creditAmount = transactionsData?.reapClearedTransactionModel?.amount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            // cell.lblPrice.textColor = UIColor.c099817
            cell.lblPrice.text = "- \(creditAmountValue) \(transactionsData?.reapClearedTransactionModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.text = transactionsData?.reapClearedTransactionModel?.merchantName ?? ""
        
    }
    fileprivate func reapAuthTransactionModel(_ transactionsData: CardHistoryListNew?, _ cell: CardHistryTbvCell) {
        cell.ivTansaction.image = UIImage.icBankCard
        cell.lblPrice.textColor = .red
        if let creditAmount = transactionsData?.reapAuthTransactionModel?.amount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            // cell.lblPrice.textColor = UIColor.c099817
            cell.lblPrice.text = "- \(creditAmountValue) \(transactionsData?.reapAuthTransactionModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.text = transactionsData?.reapAuthTransactionModel?.merchantName ?? ""
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvHisotry.dequeueReusableCell(indexPath: indexPath) as CardHistryTbvCell
        cell.selectionStyle = .none
        
        cell.lblTitle.font = AppFont.regular(16).value
        cell.lblStatus.font = AppFont.regular(14).value
        cell.lblPrice.font = AppFont.regular(16).value
        
        let transactionsData = transactionsByDate[indexPath.section].data?[indexPath.row]
        
        if transactionsData?.operationStatus == "AUTHORIZED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.AUTHORIZED, comment: "")
        }  else if transactionsData?.operationStatus == "CLEARED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.CLEARED, comment: "")
        }  else if transactionsData?.operationStatus == "DECLINED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.DECLINED, comment: "")
        }  else if transactionsData?.operationStatus == "APPROVED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.APPROVED, comment: "")
        } else {
            cell.lblStatus.text = transactionsData?.operationStatus
        }
        if transactionsData?.topUpCardModel != nil {
            topUpCardModel(transactionsData, cell)
        } else if transactionsData?.reapClearedTransactionModel != nil {
            reapClearedTransactionModel(transactionsData, cell)
        } else if transactionsData?.reapAuthTransactionModel != nil {
            reapAuthTransactionModel(transactionsData, cell)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let transactionsData = transactionsByDate[indexPath.section].data?[indexPath.row]
        let transactionDetailsVC = CardTransactionHistoryDetailController()
        transactionDetailsVC.hidesBottomBarWhenPushed = true
        transactionDetailsVC.allTransactionData = transactionsData
        if transactionsData?.topUpCardModel != nil {
            transactionDetailsVC.titles = "Add funds to card"
        } else if transactionsData?.reapClearedTransactionModel != nil {
            transactionDetailsVC.titles = transactionsData?.reapClearedTransactionModel?.merchantName ?? ""
        } else if transactionsData?.reapAuthTransactionModel != nil {
            transactionDetailsVC.titles = transactionsData?.reapAuthTransactionModel?.merchantName ?? ""
        }
        self.navigationController?.pushViewController(transactionDetailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: tbvHisotry.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x:0, y: 0, width: tbvHisotry.frame.width, height: 20))
        
        label.font = AppFont.regular(12.0).value
        label.textAlignment = .left
        label.textColor = UIColor.label
        tableHeader.addSubview(label)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        let sendOnDate = dateFormatter.date(from: transactionsByDate[section].date ?? "")
        let sectionDate = dateFormatter.string(from:sendOnDate ?? Date())
        if calendar.isDateInToday(sendOnDate ?? Date()) {
            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.today, comment: "")
        } else if calendar.isDateInYesterday(sendOnDate ?? Date()) {
            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yesterday, comment: "")
        } else {
            label.text = sectionDate.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM ", timeZone: nil).0
        }
        return tableHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        tbvHeight.constant = tbvHisotry.contentSize.height
    }
}
