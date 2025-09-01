//
//  TokenDashboardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 06/06/24.
//

import UIKit
import SDWebImage
import QRScanner
import AVFoundation

class TokenDashboardViewController: UIViewController {
    
    @IBOutlet weak var lblSeeAll: UILabel!
    @IBOutlet weak var lblWithdraw: UILabel!
    @IBOutlet weak var btnWwithdraw: UIButton!
    @IBOutlet weak var stackWithdraw: UIStackView!
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTransactionsHistory: UILabel!
    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var btnCopyy: UIButton!
    @IBOutlet weak var btnScann: UIButton!
    @IBOutlet weak var lblWalletAddress: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var stackSeeAll: UIStackView!
    @IBOutlet weak var lblTokenBalance: UILabel!
    
    @IBOutlet weak var lblTokenName: UILabel!
    @IBOutlet weak var ivToken: UIImageView!
    
    @IBOutlet weak var viewWalletAddress: UIView!
    @IBOutlet weak var lblBuy: UILabel!
    
    @IBOutlet weak var btnBuy: UIButton!
    
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var viewCreateWallet: UIView!
    @IBOutlet weak var lblExchange: UILabel!
    @IBOutlet weak var btnExchange: UIButton!
    
    @IBOutlet weak var btnWalletAddress: GradientButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblTopupAddress: UILabel!
    @IBOutlet weak var btnBuyCoin: GradientButton!
    @IBOutlet weak var lblBuyMsg: UILabel!
    @IBOutlet weak var lblBuyTitle: UILabel!
    var arrWallet : Wallet?
    @IBOutlet weak var stackBuy: UIStackView!
    var newWallets:[CreateWalletDataList] = []
    var selectedTokenArray = [String]()
    var transactionData = [SingleTransactionHistry]()
   
    var transactionsByDate = [SingleTransactionHistrySection]()
    var sign = ""
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var viewModel: AllTranscationHistryViewwModel = {
        AllTranscationHistryViewwModel { _ ,_ in
        }
    }()
    let server = serverTypes
    fileprivate func uiSetUp() {
        
        if server == .live {
            ivToken.sd_setImage(with: URL(string: "\(arrWallet?.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
        } else {
            ivToken.sd_setImage(with: URL(string: "\(arrWallet?.image ?? "")"), placeholderImage: UIImage.icBank)
        }
//        ivToken.sd_setImage(with: URL(string: "\(arrWallet?.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
        if let price = arrWallet?.fiat?.amount {
            let priceValue: Double = {
                switch price {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblTokenBalance.text = "\(priceValue) \(arrWallet?.fiat?.customerCurrency ?? "")"
        } else {
            self.lblTokenBalance.text = "0"
        }
        lblTokenName.text = "\(arrWallet?.balanceString ?? "") \(arrWallet?.currency ?? "") "
        let localizedString = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wantToUsePlutope, comment: "")
        let formattedString = String(format: localizedString, arrWallet?.name ?? "")
        lblTitle.text = formattedString // "Want to use \(arrWallet?.name ?? "") in Plutope?"
        let localizedString1 = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionShowHere, comment: "")
        let formattedString1 = String(format: localizedString, arrWallet?.name ?? "")
        lblBuyTitle.text = formattedString1 // "Your \(arrWallet?.name ?? "") transactions will show up here"
        btnBuyCoin.setTitle("\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds, comment: "")) \(arrWallet?.name ?? "")", for: .normal)
        lblTopupAddress.font = AppFont.violetRegular(15.7).value
        lblTransactionsHistory.font = AppFont.violetRegular(15.7).value
        lblSeeAll.font = AppFont.violetRegular(15).value
        lblWalletAddress.font = AppFont.regular(12).value
//        lblTokenName.font = AppFont.violetRegular(26).value
        lblTokenBalance.font = AppFont.regular(18).value
        lblSend.font = AppFont.regular(12.5).value
        lblBuy.font = AppFont.regular(12.5).value
        lblExchange.font = AppFont.regular(12.5).value
        lblWithdraw.font = AppFont.regular(12.5).value
        
        lblBuy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds, comment: "")
        lblSend.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send, comment: "")
        lblExchange.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchange, comment: "")
        lblWithdraw.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.withdraw, comment: "")
        lblTopupAddress.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.topUpAddress, comment: "")
        lblTransactionsHistory.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionHistory, comment: "")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenName = arrWallet?.currency
        // Navigation header
        defineHeader(headerView: headerView, titleText: "\(tokenName ?? "")", btnBackHidden: false)
//        self.checkForCameraPermission()
       
        if arrWallet?.allowOperations?.contains("PAYIN_CRYPTO") ?? false {
            stackBuy.isHidden = false
            stackSeeAll.isHidden = true
            if arrWallet?.address == "" {
                viewWalletAddress.isHidden = true
                viewCreateWallet.isHidden = false
                lblTopupAddress.isHidden = true
               
               // tbvHistory.isHidden = true
                // lblTransactionsHistory.isHidden = true
            } else {
                viewWalletAddress.isHidden = false
                viewCreateWallet.isHidden = true
                lblTopupAddress.isHidden = false
                lblWalletAddress.text = arrWallet?.address
               
                // tbvHistory.isHidden = false
                // lblTransactionsHistory.isHidden = false
            }
        } else {
            viewCreateWallet.isHidden = true
            viewWalletAddress.isHidden = true
            lblTopupAddress.isHidden = true
            lblWalletAddress.isHidden = true
            stackSeeAll.isHidden = true
            stackBuy.isHidden = true
        }
        
        getHistory()
        /// Table Register
        tableRegister()
        let text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.seeAll, comment: "")
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))

        lblSeeAll.attributedText = attributedString
        lblSeeAll.addTapGesture {
            HapticFeedback.generate(.light)
            let walletVC = TokenAllViewController()
//            walletVC.isFrom = "dashboard"
            walletVC.arrWallet = self.arrWallet
            walletVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(walletVC, animated: true)
        }
//        if arrWallet?.address == "" {
//            viewWalletAddress.isHidden = true
//            viewCreateWallet.isHidden = false
//            lblTopupAddress.isHidden = true
//           // tbvHistory.isHidden = true
//            // lblTransactionsHistory.isHidden = true
//        } else {
//            viewWalletAddress.isHidden = false
//            viewCreateWallet.isHidden = true
//            lblTopupAddress.isHidden = false
//            lblWalletAddress.text = arrWallet?.address
//            // tbvHistory.isHidden = false
//            // lblTransactionsHistory.isHidden = false
//        }
       
        uiSetUp()
        
    }
    /// Table Register
    func tableRegister() {
        tbvHistory.delegate = self
        tbvHistory.dataSource = self
        tbvHistory.register(AllTranscationHistryTbvCell.nib, forCellReuseIdentifier: AllTranscationHistryTbvCell.reuseIdentifier)
    }
    @IBAction func btnWalletAddressAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.createWallet()
    }
    
    @IBAction func btnBuyCoinAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        let buyTokenVC = BuyCardDashboardViewController()
//        buyTokenVC.arrWallet = self.arrWallet
//        self.navigationController?.pushViewController(buyTokenVC, animated: true)
        let buyTokenVC = AddCardFundViewController()
        buyTokenVC.hidesBottomBarWhenPushed = true
        buyTokenVC.arrWallet = self.arrWallet
        buyTokenVC.isFromDashboard = true
        self.navigationController?.pushViewController(buyTokenVC, animated: true)
    }
    
    @IBAction func btnBuyAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        let buyTokenVC = BuyCardDashboardViewController()
//        buyTokenVC.arrWallet = self.arrWallet
//        self.navigationController?.pushViewController(buyTokenVC, animated: true)
        let buyTokenVC = AddCardFundViewController()
        buyTokenVC.hidesBottomBarWhenPushed = true
        buyTokenVC.arrWallet = self.arrWallet
        buyTokenVC.isFromDashboard = true
        self.navigationController?.pushViewController(buyTokenVC, animated: true)
            
    }
    
    @IBAction func btnScanAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let receiveVC = CardReceiveViewController()
        receiveVC.hidesBottomBarWhenPushed = true
        receiveVC.walletArr = self.arrWallet
        receiveVC.walletAddress = self.lblWalletAddress.text ?? ""
        receiveVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(receiveVC, animated: true)

    }
    
    @IBAction func btnWithdrawAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let withdrawTokenVC = WithdrowViewController()
        withdrawTokenVC.hidesBottomBarWhenPushed = true
        withdrawTokenVC.arrWallet = self.arrWallet
        withdrawTokenVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(withdrawTokenVC, animated: true)
    }
    
    @IBAction func btnCopyAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        UIPasteboard.general.string = self.lblWalletAddress.text
        self.showToast(message: "\(StringConstants.copied): \(self.lblWalletAddress.text ?? "")", font: AppFont.regular(15).value)
    }
    @IBAction func btnSendAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let sendTokenVC = SendCardTokenViewController()
        sendTokenVC.hidesBottomBarWhenPushed = true
        sendTokenVC.arrWallet = self.arrWallet
        self.navigationController?.pushViewController(sendTokenVC, animated: true)
    }
    
    @IBAction func btnExchangeAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let exchangeTokenVC = ExchangeCardViewController()
        exchangeTokenVC.hidesBottomBarWhenPushed = true
        exchangeTokenVC.arrWallet = self.arrWallet
        self.navigationController?.pushViewController(exchangeTokenVC, animated: true)
    }
    func organizeChatMessagesByDate(with transactions: [SingleTransactionHistry]) {
        let dateFormatter = DateFormatter()
      //  dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
       
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let calendar = Calendar.current
        var sections = [SingleTransactionHistrySection]()
       
        for transaction in transactions {
            var updatedTransaction = transaction
           // updatedTransaction.type = determineOperationType(for: transaction)
           // updatedTransaction.title = determineTitle(for: transaction)
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
}
extension TokenDashboardViewController {
    
    func createWallet() {
        if let currency = arrWallet?.currency {
            selectedTokenArray.append(currency)
        }
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.createWalletAPI(currencies: self.selectedTokenArray) { status, msg, data in
            DispatchQueue.main.async {
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletAddressCreate, comment: ""), font: AppFont.regular(15).value)
                
                self.newWallets = data ?? []
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.viewWalletAddress.isHidden = false
                    self.viewCreateWallet.isHidden = true
                    self.lblTopupAddress.isHidden = false
                    self.lblWalletAddress.text = self.newWallets.first?.address
                    self.tbvHistory.isHidden = false
                    self.stackSeeAll.isHidden = false
                    
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshToken"), object: nil)
                }
                //self.navigationController?.popViewController(animated: true)
            } else {
                DGProgressView.shared.hideLoader()
                self.tbvHistory.isHidden = true
                self.stackSeeAll.isHidden = true
                self.showToast(message: "Something went wrong! Please Try again", font: AppFont.regular(15).value)
            }
            }
        }
    }
    func getHistory() {
//        DGProgressView.shared.showLoader(to: view)
        self.tbvHistory.showLoader()
//        if let currency = arrWallet?.currency {
//            selectedTokenArray.append(currency)
//        }
        guard let currency = arrWallet?.currency else {
            return
        }
        viewModel.getSingleWalletHistoryAPI(currencyFilter: currency) { status, msg, data in
                if status == 1 {
//                    DGProgressView.shared.hideLoader()
                    self.tbvHistory.hideLoader()
                    self.transactionData = data ?? []
                    
                    DispatchQueue.main.async {
                        if (self.transactionData.isEmpty) {
                            self.tbvHistory.isHidden = false
                            self.lblSeeAll.isHidden = true
                            self.stackSeeAll.isHidden = true
                          //  self.tbvHistory.setEmptyMessage("No history", font: AppFont.regular(15).value, textColor: UIColor.label)
                            self.tbvHistory.reloadData()
                             self.tbvHistory.restore()
                        } else {
                            self.organizeChatMessagesByDate(with: data ?? [])
                            self.lblSeeAll.isHidden = false
                            self.tbvHistory.isHidden = false
                            self.stackSeeAll.isHidden = false
                            self.tbvHistory.reloadData()
                            self.tbvHistory.restore()
                        }
                    }
                } else {
//                    DGProgressView.shared.hideLoader()
                    DispatchQueue.main.async {
                        self.tbvHistory.hideLoader()
                        self.tbvHistory.isHidden = true
                        self.lblTransactionsHistory.isHidden = true
                     //   self.showToast(message: msg, font: AppFont.regular(15).value)
                    }
                }
        }
    }
}
