//
//  TokenDashboardViewController+TableviewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/06/24.
//

import UIKit

extension TokenDashboardViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tbvHistory.cellForRow(at: indexPath) as? AllTranscationHistryTbvCell
//        let transactionsData = self.transactionData?[indexPath.row]
//        let historyDetailsVC = TranscationHistoryDetailViewController()
//        historyDetailsVC.allTransactionData = transactionsData
//        self.navigationController?.pushViewController(historyDetailsVC, animated: true)
//        
//    }
}
extension TokenDashboardViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//            return transactionsByDate.count
        
        return min(transactionsByDate.count, 4)
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsByDate[section].data?.count ?? 0
    }
    
    fileprivate func cardIssueModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: SingleTransactionHistry?) {
        cell.ivTansaction.image = UIImage.smallBuy
        if let creditAmount = transactionsData?.cardIssueModel?.amount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            // cell.lblPrice.textColor = UIColor.c099817
            let balance = WalletData.shared.formatDecimalString("\(creditAmountValue)", decimalPlaces: 4)
            cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.cardIssueModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.setCenteredEllipsisText(transactionsData?.cardIssueModel?.fromAddress ?? "")
    }
    
    fileprivate func receiveCryptoModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: SingleTransactionHistry?) {
        cell.ivTansaction.image = UIImage.cryptowallet
        if let creditAmount = transactionsData?.receiveCryptoModel?.amount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(creditAmountValue)", decimalPlaces: 4)
            // cell.lblPrice.textColor = UIColor.c099817
            cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.receiveCryptoModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.setCenteredEllipsisText(transactionsData?.receiveCryptoModel?.toAddress ?? "")
    }
    fileprivate func sendToPhoneModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: SingleTransactionHistry?) {
        cell.ivTansaction.image = UIImage.icMobile
        if let creditAmount = transactionsData?.sendToPhoneModel?.amount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(creditAmountValue)", decimalPlaces: 4)
            cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.sendToPhoneModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.text = transactionsData?.sendToPhoneModel?.toPhone
    }
    fileprivate func exchangeModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: SingleTransactionHistry?) {
        cell.ivTansaction.image = UIImage.icExchange
        cell.lblDuration.isHidden = false
        cell.lblDuration.textColor = UIColor.red
        if let debitAmount = transactionsData?.exchangeModel?.debitAmount?.value {
            let debitAmountValue: Double = {
                switch debitAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(debitAmountValue)", decimalPlaces: 4)
            cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.exchangeModel?.debitAmount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        if let craditAmount = transactionsData?.exchangeModel?.creditAmount?.value {
            let craditAmountValue: Double = {
                switch craditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(craditAmountValue)", decimalPlaces: 4)
            cell.lblDuration.text = "- \(balance) \(transactionsData?.exchangeModel?.creditAmount?.currency ?? "")"
        } else {
            cell.lblDuration.text = "0"
        }
        cell.lblTitle.text = "\(transactionsData?.exchangeModel?.creditAmount?.currency ?? "")->\(transactionsData?.exchangeModel?.debitAmount?.currency ?? "")"
    }
    
    fileprivate func  sendToWalletModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: SingleTransactionHistry?) {
        cell.ivTansaction.image = UIImage.cryptowallet
        if let creditAmount = transactionsData?.sendToWalletModel?.debitAmount?.value {
            let creditAmountValue: Double = {
                switch creditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(creditAmountValue)", decimalPlaces: 4)
            cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.sendToWalletModel?.debitAmount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.setCenteredEllipsisText(transactionsData?.sendToWalletModel?.toAddress ?? "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvHistory.dequeueReusableCell(indexPath: indexPath) as AllTranscationHistryTbvCell
        cell.selectionStyle = .none
        cell.lblTitle.font = AppFont.violetRegular(15).value
        cell.lblDescription.font = AppFont.regular(11).value
        cell.lblPrice.font = AppFont.violetRegular(15.03).value
       
        let transactionsData =  transactionsByDate[indexPath.section].data?[indexPath.row]
        cell.lblDescription.text = transactionsData.map { determineTitle(for: $0) } ?? ""
        cell.lblDuration.isHidden = true
      
        if transactionsData?.operationStatus == "FAILED" {
            cell.lblStatus.isHidden = false
            cell.lblStatus.text = "Failed"
            cell.lblPrice.textColor = UIColor.red
            cell.lblStatus.textColor = UIColor.red
            self.sign = ""
        } else if transactionsData?.operationStatus == "PENDING" {
            cell.lblStatus.isHidden = false
            cell.lblStatus.text = "Pending"
            cell.lblStatus.textColor = UIColor.green
            cell.lblPrice.textColor = UIColor.green
            self.sign = ""
        }
        else {
            if ((transactionsData?.cardIssueModel) != nil) {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else if ((transactionsData?.sendToWalletModel) != nil) {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else if ((transactionsData?.sendToPhoneModel) != nil) {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "+"
            }
        }
       
        if ((transactionsData?.payoutCardModel) != nil) {
            cell.ivTansaction.image = UIImage.icBankCard
           // cell.lblPrice.textColor = UIColor.c099817
            if let debitAmount = transactionsData?.payoutCardModel?.creditAmount?.value {
                let debitAmountFeeValue: Double = {
                    switch debitAmount {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                let balance = WalletData.shared.formatDecimalString("\(debitAmountFeeValue)", decimalPlaces: 4)
                cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.payoutCardModel?.creditAmount?.currency ?? "")"
            } else {
                cell.lblPrice.text = "0"
            }
            cell.lblTitle.text = transactionsData?.payoutCardModel?.toCardPAN
            
        } else if ((transactionsData?.payinCardModel) != nil) {
            cell.ivTansaction.image = UIImage.icBankCard
            if let creditAmount = transactionsData?.payinCardModel?.debitAmount?.value {
                let creditAmountValue: Double = {
                    switch creditAmount {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
              //  cell.lblPrice.textColor = UIColor.c099817
                let balance = WalletData.shared.formatDecimalString("\(creditAmountValue)", decimalPlaces: 4)
                cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.payinCardModel?.debitAmount?.currency ?? "")"
            } else {
                cell.lblPrice.text = "0"
            }
            cell.lblTitle.text = transactionsData?.payinCardModel?.fromCardPAN
        } else if ((transactionsData?.receiveCryptoModel) != nil) {
            receiveCryptoModel(cell, transactionsData)
        } else if ((transactionsData?.sendToWalletModel) != nil) {
               sendToWalletModel(cell, transactionsData)
        } else if ((transactionsData?.sendToPhoneModel) != nil) {
            sendToPhoneModel(cell, transactionsData)
        } else if ((transactionsData?.cardIssueModel) != nil) {
            cardIssueModel(cell, transactionsData)
        } else if ((transactionsData?.exchangeModel) != nil) {
            exchangeModel(cell, transactionsData)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: tbvHistory.frame.width, height: 30))
        let label = UILabel(frame: CGRect(x:0, y: 0, width: tbvHistory.frame.width, height: 20))
        
        label.textAlignment = .left
        label.textColor = UIColor.label
        label.font = AppFont.regular(12).value
        tableHeader.addSubview(label)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        var sendOnDate = Date()
        var sectionDate = ""
        
            sendOnDate = dateFormatter.date(from: transactionsByDate[section].date ?? "") ?? Date()
            sectionDate = dateFormatter.string(from:sendOnDate)
        if calendar.isDateInToday(sendOnDate) {
            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.today, comment: "")
        } else if calendar.isDateInYesterday(sendOnDate) {
            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yesterday, comment: "")
        } else {
            label.text = sectionDate.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM ", timeZone: nil).0
        }
        return tableHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        tbvHeight.constant = tbvHistory.contentSize.height
    }
    func determineOperationType(for transaction: SingleTransactionHistry) -> String {
        // Logic to determine operation type based on transaction data
        if transaction.payoutCardModel != nil {
            return "payoutCardModel"
        } else if transaction.payinCardModel != nil {
            return "payinCardModel"
        } else if transaction.receiveCryptoModel != nil {
            return "receiveCryptoModel"
        } else if transaction.sendToWalletModel != nil {
            return "sendToWalletModel"
        } else if transaction.sendToPhoneModel != nil {
            return "sendToPhoneModel"
        } else if transaction.cardIssueModel != nil {
            return "cardIssueModel"
        } else if transaction.exchangeModel != nil {
            return "exchangeModel"
        }
        // Add other conditions as needed
        return "Unknown"
    }

    func determineTitle(for transaction: SingleTransactionHistry) -> String {
        
        if transaction.payoutCardModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.withdrawtobankcard, comment: "")
        } else if transaction.payinCardModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.topupviabankcard, comment: "")
        } else if transaction.receiveCryptoModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.topupviaothercryptowallets, comment: "")
        } else if transaction.sendToWalletModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfertoWalletModel, comment: "")
        } else if transaction.sendToPhoneModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfertoPhoneWallet, comment: "")
        } else if transaction.cardIssueModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.paymentforcardissuing, comment: "")
        } else if transaction.exchangeModel != nil {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchange, comment: "")
        }
        // Logic to determine title based on transaction data
        return ""
    }

}
