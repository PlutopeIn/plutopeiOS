//
//  Providers+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension ProvidersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrProviderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvProviders.dequeueReusableCell(withIdentifier: CoinListViewCell.reuseIdentifier) as? CoinListViewCell else { return UITableViewCell() }
        let data = arrProviderList[indexPath.row]
    
        cell.selectionStyle = .none
        cell.lblSymbol.isHidden = true
        cell.lblCoinName?.text = data.name
        cell.ivCoin.image = data.imageUrl
        let formattedPrice = WalletData.shared.formatDecimalString("\(data.bestPrice ?? "")", decimalPlaces: 6)
        
       // let formattedPrice = String(format: "%.6f", Double(data.bestPrice ?? "") ?? 0.0)
        if self.providerType == .buy {
            cell.lblCoinQuantity.text = "\(formattedPrice) \(coinDetail?.symbol ?? "")"
        } else {
            cell.lblCoinQuantity.text = "\(selectedCurrency?.sign ?? "")\(formattedPrice)"
        }
        cell.lblCoinQuantity.textColor = UIColor.c00C6FB
        return cell
    }
    
}
