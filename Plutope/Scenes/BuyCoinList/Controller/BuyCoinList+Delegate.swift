//
//  BuyCoinList+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 14/06/23.
//
import UIKit
extension BuyCoinListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // let coinData = tokensList?[indexPath.row]
        let coinData = isSearching ? tokensList?[indexPath.row] : sortedTokens?[indexPath.row]
        switch isFrom {
        case .buy:
            
            let buyCoinVC = BuyCoinViewController()
            
//            viewModel.apiGetCoinPrice(coinData?.symbol?.lowercased() ?? "") { data, status, error in
//                if status {
//                    switch coinData?.type {
//                    case "ERC20" :
//                        let minAmount = round(data?.minimumBuyAmount?["0"] ?? 0).rounded(.up)
//                        buyCoinVC.lblPrice.text = "\(minAmount)"
//                        self.minimumAmount = minAmount
//                    case "BEP20":
//                        let minAmount = round(data?.minimumBuyAmount?["1"] ?? 0).rounded(.up)
//                        buyCoinVC.lblPrice.text = "\(minAmount)"
//                        self.minimumAmount = minAmount
//                    default: break
//
//                    }
//                    buyCoinVC.minimumAmount = self.minimumAmount
//                    buyCoinVC.lblCoinQuantity.text = "\(((Double(buyCoinVC.lblPrice.text ?? "0") ?? 0.0) / (Double(coinData?.price ?? "") ?? 0.0)).rounded(toPlaces: 5)) \(coinData?.symbol ?? "")"
//                    if (Double(buyCoinVC.lblPrice.text ?? "0") ?? 0.0) > 0 {
//                        buyCoinVC.btnNext.alpha = 1
//                        buyCoinVC.btnNext.isUserInteractionEnabled = true
//                    } else {
//                        buyCoinVC.btnNext.alpha = 0.5
//                        buyCoinVC.btnNext.isUserInteractionEnabled = false
//                    }
//
//                } else {
//                    print(error)
//                }
//            }
            
           // buyCoinVC.headerTitle = "Buy \(coinData?.symbol ?? "")"
            buyCoinVC.headerTitle = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")) \(coinData?.symbol ?? "")"
            buyCoinVC.coinDetail = coinData
//            buyCoinVC.minimumAmount = self.minimumAmount
            self.navigationController?.pushViewController(buyCoinVC, animated: true)
            
        case .send:
//            if(coinData?.chain?.coinType == CoinType.bitcoin) {
//                self.showToast(message: ToastMessages.btcComingSoon, font: UIFont.systemFont(ofSize: 15))
//            } else {
                let sendCoinVc = SendCoinViewController()
                sendCoinVc.coinDetail = coinData
                self.navigationController?.pushViewController(sendCoinVc, animated: true)
           // }
            
        case .receive, .receiveNFT:
            let receiveCoinVC = ReceiveCoinViewController()
            receiveCoinVC.coinDetail = coinData
            self.navigationController?.pushViewController(receiveCoinVC, animated: true)
            
        case .addCustomToken :
            selectNetworkDelegate?.selectNetwork(chain: coinData!)
            self.navigationController?.popViewController(animated: true)
            
        case .swap :
//            if(coinData?.chain?.coinType == CoinType.bitcoin) {
//                self.showToast(message: ToastMessages.btcComingSoon, font: UIFont.systemFont(ofSize: 15))
//            } else {
                let viewToNavigate = SwapViewController()
                viewToNavigate.payCoinDetail = coinData
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
           // }
        
        default: break
       
        }
        
    }
}
