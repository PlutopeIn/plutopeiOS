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
        let coinListCell = tbvBuyCoin.dequeueReusableCell(indexPath: indexPath) as CoinListViewCell
       // let coinData = tokensList?[indexPath.row]
        coinListCell.selectionStyle = .none
        
        let coinData = isSearching ? tokensList?[indexPath.row] : sortedTokens?[indexPath.row]
        
        coinListCell.ivCoin.sd_setImage(with: URL(string: coinData?.logoURI ?? ""))
        coinListCell.lblCoinName.text = coinData?.symbol
//        if isFrom == .addCustomToken || isFrom == .receiveNFT {
//        let balance = Double(coinData?.balance ?? "")?.rounded(toPlaces: 6)
//        coinListCell.lblCoinQuantity.text = "\(balance ?? 0.0)"
        
        // let getbalance = Double(coinData?.balance ?? "") ?? 0.0
        let getbalance = WalletData.shared.formatDecimalString(coinData?.balance ?? "", decimalPlaces: 5)
        coinListCell.lblCoinQuantity.text = "\(getbalance)"
        coinListCell.lblType.isHidden = false
       
        coinListCell.lblType.text = coinData?.type
//        } else {
//            coinListCell.lblCoinQuantity.text = "\(coinData?.balance ?? "") \(coinData?.symbol ?? "")"
//        }
        
        coinListCell.lblSymbol.text = coinData?.name ?? ""
        return coinListCell
        
    }
    
}
