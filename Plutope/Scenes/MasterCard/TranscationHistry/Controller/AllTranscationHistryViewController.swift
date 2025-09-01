//
//  AllTranscationHistryViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import UIKit

class AllTranscationHistryViewController: UIViewController ,Reusable {

    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var tbvheight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var imgNodata: UIImageView!
    
    var page = 50
    var isFetchingData = false
    var allTransactionData = [AllTransactionHistryDataList]()
    var transactionsByDate = [AllTransactionHistrySection]()
    var sign = ""
    var currentPage = 0
    var isLoading = false
    var totalPage = 1
    let server = serverTypes
    var transactions: [AllTransactionHistryDataListNewElement] = []
    var transactionSections: [AllTransactionHistrySectionNew] = []
    lazy var viewModel: AllTranscationHistryViewwModel = {
        AllTranscationHistryViewwModel { _ ,_ in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgNodata.isHidden = false
        self.lblNoData.isHidden = false
        
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.history, comment: ""), btnBackHidden: false)
        /// Table Register
        tableRegister()
            fetchTransactions(offset: 0,size: 50)
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offsetY = scrollView.contentOffset.y
//         let contentHeight = scrollView.contentSize.height
//         let frameHeight = scrollView.frame.size.height
//         
//         if offsetY > contentHeight - frameHeight && !isFetchingData {
//             // Prevent multiple simultaneous fetches
//             isFetchingData = true
//             
//             // Increase the page size
//             self.page += 10
//             
//             // Fetch the next page of data
//             getAllTransctionHistory(size: self.page) { [weak self] in
//                 // Once fetching is complete, set the flag to false
//                 self?.isFetchingData = false
//             }
//         }
//        }
    
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
    /// Table Register
    func tableRegister() {
        tbvHistory.delegate = self
        tbvHistory.dataSource = self
        tbvHistory.register(AllTranscationHistryTbvCell.nib, forCellReuseIdentifier: AllTranscationHistryTbvCell.reuseIdentifier)
    }
    private func fetchTransactions(offset:Int? = 0,size: Int? = 0) {
        DGProgressView.shared.showLoader(to: view)
        viewModel.fetchTransactions(offset: offset ?? 0, size: size ?? 0) { result in
                switch result {
                case .success(let transactions):
                    DGProgressView.shared.hideLoader()
                   
                    DispatchQueue.main.async {
                        DGProgressView.shared.hideLoader()
                        self.transactions = transactions
                        
                        if self.transactions.count == 0 {
                            self.imgNodata.isHidden = false
                            self.lblNoData.isHidden = false
                        } else {
                            self.imgNodata.isHidden = true
                            self.lblNoData.isHidden = true
                        }
                        
                        self.organizeChatMessagesByDateNew(with: transactions)
                        self.tbvHistory.reloadData()
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { DGProgressView.shared.hideLoader() }
                    // Handle error (error is of type Error)
                    print("Error fetching transactions: \(error.localizedDescription)")
                    
                    // Handle specific errors if needed
                    switch error {
                    case NetworkError.authenticationError:
                        // Handle authentication error
                        logoutApp()
                    default:
                        // Handle other errors
                        DispatchQueue.main.async {
                            DGProgressView.shared.hideLoader()
                        }
                    }
                }
            }
        }

    func organizeChatMessagesByDateNew(with transactions: [AllTransactionHistryDataListNewElement]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        var sections = [AllTransactionHistrySectionNew]()

        for transaction in transactions {
            // Populate operationType and title fields
            var updatedTransaction = transaction
             updatedTransaction.type = determineOperationType(for: transaction)
            updatedTransaction.title = determineTitle(for: transaction)
            
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
                    sections.append(AllTransactionHistrySectionNew(date: dateFormatter.string(from: sendOnDate), data: [updatedTransaction]))
                }
            }
        }

        // Sort sections by date
        sections.sort { (lhs, rhs) -> Bool in
            return dateFormatter.date(from: lhs.date ?? "")! > dateFormatter.date(from: rhs.date ?? "")!
        }

        transactionSections = sections
        self.tbvHistory.reloadData()
    }
    func determineOperationType(for transaction: AllTransactionHistryDataListNewElement) -> String {
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

    func determineTitle(for transaction: AllTransactionHistryDataListNewElement) -> String {
        
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
