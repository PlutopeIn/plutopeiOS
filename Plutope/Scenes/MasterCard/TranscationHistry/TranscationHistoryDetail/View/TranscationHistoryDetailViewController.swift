//
//  TranscationHistoryDetailViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import UIKit

class TranscationHistoryDetailViewController: UIViewController {

    @IBOutlet weak var headerVieww: UIView!
    
    @IBOutlet weak var ivFromCards: UIImageView!
    @IBOutlet weak var ivFromCopy: UIImageView!
    @IBOutlet weak var ivToCards: UIImageView!
    @IBOutlet weak var ivToCopy: UIImageView!
    @IBOutlet weak var lblOperationDate: UILabel!
    @IBOutlet weak var lblOperationDateTitle: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountTitle: UILabel!
    
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblFromTitle: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblToTitle: UILabel!
    
    @IBOutlet weak var lblExchangerate: UILabel!
    @IBOutlet weak var lblExchangerateTitle: UILabel!
    
    @IBOutlet weak var lblTotalFee: UILabel!
    @IBOutlet weak var lblTotalFeeTitle: UILabel!
    var rate = ""
    var allTransactionData : AllTransactionHistryDataList?
    var allTransactionDataNew : AllTransactionHistryDataListNewElement?
    let server = serverTypes
    
     func transactionDataLive() {
        if allTransactionDataNew?.type == "payoutCardModel" {
            self.payoutCardModel()
            ivFromCopy.addTapGesture {
                UIPasteboard.general.string = self.lblFrom.text ?? ""
                self.showToast(message: "\(StringConstants.copied): \(self.lblFrom.text ?? "")", font: AppFont.regular(15).value)
            }
        } else if allTransactionDataNew?.type == "payinCardModel" {
            self.payinCardModel()
            ivToCopy.addTapGesture {
                UIPasteboard.general.string = self.lblTo.text ?? ""
                self.showToast(message: "\(StringConstants.copied): \(self.lblTo.text ?? "")", font: AppFont.regular(15).value)
            }
        } else if allTransactionDataNew?.type == "receiveCryptoModel" {
            self.receiveCryptoModel()
            
        } else if allTransactionDataNew?.type == "cardIssueModel" {
            self.cardIssueModel()
        } else if allTransactionDataNew?.type == "sendToWalletModel" {
            self.sendToWalletModel()
        } else if allTransactionDataNew?.type == "sendToPhoneModel" {
            self.sendToPhoneModel()
        } else if allTransactionDataNew?.type == "exchangeModel" {
            self.exchangeModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = allTransactionDataNew?.title ?? ""
        defineHeader(headerView: headerVieww, titleText: title, btnBackHidden: false)
        lblOperationDate.font = AppFont.regular(14).value
        lblAmountTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: "")
        lblOperationDateTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationDate, comment: "")
        lblExchangerateTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exchange, comment: "")
        lblTotalFeeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalFees, comment: "")
        transactionDataLive()

    }
    func exchangeModel() {
        lblExchangerate.isHidden = false
        lblExchangerateTitle.isHidden = false
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        ivToCards.isHidden = true
        lblAmount.isHidden = true
        lblAmountTitle.isHidden = true
             excchnageTranscationLive()
        
    }
    fileprivate func sendToWalletTransaction() {
        self.lblFrom.text = allTransactionData?.sendToWalletModel?.fromAddress
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(allTransactionData?.sendToWalletModel?.creditAmount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let debitAmount = allTransactionData?.sendToWalletModel?.debitAmount?.value {
            let debitAmountFeeValue: Double = {
                switch debitAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblAmount.text = "\(debitAmountFeeValue)"
        } else {
            self.lblAmount.text = "0"
        }
        
        self.lblTo.text = allTransactionData?.toAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionData?.sendToWalletModel?.debitAmount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        if let feeAmount = allTransactionData?.feeAmount {
            let feeAmountValue: Double = {
                switch feeAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblTotalFee.text = "\(feeAmountValue)"
        } else {
            self.lblTotalFee.text = "0"
        }
        self.lblExchangerate.isHidden = true
    }
    
    func sendToWalletModel() {
        lblExchangerate.isHidden = true
        lblExchangerateTitle.isHidden = true
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        ivToCards.isHidden = true
            sendToWalletTransactionLive()
    }
    func sendToPhoneModel() {
           sendToPhoneTransactionLive()
    }
    
    fileprivate func payoutCardTransaction() {
        if allTransactionData?.payoutCardModel?.fromAddress != "" {
            lblFrom.isHidden = false
            lblFromTitle.isHidden = false
            ivFromCopy.isHidden = false
            ivFromCards.isHidden = true
            
        } else {
            lblFrom.isHidden = true
            lblFromTitle.isHidden = true
            ivFromCopy.isHidden = true
            ivFromCards.isHidden = true
        }
        ivToCards.isHidden = false
        self.lblFrom.text = allTransactionData?.payoutCardModel?.fromAddress
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let debitAmount = allTransactionData?.debitAmount {
            let debitAmountFeeValue: Double = {
                switch debitAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblAmount.text = "\(debitAmountFeeValue)"
        } else {
            self.lblAmount.text = "0"
        }
        
        self.lblTo.text = allTransactionData?.toCardPAN
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionData?.payoutCardModel?.creditAmount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        if let feeAmount = allTransactionData?.feeAmount {
            let feeAmountValue: Double = {
                switch feeAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblTotalFee.text = "\(feeAmountValue)"
        } else {
            self.lblTotalFee.text = "0"
        }
        if let rate = allTransactionData?.payoutCardModel?.exchangeRate?.rate {
            let rateValue: Double = {
                switch rate {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.rate = "\(rateValue)"
        } else {
            self.rate = "0"
        }
        let exchnagerate = "1 \(allTransactionData?.payoutCardModel?.exchangeRate?.sourceCurrency ?? "") = \(self.rate) \(allTransactionData?.payoutCardModel?.exchangeRate?.targetCurrency ?? "")"
        self.lblExchangerate.text = "\(exchnagerate)"
    }
    func payoutCardModel() {
            payoutCardTransactionLive()
    }
    fileprivate func payinCardtranscation() {
        if allTransactionData?.payinCardModel?.toAddress != "" {
            lblTo.isHidden = false
            lblToTitle.isHidden = false
            ivToCopy.isHidden = false
            ivToCards.isHidden = true
        } else {
            lblTo.isHidden = true
            lblToTitle.isHidden = true
            ivToCopy.isHidden = true
            ivToCards.isHidden = true
        }
        self.ivFromCards.isHidden =  false
        self.lblTo.text = allTransactionData?.payinCardModel?.toAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let debitAmount = allTransactionData?.creditAmount {
            let debitAmountFeeValue: Double = {
                switch debitAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblAmount.text = "\(debitAmountFeeValue)"
        } else {
            self.lblAmount.text = "0"
        }
        self.lblFrom.text = allTransactionData?.fromCardPAN
        self.lblFromTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fromBankCard, comment: "")
        
        if let feeAmount = allTransactionData?.payinCardModel?.feeAmount?.value {
            let feeAmountValue: Double = {
                switch feeAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblTotalFee.text = "\(feeAmountValue)"
        } else {
            self.lblTotalFee.text = "0"
        }
        if let rate = allTransactionData?.payinCardModel?.exchangeRate?.rate {
            let rateValue: Double = {
                switch rate {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.rate = "\(rateValue)"
        } else {
            self.rate = "0"
        }
        let exchnagerate = "1 \(allTransactionData?.payinCardModel?.exchangeRate?.targetCurrency ?? "") = \(self.rate) \(allTransactionData?.payinCardModel?.exchangeRate?.sourceCurrency ?? "")"
        self.lblExchangerate.text = "\(exchnagerate)"
    }
    
    func payinCardModel() {
            payinCardtranscationLive()
    }
    fileprivate func receiveCryptoTranscation() {
        lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let amount = allTransactionData?.amount {
            let amountValue: Double = {
                switch amount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblAmount.text = "\(amountValue)"
        } else {
            self.lblAmount.text = "0"
        }
        self.lblTo.text = allTransactionData?.receiveCryptoModel?.toAddress
        self.lblToTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
        self.lblFrom.text = allTransactionData?.receiveCryptoModel?.fromAddress
        self.lblFromTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        lblExchangerate.isHidden = true
        lblExchangerateTitle.isHidden = true
    }
    
    func receiveCryptoModel() {
            receiveCryptoTranscationLive()
    }
    fileprivate func cardIssueTranscation() {
        lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let amount = allTransactionData?.cardIssueModel?.amount?.value {
            let amountValue: Double = {
                switch amount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            self.lblAmount.text = "\(amountValue)"
        } else {
            self.lblAmount.text = "0"
        }
        self.lblTo.isHidden = true
        self.lblToTitle.isHidden = true
        self.lblFrom.text = allTransactionData?.cardIssueModel?.fromAddress
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(allTransactionData?.cardIssueModel?.amount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        lblExchangerate.isHidden = true
        lblExchangerateTitle.isHidden = true
    }
    func cardIssueModel() {
            cardIssueTranscationLive()
    }
}
