//
//  BuyCoinList+Datasource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
extension BuyCoinListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //   tokensList?.count ?? 0
        
        return isSearching ? tokensList?.count ?? 0 : sortedTokens?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coinListCell = tbvBuyCoin.dequeueReusableCell(indexPath: indexPath) as PurchasedCoinViewCell
        coinListCell.selectionStyle = .none
        let coinData = isSearching ? tokensList?[indexPath.row] : sortedTokens?[indexPath.row]
        if (coinData?.isUserAdded == false ) {
            coinListCell.coinQuantity.isHidden = true
            coinListCell.coinAmount.isHidden = true
            coinListCell.coinPrice.isHidden = true
            coinListCell.lblPer.isHidden = true
            
        } else {
            coinListCell.coinQuantity.isHidden = false
            coinListCell.coinAmount.isHidden = false
            coinListCell.coinPrice.isHidden = false
            coinListCell.lblPer.isHidden = false
          //  coinListCell.lblYourTokens.isHidden = false
        }
        let logoURI = coinData?.logoURI?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let chainImage = coinData?.chain?.icon ?? ""
         
        let imageURLString = logoURI.isEmpty ? chainImage : logoURI
        let defaultPLTImage = "https://plutope.app/api/images/applogo.png"
        if coinData?.tokenId?.lowercased() == "plt" {
            let imageURL = defaultPLTImage
            coinListCell.ivCoin.sd_setImage(with: URL(string: imageURL))
        }  else {
            if logoURI.isEmpty && coinData?.chain?.chainName.lowercased() == "eth"   {
                coinListCell.ivCoin.image = UIImage.ethLogo
            } else if let imageURL = URL(string: imageURLString), !imageURLString.isEmpty {
                coinListCell.ivCoin.sd_setImage(with: imageURL)
            } else {
                coinListCell.ivCoin.image = UIImage(named: "") // fallback asset if all fail
            }
        }
        coinListCell.lblCoinName.text = coinData?.symbol
        coinListCell.lblSymbol.text = coinData?.type
        let formattedString = WalletData.shared.formatDecimalString("\(coinData?.price ?? "0")", decimalPlaces: 10)
        let curruncy = WalletData.shared.primaryCurrency?.sign ?? ""
        coinListCell.coinPrice.text = coinData?.isUserAdded ?? false ? "" : "\(curruncy) \(formattedString)"

        let balance = Double(coinData?.balance ?? "") ?? 0.0
        let formattedStringv = WalletData.shared.formatDecimalString("\(balance)", decimalPlaces: 7)
        if coinData?.balance == "" {
            coinListCell.coinQuantity.isHidden = true
        } else {
            coinListCell.coinQuantity.isHidden = false
        }
            // coin quntity
        coinListCell.coinQuantity.text = "\(formattedStringv) \(coinData?.symbol ?? "")"
        
        let amout = balance * (Double(coinData?.price ?? "") ?? 0.0)

        let formattedValue = WalletData.shared.formatDecimalString("\(amout)", decimalPlaces: 2)
        // coin amount
        coinListCell.coinAmount.text = "\(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedValue)"


        let priceChangeImpact = Double(coinData?.lastPriceChangeImpact ?? "") ?? 0.0
        let priceChangeImpactTruncatedValue = WalletData.shared.formatDecimalString("\(priceChangeImpact)", decimalPlaces: 10)
        if (coinData?.isUserAdded ?? false ) {
            coinListCell.lblPer.text  = ""
        } else {
            if priceChangeImpact > 0 {
                coinListCell.lblPer.text = "+\(priceChangeImpactTruncatedValue)%"
            } else {
                coinListCell.lblPer.text = "\(priceChangeImpactTruncatedValue)%"
            }
        }
            coinListCell.lblPer.textColor = priceChangeImpact >= 0 ? UIColor.c099817 : .red
            coinListCell.coinAmount.textColor = priceChangeImpact >= 0 ? UIColor.c099817 : .red
        
        return coinListCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
        return 55
    }
}
