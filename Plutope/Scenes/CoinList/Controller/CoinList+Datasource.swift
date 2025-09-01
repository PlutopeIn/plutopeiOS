//
//  CoinList+Datasource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
extension CoinListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tokensList?.count ?? 0
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let coinListCell = tbvCoinList.dequeueReusableCell(indexPath: indexPath) as CoinListViewCell
        
        let coinData = tokensList?[indexPath.row]
                        
        coinListCell.selectionStyle = .none
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
        if isFromDash {
            coinListCell.lblCoinQuantity.text = ""
            coinListCell.lblCoinQuantity.isHidden = true
        } else {
            let paybalance = Double(coinData?.balance ?? "") ?? 0.0
            let formattedString = WalletData.shared.formatDecimalString("\(paybalance)", decimalPlaces: 10)
            coinListCell.lblCoinQuantity.text = "\(formattedString)"
        }

        coinListCell.lblSymbol.text = coinData?.name ?? ""
        coinListCell.lblType.isHidden = false
        coinListCell.lblType.text = coinData?.type ?? ""
        
        return coinListCell
    
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
        return 60
    }
 }
