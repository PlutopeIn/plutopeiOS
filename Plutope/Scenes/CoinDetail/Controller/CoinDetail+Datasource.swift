//
//  CoinDetail+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//
import UIKit
import BigInt
extension CoinDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegment == "Transaction" {
            return arrTransactionNewData.count
        } else {
            return  0  // internalTransactions.count
        }
    }
     func setData(_ indexPath: IndexPath, _ amount: inout String, _ cell: TransactionViewCell) {
        let data = arrTransactionNewData[indexPath.row]
         // Convert Wei to Ether and format amount string
         
         var localAmount = amount
         self.coinDetail?.callFunction.getDecimal(completion: {
              decimal in
         print("decimalValue",decimal ?? 0.0)
         var decimalAmount = decimal ?? ""
         let number: Int64? = Int64(decimalAmount)
         let amountToGet = UnitConverter.convertWeiToEther(data.value ?? "",Int(number ?? 0)) ?? ""
             localAmount = WalletData.shared.formatDecimalString("\(amountToGet)", decimalPlaces: 10)
        })

        
         let input = data.fromAddress?.lowercased()
         if data.receiptStatus == "0" {
            cell.lblStatus.isHidden = false
        } else {
            cell.lblStatus.isHidden = true
        }
       
         let firstValue = input?.split(separator: ",").first.map { String($0) } ?? ""
         print("firstValue = ",firstValue)
         
         
         if self.coinDetail?.address != "" {
             print("coindetail = ",self.coinDetail?.name)
             
             let walletAddress = self.coinDetail?.chain?.walletAddress?.lowercased()
                      
             let isSender = firstValue == walletAddress
             cell.lblDescription.text = isSender ? data.toAddress : data.fromAddress
             let rawFormattedValue = data.formattedValue?.stringValue ?? "0"
             
             print("rawFormattedValue = ", rawFormattedValue)
             let trimmedRaw = rawFormattedValue.trimmingCharacters(in: .whitespacesAndNewlines)

             // Keep sign info
             let isPositive = trimmedRaw.hasPrefix("+")
             let isNegative = trimmedRaw.hasPrefix("-")

             // Remove + or - for formatting
             let rawValueWithoutSign = trimmedRaw.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")

            

             // Add back sign for display
             let formatedValue = isNegative ? "-\(rawValueWithoutSign)" : isPositive ? "+\(rawValueWithoutSign)" : rawValueWithoutSign
             let formatted = WalletData.shared.formatDecimalString(formatedValue, decimalPlaces: 10)
             print("formatedValue = ", formatedValue)
             cell.lblPrice.text = "\(formatedValue) \(coinDetail?.symbol ?? "")"

             // Apply color based on sign
             if isPositive {
                 cell.lblPrice.textColor = UIColor.c099817
                 cell.ivTansaction.image = data.type == "Swap" ? UIImage(named: "ic_TransactionSwap") : UIImage.icTransaction1
             } else {
                 cell.lblPrice.textColor = .red
                 cell.ivTansaction.image = data.type == "Swap" ? UIImage(named: "ic_TransactionSwap") : UIImage.icTransaction2
             }

             
         } else {
             print("coindetail Chain= ",self.coinDetail?.name)
             if data.fromAddress?.lowercased() == self.coinDetail?.chain?.walletAddress?.lowercased() && data.toAddress?.lowercased() != self.coinDetail?.chain?.walletAddress?.lowercased() {
                 
                 if self.coinDetail?.symbol?.lowercased() != "btc" {
                     cell.lblPrice.text = "-\(localAmount) \(coinDetail?.symbol ?? "")"
                     cell.priceSsymbol = "-"
                 } else {
                     cell.lblPrice.text = " \(localAmount) \(coinDetail?.symbol ?? "")"
                     cell.priceSsymbol = ""
                 }
                 cell.lblPrice.textColor = .red
                 cell.lblDescription.text = data.toAddress
                 cell.ivTansaction.image = UIImage.icTransaction2
               
             } else {
                 if self.coinDetail?.symbol?.lowercased() != "btc" {
                     cell.lblPrice.text = "+\(localAmount) \(coinDetail?.symbol ?? "")"
                     cell.priceSsymbol = "+"
                     cell.lblPrice.textColor = UIColor.c099817
                     cell.lblDescription.text = data.fromAddress
                     cell.ivTansaction.image = UIImage.icTransaction1
                 } else {
                     cell.lblPrice.text = "+\(localAmount) \(coinDetail?.symbol ?? "")"
                     cell.priceSsymbol = "+"
                     cell.lblPrice.textColor = UIColor.c099817
                     cell.lblDescription.text = data.fromAddress
                     cell.ivTansaction.image = UIImage.icTransaction1
                 }
             }
         }
         if data.type == "Swap" {
             cell.ivTansaction.image = UIImage(named: "ic_TransactionSwap")
         } else if data.type == "Smart Contract" {
             cell.ivTansaction.image = UIImage.transaction
         } else if data.type == "approve" {
             cell.ivTansaction.image = UIImage.transaction
         }
         // Format date string
         if let isoDateString = data.timestamp {
             let isoFormatter = ISO8601DateFormatter()
             isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

             if let date = isoFormatter.date(from: isoDateString) {
                 cell.lblDuration.text = date.timeIntervalSince1970.getReadableDate() ?? ""
             } else {
                 cell.lblDuration.text = ""
             }
         } else {
             cell.lblDuration.text = ""
         }
         
         cell.lblTitle.text = data.type?.capitalizingFirstLetter()
         cell.headerTitle = data.type?.capitalizingFirstLetter() ?? ""
         
    }
    
   
    func convertScientificToDouble(scientificNotationString: String) -> Double? {
        // Create a NumberFormatter instance
        let formatter = NumberFormatter()

        // Set the number style to scientific
        formatter.numberStyle = .scientific

        // Convert the scientific notation string to a number
        if let number = formatter.number(from: scientificNotationString) {
            // Convert the number to a Double
            return number.doubleValue
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvTransactions.dequeueReusableCell(indexPath: indexPath) as TransactionViewCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        cell.viewTransactionIV.RoundMe(Radius: cell.viewTransactionIV.frame.height / 2)
        var amount = ""
        cell.lblTitle.font = AppFont.violetRegular(12).value
        if selectedSegment == "Transaction" {
            setData(indexPath, &amount, cell)
        } else {
//            setInternalData(indexPath, &amount, cell)
          }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // DispatchQueue.main.async {
            self.view.layoutIfNeeded()
                self.constantTbvHeight.constant = self.tbvTransactions.contentSize.height
                // Ensure smooth UI updates
          //  }
        
    }

}
// MARK: Collection view delegate method
extension CoinDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return transctionsValueArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = clvActions.dequeueReusableCell(indexPath: indexPath) as WalletDashboardCell
            let data = transctionsValueArr[indexPath.row]
            cell.ivIcon.image = data.image
            cell.lblName.textColor = UIColor.label
            cell.lblName.text = data.name
            cell.lblName.font = AppFont.regular(9.76).value
            
            return cell
        
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if  coinDetail?.tokenId == "PLT".lowercased() {
            return CGSize(width: (screenWidth - 40) / 2, height: 63)
        } else {
            return CGSize(width: (screenWidth - 40) / 5, height: 63)
        }
        
    }
    
 }
