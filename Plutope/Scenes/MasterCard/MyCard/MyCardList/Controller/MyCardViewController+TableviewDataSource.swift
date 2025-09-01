//
//  MyCardViewController+TableviewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import Foundation
import UIKit
// MARK: - UITableViewDelegate methods
extension MyCardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
       // let cell = tbvCard.cellForRow(at: indexPath) as? MyCardTableViewCell
        if isFrom == "topupVC" {
            var balance = ""
            let data = arrCardList[indexPath.row]
            if let price = data.balance?.value {
                           let priceValue: Double = {
                               switch price {
                               case .int(let value):
                                   return Double(value)
                               case .double(let value):
                                   return value
                               }
                           }()
                balance = "\(priceValue)"
                       } else {
                           balance = "0"
                       }
           let cardNo =  showLastFourDigits(of: data.number ?? "")
            self.dismiss(animated: true) {
                self.carddelegate?.selectedCard(tokenName: cardNo, tokenbalance: WalletData.shared.formatDecimalString(balance, decimalPlaces: 3), tokenAmount: "", tokenCurruncy: data.balance?.currency ?? "",cardDesignId:data.cardDesignID ?? "",cardType: data.cardCompany ?? "")
            }
        } else {
           
        }
    }
}
// MARK: - UITableViewDataSource methods
extension MyCardViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return arrCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvCard.dequeueReusableCell(indexPath: indexPath) as MyCardTableViewCell
        let data = arrCardList[indexPath.row]
        cell.selectionStyle = .none
        cell.ivCard.isHidden = true
        if data.cardCompany == "VISA" {
            cell.ivCardCompany.image = UIImage(named: "visa")
        } else {
            cell.ivCardCompany.image = UIImage(named: "ic_masterCard1")
        }
        if data.cardDesignID == "BLUE" {
            cell.viewCard.backgroundColor = UIColor.c2B5AF3
        } else if data.cardDesignID == "ORANGE" {
            cell.viewCard.backgroundColor = UIColor.cffa500
        } else if data.cardDesignID == "BLACK" {
            cell.viewCard.backgroundColor = UIColor.black
        } else if data.cardDesignID == "GOLD" {
            cell.viewCard.backgroundColor = UIColor.cCBB28B
        } else if data.cardDesignID == "PURPLE" {
            cell.viewCard.backgroundColor = UIColor.c800080
        }
        cell.lblFreeze.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.frozon, comment: "")
        if isFrom == "topupVC" {
           // cell.btnCancel.isHidden = true
           // cell.circularProgress.isHidden = true
            cell.lblFreeze.isHidden = true
        }
        if let price = data.balance?.value {
                       let priceValue: Double = {
                           switch price {
                           case .int(let value):
                               return Double(value)
                           case .double(let value):
                               return value
                           }
                       }()
                  self.cardPrice = "\(priceValue)"
                   } else {
                       self.cardPrice = "0"
                   }
        cell.lblToken.text = "\(self.cardPrice) \(data.balance?.currency ?? "")"
        var cardNumber = ""
        if data.number == "" || data.number?.isEmpty ?? false {
            cardNumber = "-"
        } else {
            cardNumber = showLastFourDigits(of: data.number ?? "")
        }
        cell.lblTokkenAddress.text = cardNumber
        cell.cardRequestId = data.cardRequestID
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}
