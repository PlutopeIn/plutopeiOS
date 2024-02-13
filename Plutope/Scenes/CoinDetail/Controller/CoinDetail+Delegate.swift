//
//  CoinDetail+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//
import UIKit
extension CoinDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = TransactionDetailViewController()
        detailVC.txId = self.arrTransactionData[indexPath.row].txID ?? ""
        detailVC.coinDetail = self.coinDetail
        detailVC.isSwap = self.arrTransactionData[indexPath.row].isSwap ?? false
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: Bottom Sheet
extension CoinDetailViewController {
    
    func showBottomSheet() {
        // Create an alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
//        let sellAction = UIAlertAction(title: "Sell", style: .default) { (_) in
//            // Perform sell action
//            print("Sell action triggered")
//            let coinData = self.coinDetail
//            let buyCoinVC = SellCoinViewController()
//            buyCoinVC.coinDetail = coinData
//            self.navigationController?.pushViewController(buyCoinVC, animated: true)
//        }
        /*let swapAction = UIAlertAction(title: "Swap", style: .default) { (_) in
            // Perform swap action
            print("Swap action triggered")
            let viewToNavigate = SwapViewController()
            viewToNavigate.payCoinDetail = self.coinDetail
            viewToNavigate.updatebalDelegate = self
            viewToNavigate.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        }*/
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
        // let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cancelTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        // Add action buttons to the alert controller
       // alertController.addAction(sellAction)
        alertController.addAction(swapAction)
        alertController.addAction(cancelAction)
        
//        // Present the alert controller as a popover on iPad
//        if let popoverPresentationController = alertController.popoverPresentationController {
//            popoverPresentationController.sourceView = showBottomSheetButton
//            popoverPresentationController.sourceRect = showBottomSheetButton.bounds
//        }
        
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
//                    let sellAction = UIAlertAction(title: "Sell", style: .default) { (_) in
//                        // Perform sell action
//                        print("Sell action triggered")
//                        let coinData = self.coinDetail
//                        let buyCoinVC = SellCoinViewController()
//                        buyCoinVC.coinDetail = coinData
//                        self.navigationController?.pushViewController(buyCoinVC, animated: true)
//                    }
            let swapTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: "")
            let swapAction = UIAlertAction(title: swapTitle, style: .default) { (_) in
                // Perform swap action
                print("Swap action triggered")
//                if(self.coinDetail?.chain?.coinType == CoinType.bitcoin) {
//                    self.showToast(message: ToastMessages.btcComingSoon, font: UIFont.systemFont(ofSize: 15))
//                } else {
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
            alertController.addAction(swapAction)
          //  alertController.addAction(sellAction)
            alertController.addAction(cancelAction)

            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }

    }
}
