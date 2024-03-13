//
//  WalletConnectionDetailPopup+TableViewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/02/24.
//

import UIKit
import SDWebImage

// MARK: UITableViewDataSource Methods
extension WalletConnectionDetailPopup : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chainsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvAccount.dequeueReusableCell(indexPath: indexPath) as WalletConnectPopupTbvCell
        cell.selectionStyle = .none
        let data = self.chainsArray[indexPath.row]
        print(data)
        cell.ivConnection.isHidden = true
        cell.ivAccessblity.isHidden = true
        cell.lblUrl.text = WalletData.shared.myWallet?.address
        
        if data == "eip155:56" {
            cell.lblName.text = Chain.binanceSmartChain.name
            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.binanceSmartChain.icon)"), placeholderImage: UIImage.icBnb)
        } else if data == "eip155:1" {
            cell.lblName.text = Chain.ethereum.name
            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.ethereum.icon)"), placeholderImage: UIImage.icEth)
        } else if data == "eip155:137" {
            cell.lblName.text = Chain.polygon.name
            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.polygon.icon)"), placeholderImage: UIImage.icPolygon)
        } else if data == "eip155:66" {
            cell.lblName.text = Chain.oKC.name
            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.oKC.icon)"), placeholderImage: UIImage.icOkc)
        }
        
//        switch data {
//        case "eip155:56":
//            cell.lblName.text = Chain.binanceSmartChain.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.binanceSmartChain.icon)"), placeholderImage: UIImage.icBnb)
//        case "eip155:1":
//            cell.lblName.text = Chain.ethereum.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.ethereum.icon)"), placeholderImage: UIImage.icEth)
//        case "eip155:137":
//            cell.lblName.text = Chain.polygon.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.polygon.icon)"), placeholderImage: UIImage.icPolygon)
//        case "eip155:66":
//            cell.lblName.text = Chain.oKC.name
//            cell.ivWallet.sd_setImage(with: URL(string: "\(Chain.oKC.icon)"), placeholderImage: UIImage.icOkc)
//        default:
//            break
//        }
        return cell
    }
    
}
