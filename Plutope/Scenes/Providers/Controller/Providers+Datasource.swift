//
//  Providers+Datasource.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension ProvidersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buyArrProviderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvProviders.dequeueReusableCell(withIdentifier: CoinListViewCell.reuseIdentifier) as? CoinListViewCell else { return UITableViewCell() }
        let data = buyArrProviderList[indexPath.row]
       
        cell.bgView.backgroundColor = UIColor.secondarySystemBackground
        cell.selectionStyle = .none
        cell.lblSymbol.isHidden = true
        cell.lblCoinName?.text = data.name
        
        var imgUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion+ServiceNameConstant.BaseUrl.images + (data.image ?? "")
        cell.ivCoin.sd_setImage(with: URL(string: imgUrl))
        cell.ivCoin.RoundMe(Radius: cell.ivCoin.frame.height / 2 )
        //cell.ivCoin.BorderMe(Color: UIColor.secondarySystemFill, BorderWidth: 1)
//        cell.ivCoin.image = data.imageUrl
        let formattedPrice = WalletData.shared.formatDecimalString("\(data.amount ?? "")", decimalPlaces: 6)
        
       // let formattedPrice = String(format: "%.6f", Double(data.bestPrice ?? "") ?? 0.0)
        if self.providerType == .buy {
            cell.lblCoinQuantity.text = "\(formattedPrice) \(coinDetail?.symbol ?? "")"
        } else {
            cell.lblCoinQuantity.text = "\(selectedCurrency?.sign ?? "")\(formattedPrice)"
        }
        cell.lblCoinQuantity.textColor = UIColor(named: "#2B5AF3")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
        return 52
    }
}
