//
//  CardTransactionHistoryDetailController.swift
//  Plutope
//
//  Created by Sonoma on 28/08/24.
//

import UIKit

class CardTransactionHistoryDetailController: UIViewController {
    
    @IBOutlet weak var headerVieww: UIView!
    @IBOutlet weak var lblOperationDate: UILabel!
    @IBOutlet weak var lblOperationDateTitle: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountTitle: UILabel!
    
    @IBOutlet weak var lblExchangerate: UILabel!
    @IBOutlet weak var lblExchangerateTitle: UILabel!
    
    var sign = ""
    var rate = ""
    var titles = ""
    var allTransactionData : CardHistoryListNew?
     func transactionData() {
         if allTransactionData?.topUpCardModel != nil {
             self.sign = "+"
             if let creditAmount = self.allTransactionData?.topUpCardModel?.amount?.value {
                 let creditAmountValue: Double = {
                     switch creditAmount {
                     case .int(let value):
                         return Double(value)
                     case .double(let value):
                         return value
                     }
                 }()
                 self.lblAmount.text = "\(self.sign) \(creditAmountValue) \(self.allTransactionData?.topUpCardModel?.amount?.currency ?? "")"
                 self.lblOperationDate.text = self.allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy", timeZone: nil).0
             }
         } else if allTransactionData?.reapClearedTransactionModel != nil {
             self.sign = "-"
             if let creditAmount = self.allTransactionData?.reapClearedTransactionModel?.amount?.value {
                 let creditAmountValue: Double = {
                     switch creditAmount {
                     case .int(let value):
                         return Double(value)
                     case .double(let value):
                         return value
                     }
                 }()
                 self.lblAmount.text = "\(self.sign) \(creditAmountValue) \(self.allTransactionData?.reapClearedTransactionModel?.amount?.currency ?? "")"
         }
//         else if allTransactionData?.type == "reapAuthTransactionModel" {
//             self.sign = "-"
//         }
         else {
             self.sign = "-"
         }
           
             self.lblOperationDate.text = self.allTransactionData?.operationDate?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "dd MMM yyyy", timeZone: nil).0
         } else {
             self.lblAmount.text = "0"
         }
         if let rate = allTransactionData?.topUpCardModel?.exchangeRate?.rate {
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
         let exchnagerate = "1 \(allTransactionData?.topUpCardModel?.exchangeRate?.sourceCurrency ?? "") = \(self.rate) \(allTransactionData?.topUpCardModel?.exchangeRate?.targetCurrency ?? "")"
         self.lblExchangerate.text = "\(exchnagerate)"
    }

    fileprivate func uiSetup() {
        lblOperationDate.font = AppFont.regular(14).value
        lblOperationDateTitle.font = AppFont.regular(14).value
        lblAmount.font = AppFont.regular(14).value
        lblAmountTitle.font = AppFont.regular(14).value
        lblExchangerate.font = AppFont.regular(14).value
        lblExchangerateTitle.font = AppFont.regular(14).value
        lblOperationDateTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.operationDate, comment: "")
        lblAmountTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.amount, comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineHeader(headerView: headerVieww, titleText: self.titles, btnBackHidden: false)
        uiSetup()
        transactionData()
    }
    
    func exchangeModel() {
        lblExchangerate.isHidden = false
        lblExchangerateTitle.isHidden = false
        lblAmount.isHidden = true
        lblAmountTitle.isHidden = true
    }
}
