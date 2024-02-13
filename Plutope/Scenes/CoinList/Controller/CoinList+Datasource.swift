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

        coinListCell.ivCoin.sd_setImage(with: URL(string: coinData?.logoURI ?? ""),placeholderImage: coinData?.chain?.chainDefaultImage)
        coinListCell.lblCoinName.text = coinData?.symbol
        if isFromDash {
            coinListCell.lblCoinQuantity.text = ""
        } else {
            let paybalance = Double(coinData?.balance ?? "") ?? 0.0
           // let balance = String(format: "%.8f", coinData?.balance ?? "")
            
//            let payStringValue = String(paybalance)
//            let payTruncatedValue = String(payStringValue.prefix(8))
            
            let formattedString = WalletData.shared.formatDecimalString("\(paybalance)", decimalPlaces: 8)
           // coinListCell.lblCoinQuantity.text = payTruncatedValue
            coinListCell.lblCoinQuantity.text = "\(formattedString)"
        }
     
        coinListCell.lblSymbol.text = coinData?.name ?? ""
        coinListCell.lblType.isHidden = false
        coinListCell.lblType.text = coinData?.type ?? ""
        
        return coinListCell
    
     }
    
 } 
