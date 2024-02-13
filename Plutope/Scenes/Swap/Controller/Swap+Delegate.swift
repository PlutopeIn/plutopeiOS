//
//  Swap+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
// MARK: UITextFieldDelegate
extension SwapViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let text = textField.text ?? ""
        if (Double(text) ?? 0.0) > 0 {
//            if (getCoinDetail?.type == payCoinDetail?.type) {
//                oKTswappingQuote()
//            } else {
//                changeNowSwapQuote()
//            }
            print(supportedProviders)
            lblGetMoney.text = ""
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
            perform(#selector(apiCall), with: nil, afterDelay: 1)
        } else {
            txtGet.text = ""
            lblGetMoney.text = ""
            lblPayMoney.text = ""
            self.txtGet.hideLoading()
        }
    }
    
    @objc private func apiCall() {
        print("nscancel api call")
        txtGet.showLoading()
        apiCount = 0
        getBestPriceFromAllProvider(swapProviders: supportedProviders)
    }
}

// MARK: ConfirmSwapDelegate
extension SwapViewController : ConfirmSwapDelegate {
    func confirmSwap() {
        btnSwap.ShowLoader()
        DGProgressView.shared.showLoader(to: self.view)
        if payCoinDetail?.address != "" {
            self.apiOkxSwapApprove()
        } else {
            self.oKTswappingPreview()
        }
    }
}

extension SwapViewController : ConfirmSwap1Delegate {
    func confirmSwap1(isFrom: String, swappingFee: String) {
        btnSwap.ShowLoader()
        DGProgressView.shared.showLoader(to: self.view)
        if isFrom == "changeNow" {
           self.swappingPreview()
        } else {
            self.swapperFee = swappingFee
            self.rangoSwap()
//            let payBalance = Double(self.lblPayCoinBalance.text ?? "") ?? 0.0
//            let getbalance = Double(self.swapperFee) ?? 0.0
//            let scientificNotationString = txtPay.text ?? ""
//            if let doubleValue = convertScientificToDouble(scientificNotationString: scientificNotationString) {
//
//                let value = WalletData.shared.formatDecimalString("\(doubleValue)", decimalPlaces: 8)
//                let payableAmount = doubleValue  + getbalance
//                if payBalance >= payableAmount {
//                    self.rangoSwap()
//                } else {
//                    btnSwap.HideLoader()
//                    DGProgressView.shared.hideLoader()
//                    let msg = "You don't have enough \(payCoinDetail?.symbol ?? "") in your account. Make sure you have to (\(value) + \(getbalance)) = \(payableAmount) \(payCoinDetail?.symbol ?? "") in your account"
//                    self.showToast(message: msg, font: AppFont.medium(15).value)
//                }
//            } else {
//                print("Invalid scientific notation string")
//            }
        }
    }
    
    func convertScientificToDouble(scientificNotationString: String) -> Double? {
        // Create a NumberFormatter instance
        let formatter = NumberFormatter()

        // Set the number style to scientific
        formatter.numberStyle = .scientific

        // Convert the scientific notation string to a number
        if let number = formatter.number(from: scientificNotationString) {
            // Convert the number to a Double
            return number.doubleValue
        } else {
            return nil
        }
    }
}
// MARK: - Dismiss Delegate
extension SwapViewController: SwapProviderSelectDelegate {
    func valuesTobePassed(_ provider: SwapProviders) {
        let formattedPrice = WalletData.shared.formatDecimalString(provider.bestPrice ?? "", decimalPlaces: 10)
        self.bestQuote = formattedPrice
        switch provider.name {
            /// temporary hide onMeta code
        case StringConstants.okx:
            self.provider = .okx()
        case StringConstants.changeNow:
            self.provider = .changeNow()
        case StringConstants.rangoSwap:
            self.provider = .rango()
        default:
            break
        }
    }
}
extension SwapViewController {
    func selectProvider(_ formattedPrice: String,_ providerName:String) {
        
        switch providerName {
            /// temporary hide onMeta code
        case StringConstants.okx:
            self.provider = .okx()
        case StringConstants.changeNow:
            self.provider = .changeNow()
        case StringConstants.rangoSwap:
            self.provider = .rango()
        default:
            break
        }
        switch provider {
        case .okx :
            let swapPreviewVC = PreviewSwapViewController()
            swapPreviewVC.swapQouteDetail = self.swapQouteDetail
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "")
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "okx"
            self.navigationController?.present(swapPreviewVC, animated: true)
        case .changeNow :
            let swapPreviewVC = PreviewSwap1ViewController()
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "")
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "changeNow"
            swapPreviewVC.swappingFee = ""
            self.navigationController?.present(swapPreviewVC, animated: true)
        case .rango :
            let swapPreviewVC = PreviewSwap1ViewController()
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "")
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "rango"
            swapPreviewVC.swappingFee = self.swapperFee
            self.navigationController?.present(swapPreviewVC, animated: true)
        }
    }
}

extension SwapViewController {
    func swapperFeeValidation(formattedPrice: String) {
        let payBalance = Double(self.lblPayCoinBalance.text ?? "") ?? 0.0
        let getbalance = Double(self.swapperFee) ?? 0.0
        let scientificNotationString = txtPay.text ?? ""
        if let doubleValue = convertScientificToDouble(scientificNotationString: scientificNotationString) {
           
            let value = WalletData.shared.formatDecimalString("\(doubleValue)", decimalPlaces: 8)
            let payableAmount = doubleValue  + getbalance
            if payBalance >= payableAmount {
                selectProvider(formattedPrice,self.providerName)
            } else {
                btnSwap.HideLoader()
                DGProgressView.shared.hideLoader()
                let msg = "You don't have enough \(payCoinDetail?.symbol ?? "") in your account. Make sure you have to (\(value) + \(getbalance)) = \(payableAmount) \(payCoinDetail?.symbol ?? "") in your account"
                self.showToast(message: msg, font: AppFont.medium(15).value)
                return
            }
        } else {
            print("Invalid scientific notation string")
        }
    }
}
