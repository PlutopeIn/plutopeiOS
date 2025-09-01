//
//  Providers+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import SDWebImage
extension SwapProvidersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        swapArrProviderList.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvProviders.dequeueReusableCell(withIdentifier: SwapProvidersViewCell.reuseIdentifier) as? SwapProvidersViewCell else { return UITableViewCell() }
        let data = swapArrProviderList[indexPath.row]
       //DGProgressView.shared.showLoader(to: view)
        cell.selectionStyle = .none
       cell.lblDiffrence.font = AppFont.regular(12).value
       cell.lblBestPrice.font = AppFont.regular(12).value
       cell.lblProviderName.font = AppFont.regular(12).value
       cell.lblSwapperFee.font = AppFont.regular(12).value
       
       DispatchQueue.main.async {
           var formattedPrice = ""
           if data.providerName == "rangoexchange" {
               let semaphore = DispatchSemaphore(value: 0)
               self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                   print("decimal",decimal ?? 0.0)
                   let decimalAmount = decimal ?? ""
                   let number: Int64? = Int64(decimalAmount)
                   let amountToGet = UnitConverter.convertWeiToEther(data.quoteAmount ?? "",Int(number ?? 18)) ?? ""
                   formattedPrice = WalletData.shared.formatDecimalString("\(amountToGet)", decimalPlaces: 12)
                   semaphore.signal()
                   DispatchQueue.main.async {
                       cell.lblBestPrice.text = "\(formattedPrice)"
                       cell.quotAmount = formattedPrice
                   }
                 //  DGProgressView.shared.hideLoader()
                   semaphore.wait()
              })
              
           } else {
              let bestamount = WalletData.shared.formatDecimalString("\(data.quoteAmount ?? "")", decimalPlaces: 12)
               cell.quotAmount = bestamount
               cell.lblBestPrice.text = "\(bestamount)"
           }
           
           let imgUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion+ServiceNameConstant.BaseUrl.images + (data.image ?? "")
           cell.ivProvider.sd_setImage(with: URL(string: imgUrl))
           cell.lblProviderName.text = data.name
           if indexPath.row == 0 {
               cell.lblDiffrence.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.best, comment: "")
               cell.lblDiffrence.isHidden = false
               cell.lblDiffrence.textColor = UIColor.green
           } else {
               cell.lblDiffrence.isHidden = true
           }
       }
//        let maxFormattedPrice = swapArrProviderList.map { Double($0.quoteAmount ?? "") ?? 0.0 }.max() ?? 0.0
//
//        // Calculate the percentage difference
//        let percentageDifference = maxFormattedPrice != 0.0 ? ((Double(data.quoteAmount ?? "") ?? 0.0) / maxFormattedPrice - 1.0) * 100 : 0.0
//        // Display the percentage difference in the current cell's label
//            if percentageDifference == 0.00 {
//                cell.lblDiffrence.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.best, comment: "")
//                cell.lblDiffrence.textColor = UIColor.green
//            } else {
//                cell.lblDiffrence.text = String(format: "%.2f%%", percentageDifference)
//                cell.lblDiffrence.textColor = UIColor.red
//            }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.tbvHeight.constant = tbvProviders.contentSize.height
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
