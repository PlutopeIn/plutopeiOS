//
//  TokenAllViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 23/08/24.
//

import UIKit

class TokenAllViewController: UIViewController {

    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var headerView: UIView!
    var arrWallet : Wallet?
    var newWallets:[CreateWallets] = []
    var selectedTokenArray = [String]()
    var transactionData = [SingleTransactionHistry]()
   
    var transactionsByDate = [SingleTransactionHistrySection]()
    var sign = ""
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,message in
        }
    }()
    lazy var viewModel: AllTranscationHistryViewwModel = {
        AllTranscationHistryViewwModel { _ ,_ in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.history, comment: ""), btnBackHidden: false)
        getHistory()
        /// Table Register
        tableRegister()
       
    }
    /// Table Register
    func tableRegister() {
        tbvHistory.delegate = self
        tbvHistory.dataSource = self
        tbvHistory.register(AllTranscationHistryTbvCell.nib, forCellReuseIdentifier: AllTranscationHistryTbvCell.reuseIdentifier)
    }
    func formattedDate(for dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Assuming your date strings are in this format
            guard let date = dateFormatter.date(from: dateString) else { return dateString }

            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.today, comment: "")
            } else if calendar.isDateInYesterday(date) {
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yesterday, comment: "")
            } else {
                dateFormatter.dateFormat = "dd MMM"
                return dateFormatter.string(from: date)
            }
        }

        func sortDates(_ dates: [String]) -> [String] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Assuming your date strings are in this format
            
            return dates.sorted { (dateString1, dateString2) -> Bool in
                guard let date1 = dateFormatter.date(from: dateString1),
                      let date2 = dateFormatter.date(from: dateString2) else {
                    return false
                }

                let calendar = Calendar.current
                if calendar.isDateInToday(date1) {
                    return true
                }
                if calendar.isDateInToday(date2) {
                    return false
                }
                if calendar.isDateInYesterday(date1) {
                    return true
                }
                if calendar.isDateInYesterday(date2) {
                    return false
                }
                return date1 > date2
            }
        }
    func getHistory() {
        DGProgressView.shared.showLoader(to: view)
//        if let currency = arrWallet?.currency {
//            selectedTokenArray.append(currency)
//        }
        guard let currency = arrWallet?.currency else {
            return
        }
        viewModel.getSingleWalletHistoryAPI(currencyFilter: arrWallet?.currency ?? "") { status, msg, data in
                if status == 1 {
                    DGProgressView.shared.hideLoader()
                    self.transactionData = data ?? []
                    
                    DispatchQueue.main.async {
                        if (self.transactionData.isEmpty) {
                            self.tbvHistory.setEmptyMessage("No history", font: AppFont.regular(15).value, textColor: UIColor.label)
                            self.tbvHistory.reloadData()
                             self.tbvHistory.restore()
                        } else {
                            self.organizeChatMessagesByDate(with: data ?? [])
                            
                            self.tbvHistory.reloadData()
                            self.tbvHistory.restore()
                        }
                    }
                } else {
                    DGProgressView.shared.hideLoader()
                   
                    self.showToast(message: msg, font: AppFont.regular(15).value)
                }
            
        }
    }
    func organizeChatMessagesByDate(with transactions: [SingleTransactionHistry]) {
        let dateFormatter = DateFormatter()
      //  dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
       
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        var sections = [SingleTransactionHistrySection]()
       
        for transaction in transactions {
            var updatedTransaction = transaction
          //  updatedTransaction.type = determineOperationType(for: transaction)
          //  updatedTransaction.title = determineTitle(for: transaction)
            if let sendOnDate = dateFormatter.date(from: updatedTransaction.operationDate ?? "") {
                var foundSection = false

                for index in 0..<sections.count {
                    let section = sections[index]

                    if calendar.isDate(sendOnDate, inSameDayAs: dateFormatter.date(from: section.date ?? "")!) {
                        sections[index].data?.append(updatedTransaction)
                        foundSection = true
                        break
                    }
                }

                if !foundSection {
                    sections.append(SingleTransactionHistrySection(date: dateFormatter.string(from: sendOnDate), data: [updatedTransaction]))
                }
            }
        }

        // Sort sections by date
        sections.sort { (lhs, rhs) -> Bool in
            return dateFormatter.date(from: lhs.date ?? "")! > dateFormatter.date(from: rhs.date ?? "")!
        }

        transactionsByDate = sections
        self.tbvHistory.reloadData()
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
extension TokenAllViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tbvHistory.cellForRow(at: indexPath) as? AllTranscationHistryTbvCell
//        let transactionsData = self.transactionData?[indexPath.row]
//        let historyDetailsVC = TranscationHistoryDetailViewController()
//        historyDetailsVC.allTransactionData = transactionsData
//        self.navigationController?.pushViewController(historyDetailsVC, animated: true)
//
//    }
}
extension TokenAllViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return transactionsByDate.count
       
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
            cell.lblPrice.textColor = UIColor.red
            self.sign = ""
        } else {
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
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.view.layoutIfNeeded()
////        tbvHeight.constant = tbvHistory.contentSize.height
//    }
    
}
