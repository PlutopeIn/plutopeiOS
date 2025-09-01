//
//  AllCardHistoryViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/08/24.
//

import UIKit

class AllCardHistoryViewController: UIViewController {

    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var headerView: UIView!
    var arrCardList : Card?
    var arrCardHistory : [CardHistoryListNew] = []
    var transactionsByDate = [CardHistorySection]()
    var sign = ""
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    lazy var myCardDetailsViewModel: MyCardDetailsViewModel = {
        MyCardDetailsViewModel { _ ,message in
        }
    }()
    var status = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.history, comment: ""), btnBackHidden: false)
        self.getCardHistory(cardId: "\(arrCardList?.id ?? 0)", size: 50) {
            
        }
        /// Table Register
        tableRegister()
       
    }
    /// Table Register
    func tableRegister() {
        tbvHistory.delegate = self
        tbvHistory.dataSource = self
        tbvHistory.register(CardHistryTbvCell.nib, forCellReuseIdentifier: CardHistryTbvCell.reuseIdentifier)
    }
    func getCardHistory(cardId:String?,size:Int? = 0,completion: @escaping () -> Void) {
        DGProgressView.shared.showLoader(to: view)
        myCardDetailsViewModel.apiGetCardHistoryNew(offset: 0, size: size ?? 0, cardId: cardId ?? "") { status, msg, data in
           
            if status == 1 {
                DGProgressView.shared.hideLoader()
                if !(data?.isEmpty ?? false) {
                    self.arrCardHistory = data ?? []
                    self.organizeChatMessagesByDate()
                    DispatchQueue.main.async {
                        self.tbvHistory.reloadData()
                        self.tbvHistory.restore()
                    }
                } else {
                   // self.isFetchingData = true
                }
                
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: msg, font: AppFont.regular(15).value)
            }
        }
    }
    func organizeChatMessagesByDate() {
        let dateFormatter = DateFormatter()
      //  dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
       
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        var sections = [CardHistorySection]()

        for transaction in arrCardHistory {
            if let sendOnDate = dateFormatter.date(from: transaction.operationDate ?? "") {
                var foundSection = false

                for index in 0..<sections.count {
                    let section = sections[index]

                    if calendar.isDate(sendOnDate, inSameDayAs: dateFormatter.date(from: section.date ?? "")!) {
                        sections[index].data?.append(transaction)
                        foundSection = true
                        break
                    }
                }

                if !foundSection {
                    sections.append(CardHistorySection(date: dateFormatter.string(from: sendOnDate), data: [transaction]))
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


}
extension AllCardHistoryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
}
extension AllCardHistoryViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsByDate.count
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
        let cell = tbvHistory.dequeueReusableCell(indexPath: indexPath) as CardHistryTbvCell
        cell.selectionStyle = .none
        
        cell.lblTitle.font = AppFont.regular(16).value
        cell.lblStatus.font = AppFont.regular(14).value
        cell.lblPrice.font = AppFont.regular(16).value
        
        let transactionsData = transactionsByDate[indexPath.section].data?[indexPath.row]
        
        if transactionsData?.operationStatus == "AUTHORIZED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.AUTHORIZED, comment: "")
        } else if transactionsData?.operationStatus == "CLEARED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.CLEARED, comment: "")
        } else if transactionsData?.operationStatus == "DECLINED" {
            cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.DECLINED, comment: "")
        } else if transactionsData?.operationStatus == "APPROVED" {
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
        
       /*if transactionsData?.operationStatus == "AUTHORIZED" {
            cell.lblStatus.isHidden = false
        } else {
            cell.lblStatus.isHidden = true
        }*/
//        if transactionsData?.type == "topUpCardModel" {
//            cell.ivTansaction.image = UIImage.buy
//            self.sign = "+"
//        } else if transactionsData?.type == "reapClearedTransactionModel" {
//            cell.ivTansaction.image = UIImage.icBankCard
//            self.sign = "-"
//        } else if transactionsData?.type == "reapAuthTransactionModel" {
//            cell.ivTansaction.image = UIImage.icBankCard
//            self.sign = "-"
//        } else {
//            cell.ivTansaction.image = UIImage.icBankCard
//            self.sign = "-"
//        }
//        cell.lblStatus.text = transactionsData?.operationStatus
//        if transactionsData?.topUpCardModel != nil {
//            topUpCardModel(transactionsData, cell)
//        } else if transactionsData?.reapClearedTransactionModel != nil {
//            reapClearedTransactionModel(transactionsData, cell)
//        } else {
//            
//        }
        
       // cell.lblStatus.isHidden = true
       
        //cell.lblDescription.text = transactionsData?.title
//        if transactionsData?.operationStatus == "Approved" {
//            cell.lblStatus.isHidden = false
//            cell.lblPrice.textColor = UIColor.c099817
//            cell.lblStatus.textColor = UIColor.white
//            cell.lblStatus.text = "APPROVED"
//            cell.lblStatus.backgroundColor = UIColor.c1DC956
//            //            self.sign = ""
//        } else {
//            cell.lblPrice.textColor = UIColor.white
//            cell.lblStatus.isHidden = true
//        }
        
//        if transactionsData?.type == "topUpCardModel" {
//            topUpCardModel(transactionsData, cell)
//        } else if transactionsData?.type == "reapClearedTransactionModel" {
//            reapClearedTransactionModel(transactionsData, cell)
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: tbvHistory.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x:0, y: 0, width: tbvHistory.frame.width, height: 20))
        
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
}
