//
//  AllTranscationHistryViewController+DataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import Foundation
import UIKit
import SDWebImage

// MARK: - UITableViewDataSource methods
extension AllTranscationHistryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return transactionSections.count
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return transactionSections[section].data?.count ?? 0

    }
    
    
    fileprivate func transcationDataLive(_ indexPath: IndexPath, _ cell: AllTranscationHistryTbvCell) {
        let transactionsData = transactionSections[indexPath.section].data?[indexPath.row]
        cell.lblDescription.text = transactionsData?.title
        if transactionsData?.operationStatus == "FAILED" {
            cell.lblStatus.isHidden = false
            cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: "")
            cell.lblPrice.textColor = UIColor.cD50000
            self.sign = ""
        } else if transactionsData?.operationStatus == "PENDING" {
            cell.lblStatus.isHidden = false
            cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pending, comment: "")
            //cell.lblStatus.text = "Pending"
            cell.lblStatus.textColor = UIColor.cE5E11C
            cell.lblPrice.textColor = UIColor.label
            if transactionsData?.type == "sendToWalletModel"  || transactionsData?.type == "sendToPhoneModel" {
                self.sign = "-"
            } else {
                self.sign = ""
            }
            
        } else {
            if transactionsData?.type == "cardIssueModel" {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else if transactionsData?.type == "sendToWalletModel" {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else if transactionsData?.type == "sendToPhoneModel" {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else if transactionsData?.type == "payoutCardModel" {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "-"
            } else {
                cell.lblStatus.isHidden = true
                cell.lblPrice.textColor = UIColor.c099817
                self.sign = "+"
            }
        }
        if transactionsData?.type == "payoutCardModel" {
            payoutCardModel(cell, transactionsData)
        } else if transactionsData?.type == "payinCardModel" {
            payinCardModel(cell, transactionsData)
        } else if transactionsData?.type == "receiveCryptoModel" {
            receiveCryptoModel(cell, transactionsData)
        } else if transactionsData?.type == "exchangeModel" {
            exchangeModel(transactionsData, cell)
        } else if transactionsData?.type == "sendToWalletModel" {
            sendToWalletModel(cell, transactionsData)
        } else if transactionsData?.type == "sendToPhoneModel" {
            sendToPhoneModel(cell, transactionsData)
            
        } else if transactionsData?.type == "depositLockInModel" {
        } else if transactionsData?.type == "depositUnlockModel" {
        } else if transactionsData?.type == "depositInterestModel" {
        } else if transactionsData?.type == "cardIssueModel" {
            cardIssueModel(cell, transactionsData)
        }
    }
    
//    fileprivate func transcationData(_ indexPath: IndexPath, _ cell: AllTranscationHistryTbvCell) {
//        let transactionsData = transactionsByDate[indexPath.section].data?[indexPath.row]
//        cell.lblDescription.text = transactionsData?.title
//        
//        if transactionsData?.operationStatus == "FAILED" {
//            cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: "")
//            cell.lblStatus.isHidden = false
//            cell.lblPrice.textColor = UIColor.cD50000
//            self.sign = ""
//        } else if transactionsData?.operationStatus == "PENDING" {
//            cell.lblStatus.isHidden = false
//            cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pending, comment: "")
////            cell.lblStatus.text = "Pending"
//            cell.lblStatus.textColor = UIColor.cE5E11C
//            cell.lblPrice.textColor = UIColor.label
//            if transactionsData?.type == "sendToWalletModel"  || transactionsData?.type == "sendToPhoneModel" {
//                self.sign = "-"
//            } else {
//                self.sign = ""
//            }
//            
//        } else {
//            if transactionsData?.type == "cardIssueModel" {
//                cell.lblStatus.isHidden = true
//                cell.lblPrice.textColor = UIColor.c099817
//                self.sign = "-"
//            } else if transactionsData?.type == "sendToWalletModel" {
//                cell.lblStatus.isHidden = true
//                cell.lblPrice.textColor = UIColor.c099817
//                self.sign = "-"
//            } else if transactionsData?.type == "sendToPhoneModel" {
//                cell.lblStatus.isHidden = true
//                cell.lblPrice.textColor = UIColor.c099817
//                self.sign = "-"
//            } else if transactionsData?.type == "payoutCardModel" {
//                cell.lblStatus.isHidden = true
//                cell.lblPrice.textColor = UIColor.c099817
//                self.sign = "-"
//            } else {
//                cell.lblStatus.isHidden = true
//                cell.lblPrice.textColor = UIColor.c099817
//                self.sign = "+"
//            }
//        }
//        if transactionsData?.type == "payoutCardModel" {
//            payoutCardModel(cell, transactionsData)
//        } else if transactionsData?.type == "payinCardModel" {
//            payinCardModel(cell, transactionsData)
//        } else if transactionsData?.type == "receiveCryptoModel" {
//            receiveCryptoModel(cell, transactionsData)
//        } else if transactionsData?.type == "exchangeModel" {
//            exchangeModel(transactionsData, cell)
//        } else if transactionsData?.type == "sendToWalletModel" {
//            sendToWalletModel(cell, transactionsData)
//        } else if transactionsData?.type == "sendToPhoneModel" {
//            sendToPhoneModel(cell, transactionsData)
//            
//        } else if transactionsData?.type == "depositLockInModel" {
//        } else if transactionsData?.type == "depositUnlockModel" {
//        } else if transactionsData?.type == "depositInterestModel" {
//        } else if transactionsData?.type == "cardIssueModel" {
//            cardIssueModel(cell, transactionsData)
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvHistory.dequeueReusableCell(indexPath: indexPath) as AllTranscationHistryTbvCell
        cell.selectionStyle = .none
        cell.lblTitle.font = AppFont.violetRegular(14).value
        cell.lblDescription.font = AppFont.regular(11).value
        cell.lblPrice.font = AppFont.violetRegular(14).value
//        if server == .live {
            transcationDataLive(indexPath, cell)
//        } else {
//            transcationData(indexPath, cell)
//        }
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
       
            sendOnDate = dateFormatter.date(from: transactionSections[section].date ?? "") ?? Date()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    fileprivate func cardIssueModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: AllTransactionHistryDataListNewElement?) {
        cell.ivTansaction.image = UIImage.icCardIsuue
        if let creditAmount = transactionsData?.cardIssueModel?.amount?.value {
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
            cell.lblPrice.text = "\(self.sign) \(balance) \(transactionsData?.cardIssueModel?.amount?.currency ?? "")"
        } else {
            cell.lblPrice.text = "0"
        }
        cell.lblTitle.setCenteredEllipsisText(transactionsData?.cardIssueModel?.fromAddress ?? "")
    }
    
    fileprivate func receiveCryptoModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: AllTransactionHistryDataListNewElement?) {
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
    
    fileprivate func sendToWalletModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: AllTransactionHistryDataListNewElement?) {
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
    fileprivate func sendToPhoneModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: AllTransactionHistryDataListNewElement?) {
        cell.ivTansaction.image = UIImage.icMobile//.sd_tintedImage(with: UIColor.label)
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
    
    fileprivate func payoutCardModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: AllTransactionHistryDataListNewElement?) {
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
    }
    
    fileprivate func payinCardModel(_ cell: AllTranscationHistryTbvCell, _ transactionsData: AllTransactionHistryDataListNewElement?) {
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
    }
    
    fileprivate func exchangeModel(_ transactionsData: AllTransactionHistryDataListNewElement?, _ cell: AllTranscationHistryTbvCell) {
        cell.ivTansaction.image = UIImage.icExchange//.sd_tintedImage(with: UIColor.c38FF8E)
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
}
