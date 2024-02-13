//
//  BuyCoin+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
extension BuyCoinViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        guard let cell = clvKeyboard.cellForItem(at: indexPath) as? KeyboardViewCell else { return }
//
//        let number = indexPath.row + 1
//
//        animateCellSelection(cell)
//
//        switch number {
//
//        case 12:
//            /// Delete Action
//            if txtPrice.text?.count ?? 0 > 0 {
//                txtPrice.text?.removeLast()
//              //  self.lblCoinQuantity.showLoading()
//
//            }
//
//        default:
//            /// Number pad action
//            if let currentText = txtPrice.text, currentText.count < 11 {
//                if (txtPrice.text?.contains(".") == true) && cell.txtNumber.text == "." {
//
//                } else {
//                    txtPrice.text = currentText + (cell.txtNumber.text ?? "")
//                }
//                lblPrice.adjustsFontSizeToFitWidth = true
//                lblPrice.minimumScaleFactor = 0.5
//
////
////                lblCurrency.adjustsFontSizeToFitWidth = lblPrice.adjustsFontSizeToFitWidth
//               lblCurrency.minimumScaleFactor = lblPrice.minimumScaleFactor
//            } else {
//                showToast(message: StringConstants.limitText, font: AppFont.regular(15).value)
//                return
//            }
//        }
//
//        if (Double(txtPrice.text ?? "0") ?? 0.0) > 0 {
//            self.btnNext.alpha = 1
//
//            self.btnNext.isUserInteractionEnabled = true
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
//            perform(#selector(apiCall), with: nil, afterDelay: 2)
//            // viewProvider.isHidden = false
//
//        } else {
//            self.btnNext.alpha = 0.5
//            self.btnNext.isUserInteractionEnabled = false
//            self.lblCoinQuantity.hideLoading()
//            lblCoinQuantity.text = "Not available!"
//            viewProvider.isHidden = true
//        }
//
//        lblCoinQuantity.adjustsFontSizeToFitWidth = true
//        lblCoinQuantity.minimumScaleFactor = 0.5
//
//    }
//   @objc private func apiCall() {
//       print("nscancel api call")
//       self.lblCoinQuantity.showLoading()
//       apiCount = 0
//       callAPIsAfterTaskCompletion()
//   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = clvKeyboard.cellForItem(at: indexPath) as? KeyboardViewCell else { return }

        let number = indexPath.row + 1

        animateCellSelection(cell)

        switch number {
        case 12:
            // Delete Action
            if txtPrice.text?.count ?? 0 > 0 {
                txtPrice.text?.removeLast()
            }
        default:
            // Number pad action
            if let currentText = txtPrice.text, currentText.count < 11 {
                if (txtPrice.text?.contains(".") == true) && cell.txtNumber.text == "." {
                    // Handle special case if needed
                } else {
                    txtPrice.text = currentText + (cell.txtNumber.text ?? "")
                }
                lblPrice.adjustsFontSizeToFitWidth = true
                lblPrice.minimumScaleFactor = 0.5
            } else {
                showToast(message: StringConstants.limitText, font: AppFont.regular(15).value)
                return
            }
        }

        // Delay the API call to ensure the text field is fully updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.makeAPICallIfValid()
        }
    }

     func makeAPICallIfValid() {
        if let price = Double(txtPrice.text ?? "0"), price > 0 {
            self.btnNext.alpha = 1
            self.btnNext.isUserInteractionEnabled = true
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
            perform(#selector(apiCall), with: nil, afterDelay: 1)
        } else {
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
            self.lblCoinQuantity.hideLoading()
            lblCoinQuantity.text = "Not available!"
            viewProvider.isHidden = true
        }
    }
       @objc private func apiCall() {
           print("nscancel api call")
           self.lblCoinQuantity.showLoading()
           apiCount = 0
           callAPIsAfterTaskCompletion()
       }
}

// MARK: - Dismiss Delegate
extension BuyCoinViewController: ProviderSelectDelegate {
   
    func valuesTobePassed(_ provider: BuyProviders) {
    
        lblProviderName.text = provider.name
        let formattedPrice = WalletData.shared.formatDecimalString("\(provider.bestPrice ?? "")", decimalPlaces: 6)
        lblCoinQuantity.text = "~\(formattedPrice) \(coinDetail?.symbol ?? "")"
        ivProvider.image = provider.imageUrl
        
        switch provider.name {
            /// temporary hide onMeta code
        case StringConstants.onMeta:
            self.provider = .onMeta()
        case StringConstants.changeNow:
            self.provider = .changeNow()
        case StringConstants.onRamp:
            self.provider = .onRamp()
        case StringConstants.meld:
            self.provider = .meld()
        case StringConstants.unLimit:
            self.provider = .unlimit()
        default:
            break
        }
    }
}

// MARK: Currency update delegate
extension BuyCoinViewController: CurrencyUpdateDelegate {
    
    func updateCurrency(currencyObject: Currencies) {
        self.lblCurrency.text = currencyObject.sign
        self.btnSelectedCurrency.setTitle(currencyObject.symbol ?? "", for: .normal)
        self.selectedCurrency = currencyObject
        lblCoinQuantity.showLoading()
        getBestPriceFromAllProvider(buyProviders: supportedProviders)
        apiCount = 0
        // callAPIsAfterTaskCompletion()
    }
    
}
