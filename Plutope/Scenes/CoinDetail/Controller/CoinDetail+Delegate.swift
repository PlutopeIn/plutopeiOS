//
//  CoinDetail+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//
import UIKit
import SafariServices
extension CoinDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let transaction = arrTransactionNewData[indexPath.row]
        guard let txId = transaction.hash else { return }

        // Get the chain info (assumes coinDetail is available)
        guard let chain = coinDetail?.chain else { return }

        let urlString: String
        switch chain {
        case .binanceSmartChain:
            urlString = "https://bscscan.com/tx/\(txId)"
        case .ethereum:
            urlString = "https://etherscan.io/tx/\(txId)"
        case .oKC:
            urlString = "https://www.okx.com/explorer/oktc/tx/\(txId)"
        case .polygon:
            urlString = "https://polygonscan.com/tx/\(txId)"
        case .bitcoin:
            urlString = "https://btcscan.org/tx/\(txId)"
        case .opMainnet:
            urlString = "https://optimistic.etherscan.io/address/\(txId)"
       
        case .avalanche:
            urlString = "https://subnets.avax.network/c-chain/block/\(txId)"
        case .arbitrum:
            urlString = "https://arbiscan.io/tx/\(txId)"
        case .base:
            urlString = "https://basescan.org/tx/\(txId)"
        default:
            return // Unsupported chain
        }

        guard let url = URL(string: urlString) else { return }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true, completion: nil)
    }

    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tbvTransactions.cellForRow(at: indexPath) as? TransactionViewCell
//        let detailVC = TransactionDetailViewController()
//        if selectedSegment == "Transaction" {
//            detailVC.txId = self.arrTransactionNewData[indexPath.row].hash ?? ""
//            detailVC.coinDetail = self.coinDetail
//            detailVC.type = self.arrTransactionNewData[indexPath.row].type ?? ""
////            detailVC.isToContract = cell?.isToContract
//            detailVC.priceSsymbol = cell?.priceSsymbol ?? ""
//            detailVC.headerTitle = cell?.headerTitle ?? ""
//            detailVC.price = cell?.lblPrice.text ?? ""
//            detailVC.arrTransactionNewData = self.arrTransactionNewData[indexPath.row]
//        } else {
////            detailVC.txId = self.arrInternalTransactionData[indexPath.row].txID ?? ""
////            detailVC.coinDetail = self.coinDetail
////            detailVC.isSwap = self.arrInternalTransactionData[indexPath.row].isSwap ?? false
////            detailVC.isToContract = cell?.isToContract
////            detailVC.priceSsymbol = cell?.priceSsymbol ?? ""
////            detailVC.headerTitle = cell?.headerTitle ?? ""
//        }
//        self.navigationController?.pushViewController(detailVC, animated: true)
//    }
    
}

// MARK: Bottom Sheet
extension CoinDetailViewController {
    
    func showBottomSheet() {
        // Create an alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sellAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""), style: .default) { (_) in
            // Perform sell action
            print("Sell action triggered")
//            self.url = "https://webview-dev.rampable.co/?clientSecret=wpyYO6EyVSwx3QGY50d0VHCICTjiBHTTRGo7zbL6G6bxBtCSaGBrEbRB70ZhzdvP&useWalletConnect=true"
            
//            self.url = "https://webview.rampable.co/?clientSecret=KfoET5E31jh7iikwBwGfHNqB78mbmUmGEpzgVSOj2ovD4AKzuPmdRnX0Up4miXyx&useWalletConnect=true"
//            if let url = self.url {
//                let _ : String = url
//                self.showWebView(for: url, onVC: self, title: "")
//
//            }

        }
        let swapTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
        let swapAction = UIAlertAction(title:swapTitle , style: .default) { (_) in
            // Perform swap action
            print("Swap action triggered")
            
           
//            if(self.coinDetail?.chain?.coinType == CoinType.bitcoin) {
//                self.showToast(message: ToastMessages.btcComingSoon, font: UIFont.systemFont(ofSize: 15))
//            }  else {
                let viewToNavigate = SwapViewController()
                viewToNavigate.payCoinDetail = self.coinDetail
                viewToNavigate.updatebalDelegate = self
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
           // }
        }
      
        let cancelTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        // Add action buttons to the alert controller
        // Add an image to the action

//        swapAction.setValue(UIImage(named: "ic_swap")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
//        sellAction.setValue(UIImage(named: "ic_Bank")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
        
        if let originalImage = UIImage(named: "ic_swap") {
            let height = originalImage.size.height
            let cornerRadius = height / 2.0
            if let roundedImage = originalImage.withRoundedCorners(radius: cornerRadius)?.withRenderingMode(.alwaysOriginal) {
                swapAction.setValue(roundedImage, forKey: "image")
            }
        }
        if let originalImage1 = UIImage(named: "ic_Sell") {
            let height = originalImage1.size.height
            let cornerRadius = height / 2.0
            if let roundedImage = originalImage1.withRoundedCorners(radius: cornerRadius)?.withRenderingMode(.alwaysOriginal) {
                sellAction.setValue(roundedImage, forKey: "image")
            }
        }
        alertController.addAction(swapAction)
        alertController.addAction(sellAction)
        alertController.addAction(cancelAction)
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func showBottonSheetIniPad() {
        
        if isIPAD {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            // Customize the height of the popover
            if let popoverController = alertController.popoverPresentationController {
                popoverController.permittedArrowDirections = []
                popoverController.sourceView = self.view

                // Set the sourceRect to cover the whole view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)

                // Customize the height of the popover
                let customHeight: CGFloat = 350
                alertController.preferredContentSize = CGSize(width: self.view.bounds.width, height: customHeight)
            }
                    let sellAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sell, comment: ""), style: .default) { (_) in
                        // Perform sell action
                        print("Sell action triggered")
//                        self.url = "https://webview.rampable.co/?clientSecret=KfoET5E31jh7iikwBwGfHNqB78mbmUmGEpzgVSOj2ovD4AKzuPmdRnX0Up4miXyx&useWalletConnect=true"
//                        if let url = self.url {
//                            let _ : String = url
//                            self.showWebView(for: url, onVC: self, title: "")
//                        }

                    }
            let swapTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
            let swapAction = UIAlertAction(title: swapTitle, style: .default) { (_) in
                // Perform swap action
                print("Swap action triggered")
                    let viewToNavigate = SwapViewController()
                    viewToNavigate.payCoinDetail = self.coinDetail
                    viewToNavigate.updatebalDelegate = self
                    viewToNavigate.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(viewToNavigate, animated: true)
            }
            let cancelTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            // Add action buttons to the alert controller
            if let originalImage = UIImage(named: "ic_swap") {
                let height = originalImage.size.height
                let cornerRadius = height / 2.0
                if let roundedImage = originalImage.withRoundedCorners(radius: cornerRadius)?.withRenderingMode(.alwaysOriginal) {
                    swapAction.setValue(roundedImage, forKey: "image")
                }
            }
            if let originalImage1 = UIImage(named: "ic_Sell") {
                let height = originalImage1.size.height
                let cornerRadius = height / 2.0
                if let roundedImage = originalImage1.withRoundedCorners(radius: cornerRadius)?.withRenderingMode(.alwaysOriginal) {
                    sellAction.setValue(roundedImage, forKey: "image")
                }
            }
            alertController.addAction(swapAction)
            alertController.addAction(sellAction)
            alertController.addAction(cancelAction)

            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }

    }
    
//    @MainActor
//    func showWebView(for url: String, onVC: UIViewController, title: String) {
//        let webController = Web3BrowserViewController()
//        webController.webViewURL = url
//        webController.webViewTitle = title
//        webController.isFrom = "coinDetail"
//        webController.coinDetail = self.coinDetail
//        let navVC = UINavigationController(rootViewController: webController)
//        navVC.modalPresentationStyle = .overFullScreen
//        navVC.modalTransitionStyle = .crossDissolve
//        onVC.present(navVC, animated: true)
//        }
    
}

// MARK: Collection view delegate method
extension CoinDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
            let coinListVC = BuyCoinListViewController()
        if  coinDetail?.tokenId == "PLT".lowercased() {
            switch indexPath.row {
            case 0:
                let viewToNavigate = SendCoinViewController()
                viewToNavigate.coinDetail = self.coinDetail
                viewToNavigate.refreshWalletDelegate = self
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 1:
                let viewToNavigate = ReceiveCoinViewController()
                viewToNavigate.coinDetail = self.coinDetail
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                let viewToNavigate = SendCoinViewController()
                viewToNavigate.coinDetail = self.coinDetail
                viewToNavigate.refreshWalletDelegate = self
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 1:
                let viewToNavigate = ReceiveCoinViewController()
                viewToNavigate.coinDetail = self.coinDetail
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 2:
                let coinData = self.coinDetail
                let buyCoinVC = BuyCoinViewController()
                buyCoinVC.headerTitle = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: "")) \(coinData?.symbol ?? "")"
                buyCoinVC.coinDetail = coinData
                //        buyCoinVC.minimumAmount = minimumAmount
                self.navigationController?.pushViewController(buyCoinVC, animated: true)
            case 3:
                let viewToNavigate = SwapViewController()
                viewToNavigate.payCoinDetail = self.coinDetail
                viewToNavigate.updatebalDelegate = self
                viewToNavigate.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            case 4:
                
                let sellVC = SellViewController()
                sellVC.coinDetail = self.coinDetail
                sellVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sellVC, animated: true)
  
            default:
                break
            }
        }
        
    }
}

extension CoinDetailViewController {
    func setAttributedClickableText(labelName: UILabel, labelText: String, value: String, color: UIColor, linkColor: UIColor) {
        // Enable user interaction for the label
        labelName.isUserInteractionEnabled = true
        
        let commonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: AppFont.violetRegular(14).value
        ]
        
        let clickableAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: linkColor,
            .font: AppFont.violetRegular(14).value,
//            .link: URL(string: "action://valueTapped")! // Custom URL scheme
        ]
        
        let partOne = NSMutableAttributedString(string: labelText, attributes: commonAttributes)
        let partTwo = NSMutableAttributedString(string: value, attributes: clickableAttributes)
        labelName.tintColor = UIColor.c00C6FB
        partOne.append(partTwo)
        labelName.attributedText = partOne
    }
}
