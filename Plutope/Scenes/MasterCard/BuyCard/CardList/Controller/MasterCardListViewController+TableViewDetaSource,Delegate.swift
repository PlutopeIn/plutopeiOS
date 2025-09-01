//
//  MasterCardListViewController+TableViewDetaSource,Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 18/06/24.
//

import Foundation
import UIKit
// MARK: - UITableViewDelegate methods
extension MasterCardListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvCards.cellForRow(at: indexPath) as? MyCardTableViewCell
        if isFrom == "buyCrypto" {
            var balance = ""
            let data = arrCardList[indexPath.row]
            var img = ""
            var color = UIColor()
           let cardNo = showLastFourDigits(of: data.maskedPan ?? "")
            
            cell?.imgSelection.isHidden = false
            
            if data.cardType == "VISA" {
                img = "visa"
                color = UIColor.c2B5AF3
            } else {
                img = "ic_masterCard"
                color = UIColor.clear
            }
            self.dismiss(animated: true) {
                self.cardDelegate?.selectedCard(cardNumber: cardNo, cardType: data.cardType ?? "", tokenimage: img,cardId: "\(data.cardID ?? 0)",cardFullNo:data.maskedPan ?? "", cardBackground: color)
                //self.navigationController?.popViewController(animated: false)
            }
            
        } else {
            
            var balance = ""
            let data = arrPayOutCardList[indexPath.row]
            var img = ""
           let cardNo = showLastFourDigits(of: data.maskedPan ?? "")
//            if data.cardType == "VISA" {
//                img = "ic_visa"
//            } else {
//                img = "ic_masterCard"
//            }
            cell?.imgSelection.isHidden = false
            self.dismiss(animated: true) {
                self.cardDelegate?.selectedCard(cardNumber: cardNo, cardType: "", tokenimage: "visa",cardId: "\(data.cardID ?? 0)",cardFullNo:data.maskedPan ?? "", cardBackground: UIColor.c2B5AF3)
                //self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tbvCards.cellForRow(at: indexPath) as? MyCardTableViewCell
        if isFrom == "buyCrypto" {
            cell?.imgSelection.isHidden = true
        } else {
            cell?.imgSelection.isHidden = true
        }
    }
}
// MARK: - UITableViewDataSource methods
extension MasterCardListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFrom == "buyCrypto" {
            return arrCardList.count
        } else {
            return arrPayOutCardList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvCards.dequeueReusableCell(indexPath: indexPath) as MyCardTableViewCell
        cell.imgSelection.isHidden = false
        cell.selectionStyle = .none
//        cell.viewCard.isHidden = true
        cell.viewCard.isHidden = false
        cell.ivCard.isHidden = true
        if isFrom == "buyCrypto" || isFrom == "withdrawCrypto"  {
           // cell.btnCancel.isHidden = true
            cell.circularProgress.isHidden = true
            cell.lblFreeze.isHidden = true
        }
        if isFrom == "buyCrypto"  {
            
            let data = arrCardList[indexPath.row]
            var cardNumber = ""
            if data.maskedPan == "" || data.maskedPan?.isEmpty ?? false {
                cardNumber = "-"
            } else {
                cardNumber = showLastFourDigits(of: data.maskedPan ?? "")
            }
            cell.lblToken.text = cardNumber
            
            if self.cardName == cardNumber {
                cell.imgSelection.isHidden = false
            } else {
                cell.imgSelection.isHidden = true
            }
            
            if data.cardType == "VISA" {
                cell.viewCard.backgroundColor = UIColor.c2B5AF3
                cell.ivCardCompany.image = UIImage(named: "visa")
            } else {
                cell.viewCard.backgroundColor = UIColor.clear
                cell.ivCardCompany.image = UIImage(named: "ic_masterCard1")
            }
            cell.lblTokkenAddress.text = data.cardType
        } else {
            let data = arrPayOutCardList[indexPath.row]
            var cardNumber = ""
            if data.maskedPan == "" || data.maskedPan?.isEmpty ?? false {
                cardNumber = "-"
            } else {
                cardNumber = showLastFourDigits(of: data.maskedPan ?? "")
            }
            cell.lblToken.text = cardNumber
            
            if self.cardName == cardNumber {
                cell.imgSelection.isHidden = false
            } else {
                cell.imgSelection.isHidden = true
            }
            
           // if data.cardType == "VISA" {
            cell.viewCard.backgroundColor = UIColor.c2B5AF3
            cell.ivCardCompany.image = UIImage(named: "visa")
           // } else {
               // cell.ivCard.image = UIImage(named: "ic_masterCard")
           // }
            cell.lblTokkenAddress.text = "VISA"//"data.cardType"
        }
        
//        cell.lblToken.text = "\(self.cardPrice) \(data.balance?.currency ?? "")"
     
//        cell.cardRequestId = data.cardRequestID
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.constHeightCardsTable.constant = self.tbvCards.contentSize.height
    }
    
}
