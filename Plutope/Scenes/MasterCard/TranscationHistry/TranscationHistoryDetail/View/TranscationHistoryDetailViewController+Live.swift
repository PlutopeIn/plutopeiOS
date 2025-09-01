//
//  TranscationHistoryDetailViewController+Live.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/07/24.
//

import UIKit
extension TranscationHistoryDetailViewController {
     func excchnageTranscation() {
        if let rate = allTransactionData?.exchangeModel?.exchangeRate?.rate {
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
        let exchnagerate = "1 \(allTransactionData?.exchangeModel?.exchangeRate?.sourceCurrency ?? "") = \(self.rate) \(allTransactionData?.exchangeModel?.exchangeRate?.targetCurrency ?? "")"
        self.lblExchangerate.text = "\(exchnagerate)"
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(allTransactionData?.exchangeModel?.creditAmount?.currency ?? "")"
        lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        
        //        self.lblTo.text = allTransactionData?.toAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionData?.exchangeModel?.debitAmount?.currency ?? "") "
        if let debitAmount = allTransactionData?.exchangeModel?.debitAmount?.value {
            let debitAmountValue: Double = {
                switch debitAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(debitAmountValue)", decimalPlaces: 6)
            self.lblTo.text = "\(balance) \(allTransactionData?.exchangeModel?.debitAmount?.currency ?? "")"
        } else {
            self.lblTo.text = "0"
        }
        if let craditAmount = allTransactionData?.exchangeModel?.creditAmount?.value {
            let craditAmountValue: Double = {
                switch craditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(craditAmountValue)", decimalPlaces: 6)
            self.lblFrom.text = "\(balance) \(allTransactionData?.exchangeModel?.creditAmount?.currency ?? "")"
        } else {
            self.lblFrom.text = "0"
        }
    }
     func excchnageTranscationLive() {
        if let rate = allTransactionDataNew?.exchangeModel?.exchangeRate?.rate {
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
        let exchnagerate = "1 \(allTransactionDataNew?.exchangeModel?.exchangeRate?.sourceCurrency ?? "") = \(self.rate) \(allTransactionDataNew?.exchangeModel?.exchangeRate?.targetCurrency ?? "")"
        self.lblExchangerate.text = "\(exchnagerate)"
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(allTransactionDataNew?.exchangeModel?.creditAmount?.currency ?? "")"
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        
        //        self.lblTo.text = allTransactionData?.toAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionDataNew?.exchangeModel?.debitAmount?.currency ?? "") "
        if let debitAmount = allTransactionDataNew?.exchangeModel?.debitAmount?.value {
            let debitAmountValue: Double = {
                switch debitAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(debitAmountValue)", decimalPlaces: 6)
            self.lblTo.text = "\(balance) \(allTransactionDataNew?.exchangeModel?.debitAmount?.currency ?? "")"
        } else {
            self.lblTo.text = "0"
        }
        if let craditAmount = allTransactionDataNew?.exchangeModel?.creditAmount?.value {
            let craditAmountValue: Double = {
                switch craditAmount {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            let balance = WalletData.shared.formatDecimalString("\(craditAmountValue)", decimalPlaces: 6)
            self.lblFrom.text = "\(balance) \(allTransactionDataNew?.exchangeModel?.creditAmount?.currency ?? "")"
        } else {
            self.lblFrom.text = "0"
        }
    }
    func sendToPhoneTransaction() {
       lblTotalFee.isHidden = true
       lblTotalFeeTitle.isHidden = true
       lblExchangerate.isHidden = true
       lblExchangerateTitle.isHidden = true
       self.lblFrom.text = allTransactionData?.sendToPhoneModel?.toPhone
       self.lblFromTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fromPhone, comment: "")
       lblOperationDate.text = allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
       if let debitAmount = allTransactionData?.sendToPhoneModel?.amount?.value {
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
       self.lblTo.text = allTransactionData?.sendToPhoneModel?.fromAddress
       self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionData?.sendToPhoneModel?.amount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
   }
     func sendToWalletTransactionLive() {
        self.lblFrom.text = allTransactionDataNew?.sendToWalletModel?.fromAddress
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(allTransactionDataNew?.sendToWalletModel?.creditAmount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let debitAmount = allTransactionDataNew?.sendToWalletModel?.debitAmount?.value {
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
        
        self.lblTo.text = allTransactionDataNew?.sendToWalletModel?.toAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionDataNew?.sendToWalletModel?.debitAmount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        if let feeAmount = allTransactionDataNew?.sendToWalletModel?.feeAmount?.value {
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
     func payoutCardTransactionLive() {
        if allTransactionDataNew?.payoutCardModel?.fromAddress != "" {
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
        self.lblFrom.text = allTransactionDataNew?.payoutCardModel?.fromAddress
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
         if let debitAmount = allTransactionDataNew?.payoutCardModel?.debitAmount?.value {
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
        
         self.lblTo.text = allTransactionDataNew?.payoutCardModel?.toCardPAN
        self.lblToTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
         if let feeAmount = allTransactionDataNew?.payoutCardModel?.feeAmount?.value {
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
        if let rate = allTransactionDataNew?.payoutCardModel?.exchangeRate?.rate {
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
        let exchnagerate = "1 \(allTransactionDataNew?.payoutCardModel?.exchangeRate?.sourceCurrency ?? "") = \(self.rate) \(allTransactionDataNew?.payoutCardModel?.exchangeRate?.targetCurrency ?? "")"
        self.lblExchangerate.text = "\(exchnagerate)"
    }
     func sendToPhoneTransactionLive() {
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        lblExchangerate.isHidden = true
        lblExchangerateTitle.isHidden = true
        self.lblFrom.text = allTransactionDataNew?.sendToPhoneModel?.toPhone
        self.lblFromTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fromPhone, comment: "")
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let debitAmount = allTransactionDataNew?.sendToPhoneModel?.amount?.value {
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
        
        self.lblTo.text = allTransactionDataNew?.sendToPhoneModel?.fromAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(allTransactionDataNew?.sendToPhoneModel?.amount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
    }
     func payinCardtranscationLive() {
        if allTransactionDataNew?.payinCardModel?.toAddress != "" {
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
        self.lblTo.text = allTransactionDataNew?.payinCardModel?.toAddress
        self.lblToTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
         if let debitAmount = allTransactionDataNew?.payinCardModel?.creditAmount?.value {
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
         self.lblFrom.text = allTransactionDataNew?.payinCardModel?.fromCardPAN
        self.lblFromTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fromBankCard, comment: "")
        if let feeAmount = allTransactionDataNew?.payinCardModel?.feeAmount?.value {
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
        if let rate = allTransactionDataNew?.payinCardModel?.exchangeRate?.rate {
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
        let exchnagerate = "1 \(allTransactionDataNew?.payinCardModel?.exchangeRate?.targetCurrency ?? "") = \(self.rate) \(allTransactionDataNew?.payinCardModel?.exchangeRate?.sourceCurrency ?? "")"
        self.lblExchangerate.text = "\(exchnagerate)"
    }
     func receiveCryptoTranscationLive() {
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
         if let amount = allTransactionDataNew?.receiveCryptoModel?.amount?.value {
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
        self.lblTo.text = allTransactionDataNew?.receiveCryptoModel?.toAddress
        self.lblToTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
        self.lblFrom.text = allTransactionDataNew?.receiveCryptoModel?.fromAddress
        self.lblFromTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        lblExchangerate.isHidden = true
        lblExchangerateTitle.isHidden = true
    }
     func cardIssueTranscationLive() {
        lblOperationDate.text = allTransactionDataNew?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy HH:mm", timeZone: nil).0
        if let amount = allTransactionDataNew?.cardIssueModel?.amount?.value {
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
        self.lblFrom.text = allTransactionDataNew?.cardIssueModel?.fromAddress
        self.lblFromTitle.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")) \(allTransactionDataNew?.cardIssueModel?.amount?.currency ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: ""))"
        lblTotalFee.isHidden = true
        lblTotalFeeTitle.isHidden = true
        lblExchangerate.isHidden = true
        lblExchangerateTitle.isHidden = true
    }
}
