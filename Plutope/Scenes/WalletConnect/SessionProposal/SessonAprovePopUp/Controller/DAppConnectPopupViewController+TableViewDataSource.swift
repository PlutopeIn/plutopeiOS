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
        return  self.filteredChainsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvChainType.dequeueReusableCell(indexPath: indexPath) as WalletConnectPopupTbvCell
        
        cell.selectionStyle = .none
        let data = self.filteredChainsArray[indexPath.row]
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
//        case "eip155:10":
//            configureCell(for: cell, with: Chain.opMainnet)
        case "eip155:10":
            configureCell(for: cell, with: Chain.opMainnet)
        case "eip155:42161":
            configureCell(for: cell, with: Chain.arbitrum)
        case "eip155:43114":
            configureCell(for: cell, with: Chain.avalanche)
        case "eip155:8453":
            configureCell(for: cell, with: Chain.base)
//        case "eip155:97":
//            configureCell(for: cell, with: Chain.binanceSmartChain)

        default:
            break
        }

        return cell
    }

    func configureCell(for cell: WalletConnectPopupTbvCell, with chain: Chain) {
        cell.lblName.text = chain.name
        cell.ivWallet.sd_setImage(with: URL(string: chain.icon), placeholderImage: UIImage(named:" "))
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        tbvHeight.constant = tbvChainType.contentSize.height
    }
}
