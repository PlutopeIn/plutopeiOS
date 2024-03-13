//
//  Providers+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension SwapProvidersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrProviderList.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvProviders.dequeueReusableCell(withIdentifier: SwapProvidersViewCell.reuseIdentifier) as? SwapProvidersViewCell else { return UITableViewCell() }
        let data = arrProviderList[indexPath.row]

        cell.selectionStyle = .none
        let bestPriceStringValue = data.bestPrice ?? ""
       
       if let myDouble = Double(bestPriceStringValue) {
           
           if isScientificNotation(bestPriceStringValue) {
               let payDoubleValue = convertScientificToDouble(scientificNotationString: bestPriceStringValue)
               let doubleString = String(format: "%.15f", myDouble)
               cell.lblBestPrice.text = "\(doubleString)"
           } else {
               let doubleString = WalletData.shared.formatDecimalString("\(myDouble)", decimalPlaces: 10)
               cell.lblBestPrice.text = doubleString
           }
         
          // let doubleString = String(format: "%.10f", myDouble) // Format the double to show 5 decimal places
       } else {
           cell.lblBestPrice.text = ""
       }
       if data.name ==  StringConstants.rangoSwap {
           cell.lblProviderName.text = swapperFee
       } else {
           cell.lblProviderName.text = "0"
       }
       
        // Calculate the maximum formattedPrice value
        let maxFormattedPrice = arrProviderList.map { Double($0.bestPrice ?? "") ?? 0.0 }.max() ?? 0.0

        // Calculate the percentage difference
        let percentageDifference = maxFormattedPrice != 0.0 ? ((Double(data.bestPrice ?? "") ?? 0.0) / maxFormattedPrice - 1.0) * 100 : 0.0

        // Display the percentage difference in the current cell's label
    //    cell.lblDiffrence.text = String(format: "%.2f%%", percentageDifference)
        
        // Display the percentage difference in the current cell's label
            if percentageDifference == 0.00 {
                cell.lblDiffrence.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.best, comment: "")
                cell.lblDiffrence.textColor = UIColor.green
            } else {
                cell.lblDiffrence.text = String(format: "%.2f%%", percentageDifference)
                cell.lblDiffrence.textColor = UIColor.red
            }

        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("SwapProvidersView", owner: nil, options: nil)?.first as? SwapProvidersView
        header?.lblSymbol.text = "\(self.fromCurruncySymbol ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receiving, comment: ""))"
        header?.lblOverallvalue.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.overallvalue, comment: "")
        header?.lblSwapperFee.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swapperfee, comment: "")
        
        return header
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func isScientificNotation(_ input: String) -> Bool {
        let scientificNotationRegex = #"[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)"#

        if let range = input.range(of: scientificNotationRegex, options: .regularExpression) {
            return range.lowerBound == input.startIndex && range.upperBound == input.endIndex
        }

        return false
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
    
}
