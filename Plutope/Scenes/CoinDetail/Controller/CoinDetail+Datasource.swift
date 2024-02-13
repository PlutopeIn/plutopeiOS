//
//  CoinDetail+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//
import UIKit
import BigInt
extension CoinDetailViewController: UITableViewDataSource {
    
    //    func decryptTransferInput(input: String,methodID: String) -> (String, BigInt)? {
    //        guard input.count == 138 else { return nil } // Invalid input length
    //
    //        let methodId = String(input.prefix(10))
    //        guard methodId == methodID else { return nil } // Input does not correspond to the transfer method
    //
    //        let recipientAddress = "0x" + String(input.dropFirst(34).prefix(40))
    //        guard let transferValue = BigInt(input.dropFirst(74), radix: 16) else { return nil }
    //
    //        return (recipientAddress, transferValue)
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrTransactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvTransactions.dequeueReusableCell(indexPath: indexPath) as TransactionViewCell
        let data = arrTransactionData[indexPath.row]
        cell.selectionStyle = .none
        
        guard let number = Double(data.amount ?? "") else { return UITableViewCell() }
        let multiplier = 10000.0
        let truncatedValue = trunc(number * multiplier) / multiplier
        let amount = WalletData.shared.formatDecimalString("\(truncatedValue)", decimalPlaces: 4)
      //  let amount = String(format: "%.4f", truncatedValue)
        if data.from?.lowercased() == self.coinDetail?.chain?.walletAddress?.lowercased() {
            
            cell.lblPrice.text = "-\(amount) \(coinDetail?.symbol ?? "")"
            cell.lblPrice.textColor = .red
            cell.lblDescription.text = data.to
            cell.ivTansaction.image = UIImage.icTransaction2
        } else {
            
            cell.lblPrice.text = "+\(amount) \(coinDetail?.symbol ?? "")"
            cell.lblPrice.textColor = UIColor.c099817
            cell.lblDescription.text = data.from
            cell.ivTansaction.image = UIImage.icTransaction1
        }
        if let timeStamp = TimeInterval(data.transactionTime ?? "") {
            let unixTimeStamp = (timeStamp / 1000.0).getReadableDate()
            cell.lblDuration.text = unixTimeStamp ?? ""
        }
        if data.isSwap ?? false {
            
            cell.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
        } else {
            if data.methodID == "" && data.isToContract ?? false {
               
                cell.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfer, comment: "")
            } else {
                 if (Double(amount) ?? 0.0) <= 0 && coinDetail?.address == "" {
                     cell.lblTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.samartcontractcall, comment: "")
                    cell.lblPrice.text = "-0.00 \(coinDetail?.symbol ?? "")"
                    cell.lblPrice.textColor = .red
                    cell.lblDescription.text = data.to
                    cell.ivTansaction.image = UIImage.transaction
                } else {
                  
                    cell.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfer, comment: "")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.constantTbvHeight.constant = tbvTransactions.contentSize.height
    }
}
