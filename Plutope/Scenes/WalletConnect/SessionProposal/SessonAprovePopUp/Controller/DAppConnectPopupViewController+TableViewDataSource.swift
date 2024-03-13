//
//  DAppConnectPopupViewController+TableViewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/01/24.
//

import Foundation
import UIKit
import SDWebImage

// MARK: UITableViewDataSource Methods 
extension DAppConnectPopupViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.chainsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvChainType.dequeueReusableCell(indexPath: indexPath) as WalletConnectPopupTbvCell
        
        cell.selectionStyle = .none
        let data = self.chainsArray[indexPath.row]
        cell.ivConnection.isHidden = true
        cell.ivAccessblity.isHidden = true
        cell.lblUrl.text = WalletData.shared.myWallet?.address
        
        switch data {
        case "eip155:56":
            configureCell(for: cell, with: Chain.binanceSmartChain)
        case "eip155:1":
            configureCell(for: cell, with: Chain.ethereum)
        case "eip155:137":
            configureCell(for: cell, with: Chain.polygon)
        case "eip155:66":
            configureCell(for: cell, with: Chain.oKC)
        default:
            break
        }

        return cell
    }

    func configureCell(for cell: WalletConnectPopupTbvCell, with chain: Chain) {
        cell.lblName.text = chain.name
        cell.ivWallet.sd_setImage(with: URL(string: chain.icon), placeholderImage: UIImage(named:" "))
    }

    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tbvChainType.dequeueReusableCell(indexPath: indexPath) as WalletConnectPopupTbvCell
//        cell.selectionStyle = .none
//        let data = self.chainsArray[indexPath.row]
//        cell.ivConnection.isHidden = true
//        cell.ivAccessblity.isHidden = true
//        cell.lblUrl.text = WalletData.shared.myWallet?.address
//
//        if data == "eip155:56" {
//            cell.lblName.text = Chain.binanceSmartChain.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.binanceSmartChain.icon)"), placeholderImage: UIImage.icBnb)
////            cell.ivWallet.image = UIImage(named: Chain.binanceSmartChain.icon)
//        } else if data == "eip155:1" {
//            cell.lblName.text = Chain.ethereum.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.ethereum.icon)"), placeholderImage: UIImage.icEth)
////            cell.ivWallet.image = UIImage(named:Chain.ethereum.icon)
//        } else if data == "eip155:137" {
//            cell.lblName.text = Chain.polygon.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.polygon.icon)"), placeholderImage: UIImage.icPolygon)
////            cell.ivWallet.image = UIImage(named:Chain.polygon.icon)
//        } else if data == "eip155:66" {
//            cell.lblName.text = Chain.oKC.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.oKC.icon)"), placeholderImage: UIImage.icOkc)
////            cell.ivWallet.image = UIImage(named:Chain.oKC.icon)
//        }
//
//        return cell
//    }
}
