//
//  SellCoin+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 17/07/23.
//

import Foundation
import UIKit

// MARK: UICollectionViewDelegate
extension SellCoinViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let cell = clvKeyboard.cellForItem(at: indexPath) as? KeyboardViewCell else { return }
        
        let number = indexPath.row + 1
        
        animateCellSelection(cell)
        
        switch number {
            
        case 12:
            /// Delete Action
            if lblPrice.text?.count ?? 0 > 0 {
                lblPrice.text?.removeLast()
                self.lblCoinQuantity.showLoading()
            }
            
        default:
            /// Number pad action
            if let currentText = lblPrice.text, currentText.count < 11 {
                if (lblPrice.text?.contains(".") == true) && cell.txtNumber.text == "." {
                    
                } else {
                    lblPrice.text = currentText + (cell.txtNumber.text ?? "")
                    self.lblCoinQuantity.showLoading()
                }
                
            } else {
                showToast(message: StringConstants.limitText, font: AppFont.regular(15).value)
                return
            }
        }
        
        if (Double(lblPrice.text ?? "0") ?? 0.0) > 0 && (Double(coinDetail?.balance ?? "") ?? 0.0) >= (Double(lblPrice.text ?? "0") ?? 0.0) {
            self.btnNext.alpha = 1
            self.lblExceedbal.isHidden = true
            self.btnNext.isUserInteractionEnabled = true
            apiCount = 0
            callAPIsAfterTaskCompletion()
        } else {
           
            self.lblExceedbal.isHidden = false
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
            self.lblCoinQuantity.hideLoading()
            lblCoinQuantity.text = "Not available!"
            viewProvider.isHidden = true
        }
        
    }
    
}

// MARK: - Dismiss Delegate
extension SellCoinViewController: ProviderSelectDelegate {
   
    func valuesTobePassed(_ provider: BuyProviders) {
    
        lblProviderName.text = provider.name
        lblCoinQuantity.text = "~\(selectedCurrency?.sign ?? "")\(provider.bestPrice ?? "")"
        ivProvider.image = provider.imageUrl
        
        switch provider.name {
        case StringConstants.onMeta:
            self.provider = .onMeta()
        case StringConstants.changeNow:
            self.provider = .changeNow()
        case StringConstants.onRamp:
            self.provider = .onRamp()
//        case StringConstants.meld:
//            self.provider = .meld()
        default:
            break
        }
    }
}

// MARK: Currency update delegate
extension SellCoinViewController: CurrencyUpdateDelegate {
    
    func updateCurrency(currencyObject: Currencies) {
//        self.lblCurrency.text = currencyObject.sign
        self.btnSelectedCurrency.setTitle(currencyObject.symbol ?? "", for: .normal)
        self.selectedCurrency = currencyObject
        lblCoinQuantity.showLoading()
        apiCount = 0
        callAPIsAfterTaskCompletion()
    }
    
}
