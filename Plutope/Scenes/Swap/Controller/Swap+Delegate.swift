//
//  Swap+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import BigInt
import SDWebImage
// MARK: UITextFieldDelegate
extension SwapViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let text = textField.text ?? ""
        if (Double(text) ?? 0.0) > 0 {
            lblGetMoney.text = ""
            self.lblFindProvider.text = ""
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(apiCall), object: nil)
            perform(#selector(apiCall), with: nil, afterDelay: 1)
        } else {
            txtGet.text = ""
            lblGetMoney.text = ""
            lblPayMoney.text = ""
            self.lblFindProvider.text = ""
            self.btnGet.isUserInteractionEnabled = true
            self.btnPay.isUserInteractionEnabled = true
            self.lblHalf.isUserInteractionEnabled = true
            self.lblAll.isUserInteractionEnabled = true
            self.btnSwapcoins.isUserInteractionEnabled = true
            self.txtGet.hideLoading()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Try to add the new input
            if let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                
                // Check if there's already a decimal point in the text
                if updatedText.components(separatedBy: ".").count > 2 {
                    return false // Block if there are more than one decimal points
                }
            }
       
            return true // Allow input if it's valid
        }
    @objc private func apiCall() {
        print("nscancel api call")
//        txtGet.showLoading()
            // self.viewFindProvider.isHidden = false
        getBestPriceFromAllProvider()
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
        } else if isFrom == "exodus" {
            self.exodusSwap()
        } else {
            self.swapperFee = swappingFee
            self.rangoSwap()
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
   
    
    
    fileprivate func updateUI(providerImage:String,name:String,bestPrice:String,providerName:String,isBestPrice:Bool) {
        DispatchQueue.main.async {
            self.lblBestProvider.text = name
            self.providerImage = providerImage
            self.lblBestPriceTitle.isHidden = isBestPrice
            self.lblProviderBestPrice.text = "\(self.bestQuote)"
            let imgUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion+ServiceNameConstant.BaseUrl.images + (providerImage)
            self.ivProvider.sd_setImage(with: URL(string: imgUrl))
            self.txtGet.text = bestPrice
            let get = Double(self.txtGet.text ?? "") ?? 0.0
            let getPrice = (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
            let getAmount = get * getPrice
            if self.txtGet.text == "" {
                self.lblGetMoney.text = ""
                
            } else if self.lblGetMoney.text ?? "" == "" {
                
               // self.showToast(message:"Provider not found!", font: AppFont.regular(15).value)
            } else {
                let value = getAmount
                let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 10)
                self.lblGetMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedValue)"
            }
        }
      
    }
    
    func valuesTobePassed(name: String?, bestPrice: String?, swapperFee: String?, providerImage: String?, providerName: String,isBestPrice: Bool) {
        DispatchQueue.main.async {
               self.provider = providerName
               self.providerName = providerName
                self.bestQuote = bestPrice ?? ""
                let formattedPrice = WalletData.shared.formatDecimalString("\( bestPrice ?? "")", decimalPlaces: 10)
            self.updateUI(providerImage: providerImage ?? "", name: name ?? "",bestPrice: formattedPrice, providerName: providerName, isBestPrice: isBestPrice)
           // }
        }
    }
  }
extension SwapViewController {
    // setCoinDetail
    func setCoinDetail() {
        DispatchQueue.main.async {
            /// Pay coin detail
            self.ivPayCoin.sd_setImage(with:  URL(string: self.payCoinDetail?.logoURI ?? ""))
            self.lblCoinName.text = self.payCoinDetail?.symbol
            self.lblType1.text = self.payCoinDetail?.type
            self.lblPaySymbol.text = self.payCoinDetail?.name
            let paybalance = Double(self.payCoinDetail?.balance ?? "") ?? 0.0
            self.lblPayCoinBalance.text = "\( WalletData.shared.formatDecimalString("\(paybalance)", decimalPlaces: 10))"
            self.txtPay.text = ""
            let pay = Double(self.txtPay.text ?? "") ?? 0.0
            let payPrice = (Double(self.payCoinDetail?.price ?? "") ?? 0.0)
            let payableAmount = pay * payPrice
            let value = payableAmount
            let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 10)
            if self.txtPay.text == "" {
                self.lblPayMoney.text = ""
            } else {
                self.lblPayMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedValue)"
            }
            /// Get coin detail
            self.ivGetCoin.sd_setImage(with:  URL(string: self.getCoinDetail?.logoURI ?? ""))
            self.lblGetCoinName.text = self.getCoinDetail?.symbol
            let getbalance = Double(self.getCoinDetail?.balance ?? "") ?? 0.0
            let formattedString1 = WalletData.shared.formatDecimalString("\(getbalance)", decimalPlaces: 10)
            self.lblGetCoinBalance.text = "\(formattedString1)"
            self.lblType2.text = self.getCoinDetail?.type
            self.lblGetSymbol.text = self.getCoinDetail?.name
            self.txtGet.text = ""
            let get = Double(self.txtGet.text ?? "") ?? 0.0
            let getPrice = (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
            let getAmount = get * getPrice
            if self.txtGet.text == "" {
                self.lblGetMoney.text = ""
            } else if self.lblGetMoney.text ?? "" == "" {
               // self.showToast(message:"Provider not found!", font: AppFont.regular(15).value)
             } else {
                let value = getAmount
                let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 8)
                self.lblGetMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedValue)"
            }
            if (Double(self.getCoinDetail?.price ?? "") ?? 0.0)  == 0.0 || (Double(self.payCoinDetail?.price ?? "") ?? 0.0 == 0.0 ) {
                self.lblEstimateAmount.isHidden = true
            } else {
               // self.lblEstimateAmount.isHidden = false
                let estimatePrice = (Double(self.payCoinDetail?.price ?? "") ?? 0.0) / (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
            let estimatePriceStringValue = String(estimatePrice)
            let estimateValue = WalletData.shared.formatDecimalString("\(estimatePriceStringValue)", decimalPlaces: 15)
            let estimatePriceTruncatedValue = estimateValue
                self.lblEstimateAmount.text = "1 \(self.payCoinDetail?.symbol ?? "") = \(estimatePriceTruncatedValue) \(self.getCoinDetail?.symbol ?? "")"
            }
            for views in self.viewProgress {
                views.backgroundColor = .c75769D
            }
            self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: "")
            self.lblSuccessFail.textColor = .c75769D
            self.checkChains()
        }
    }
    /// getBestPriceFromAllProvider
     func getBestPriceFromAllProvider() {
         viewProvider.isHidden = true
         self.lblFindProvider.text = ""
         lblChooseProvider.isHidden = true
         let pay = Double(self.txtPay.text ?? "") ?? 0.0
         let payPrice = (Double(self.payCoinDetail?.price ?? "") ?? 0.0)
         let payableAmount = pay * payPrice
         if self.txtPay.text == "" {
             self.lblPayMoney.text = ""
         } else {
             let value = payableAmount
             let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 10)
             self.lblPayMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedValue)"
         }
         txtGet.showLoading()
         btnGet.isUserInteractionEnabled = false
         btnPay.isUserInteractionEnabled = false
         self.lblHalf.isUserInteractionEnabled = false
         self.lblAll.isUserInteractionEnabled = false
         self.btnSwapcoins.isUserInteractionEnabled = false
         self.swapQuote()
    }
    func selectProvider(_ formattedPrice: String,_ providerName:String) {
        
        switch providerName {
            /// temporary hide onMeta code
        case "okx":
            self.provider = "okx"
        case "changeNow":
            self.provider = "changenow"
        case "rangoexchange":
            self.provider = "rangoexchange"
        case "exodus":
            self.provider = "exodus"
        default:
            break
        }
        switch provider {
        case "okx" :
            let swapPreviewVC = PreviewSwapViewController()
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "",paySymbol: self.payCoinSymbol,getSymbol: self.getCoinSymbol)
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "okx"
            self.navigationController?.present(swapPreviewVC, animated: true)
        case "changenow" :
            let swapPreviewVC = PreviewSwap1ViewController()
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "",paySymbol: self.payCoinSymbol,getSymbol: self.getCoinSymbol)
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "changeNow"
            swapPreviewVC.swappingFee = ""
            self.navigationController?.present(swapPreviewVC, animated: true)
        case "rangoexchange" :

            let swapPreviewVC = PreviewSwap1ViewController()
           
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: self.txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "",paySymbol: self.payCoinSymbol,getSymbol: self.getCoinSymbol)
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "rango"
            if self.cachedSwapperFee != "" {
               
                swapPreviewVC.swappingFee = self.cachedSwapperFee ?? ""
            } else {
                swapPreviewVC.swappingFee = self.swapperFee
            }
            
            swapPreviewVC.outputAmount = self.amountToGet
            swapPreviewVC.networkFee = self.networkFee
           
            self.navigationController?.present(swapPreviewVC, animated: true)
       
        case "exodus":
            let swapPreviewVC = PreviewSwap1ViewController()
            let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "",paySymbol: self.payCoinSymbol,getSymbol: self.getCoinSymbol)
            swapPreviewVC.previewSwapDetail = previewSwapDetail
            swapPreviewVC.delegate = self
            swapPreviewVC.isFrom = "exodus"
            swapPreviewVC.swappingFee = ""
            self.navigationController?.present(swapPreviewVC, animated: true)
        default:
            break
        }
    }
}

extension SwapViewController {
    func swapperFeeValidation(formattedPrice: String) {
        _ = Double(self.lblPayCoinBalance.text ?? "") ?? 0.0
        print("swap1",self.swapperFee)
        let getbalance = Double(self.swapperFee) ?? 0.0
        print("getBalance",Double(self.swapperFee) ?? 0.0)
        let scientificNotationString = txtPay.text ?? ""
        if let doubleValue = convertScientificToDouble(scientificNotationString: scientificNotationString) {
            _ = WalletData.shared.formatDecimalString("\(doubleValue)", decimalPlaces: 10)
            _ = doubleValue  + getbalance
        print("newSwapperFee = ",getbalance)
                selectProvider(formattedPrice,self.providerName)

        } else {
            print("Invalid scientific notation string")
        }
    }
//    /// getExchangePairs
//     func getExchangePairs() {
//        DGProgressView.shared.showLoader(to: self.view)
//        var fromNetwork: String? {
//            switch payCoinDetail?.chain {
//            case .ethereum :
//                return "eth"
//            case .binanceSmartChain :
//                return "bsc"
//            case .oKC:
//                return "okc"
//            case .polygon:
//                return "pol"
//            case .bitcoin:
//                return "btc"
//            case .opMainnet:
//                return "Optimism"
//            case .arbitrum:
//                return "arb"
//            case .avalanche:
//                return "AVAX"
//            case.base:
//                return "Base"
////            case .tron:
////                return "TRON"
////            case .solana:
////                return "Solana"
//            case .none:
//                return ""
//            
//            }
//        }
//        self.getExchangePairsToken(fromCurrency: payCoinDetail?.symbol?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork[0])
//    }
}
extension SwapViewController {
    func uiSetUp() {
        self.btnSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""), for: .normal)
        btnSwap.titleLabel?.font = AppFont.violetRegular(18).value
        //lblMin.font = AppFont.regular(11.16).value
        lblHalf.font = AppFont.regular(11.16).value
        lblAll.font = AppFont.regular(11.16).value
        
        self.lblEstimateAmount.font = AppFont.regular(14).value
        self.lblInitiate.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.initiated, comment: "")
        self.lblSwapping.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swapping, comment: "")
        self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: "")
        self.lblBalance.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "")
        self.lblBalance2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "")
        self.lblYouGet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youget, comment: "")
        self.lblYouPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay, comment: "")
        self.btnMax.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: ""), for: .normal)
        self.lblBestPriceTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.bestprice, comment: "")
        lblBestPriceTitle.font = AppFont.regular(10.46).value
        lblBestProvider.font = AppFont.violetRegular(13.95).value
        lblAll.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.all, comment: "")
        lblHalf.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.half, comment: "")
        viewProvider.addTapGesture(target: self, action: #selector(providerTapped))
        viewProvider.isHidden = true
        lblChooseProvider.isHidden = true
        self.lblProviderSwapperFee.isHidden = true
        lblHalf.font = AppFont.regular(13.9).value
        lblAll.font = AppFont.regular(13.9).value
    }
    
}
extension SwapViewController {
    func networkString(for chain: Chain?) -> String {
        switch chain {
        case .ethereum:
            return "eth"
        case .binanceSmartChain:
            return "bsc"
        case .oKC:
            return "okc"
        case .polygon:
            return "pol"
        case .bitcoin:
            return "btc"
        case .opMainnet:
            if chain?.name == "Optimism".lowercased() {
                return "ETH".lowercased()
            } else {
                return "Optimism".lowercased()
            }
       
        case .avalanche:
            return "avalanche".lowercased()
        case .arbitrum:
            return "arbitrum"
        case.base:
            return "Base".lowercased()
//        case .tron:
//            return "TRON"
//        case .solana:
//            return "Solana"
        case .none:
            return ""
       
        }
    }
    func networkRangoString(for chain: Chain?) -> String {
        switch chain {
        case .ethereum:
            return "ETH"
        case .binanceSmartChain:
            return "BSC"
        case .oKC:
            return "OKT"
        case .polygon:
            return "POLYGON"
        case .bitcoin:
            return "BTC"
        case .opMainnet:  
//            if chain?.name == "Optimism" {
//                return "ETH"
//            } else {
//                return "Optimism".uppercased()
//            }
            return "Optimism".uppercased()
        case .avalanche:
            return "avalanche".uppercased()
        case .arbitrum:
//            if chain?.name == "Arbitrum" {
//                return "ETH".uppercased()
//            } else {
//                return "arbitrum".uppercased()
//            }
            return "arbitrum".uppercased()
        case.base:
//            if chain?.name == "Base" {
//                return "ETH".uppercased()
//            } else {
//                return "Base".uppercased()
//            }
           return "Base".uppercased()
//        case .tron:
//            return "TRON"
//        case .solana:
//            return "Solana"
       
        case .none:
            return ""
       
        }
      
    }
    
    fileprivate func rabgoProviderBestPrice(_ provider: SwapMeargedDataList, completion: @escaping () -> Void) {
        self.cachedSwapperFee = ""
        let firstItem = provider.response?.route
        let routerResult = firstItem?.outputAmount
        let errorCode = provider.response?.resultType
        self.rangoSwapQouteDetails = firstItem
        
        guard errorCode == "OK" else {
            completion() // Call completion even on failure to avoid blocking
            return
        }

        let url = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.images + (provider.image ?? "")
        self.providerImage = url

        self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
            defer { completion() } // <-- ✅ Ensures completion is always called after this block

            let decimalAmount = decimal ?? ""
            let number: Int64? = Int64(decimalAmount)
            let amountToGet = UnitConverter.convertWeiToEther(routerResult ?? "", Int(number ?? 0)) ?? ""
            
            guard let fees = firstItem?.fee else { return }

            let sums = fees.reduce(Decimal(0)) { total, feeItem in
                var feesAmount: Decimal = 0
                if feeItem.expenseType == "FROM_SOURCE_WALLET", feeItem.name == "Swapper Fee" {
                    feesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                  
                    if let tokenDecimals = feeItem.token?.decimals {
                        self.decimalsValue = tokenDecimals
                    }
                }
                return total + feesAmount
            }

            let swapperFees = UnitConverter.convertWeiToEther("\(sums)", Int(self.decimalsValue)) ?? ""

            self.cachedSwapperFee = swapperFees
            
            let sum1 = fees.reduce(Decimal(0)) { networkFeeTotal, feeItem in
                var networkFesAmount: Decimal = 0
                if feeItem.expenseType == "FROM_SOURCE_WALLET", feeItem.name == "Network Fee" {
                    networkFesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                    if let tokenDecimals = feeItem.token?.decimals {
                        self.decimalsValue = tokenDecimals
                    }
                }
                return networkFeeTotal + networkFesAmount
            }

            let networkFee = UnitConverter.convertWeiToEther("\(sum1)", Int(self.decimalsValue)) ?? ""
            self.networkFee = networkFee
            let bestPriceValue = Double(amountToGet)
            self.amountToGet = "\(bestPriceValue ?? 0.0)"
            self.bestPrice = bestPriceValue ?? 0.0
            self.providerName = "rangoexchange"
            self.provider = "rangoexchange"
        })
    }

    
    fileprivate func okxProviderBestPrice(_ provider: SwapMeargedDataList, completion: @escaping () -> Void) {
        _ = provider.response?.data
        let url = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.images + (provider.image ?? "")
        self.providerImage = url
        self.swapperFee = "0"
        let bestPriceValue = Double(provider.quoteAmount ?? "")
        self.bestPrice = bestPriceValue ?? 0.0
        self.providerName = "okx"
        self.provider = "okx"
        
        completion() // ✅ Notify the caller that you're done
    }
    fileprivate func exodusProviderBestPrice(_ provider: SwapMeargedDataList, completion: @escaping () -> Void) {
        _ = provider.response?.data
        let url = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.images + (provider.image ?? "")
        self.providerImage = url
        self.swapperFee = "0"
        let bestPriceValue = Double(provider.quoteAmount ?? "")
        self.bestPrice = bestPriceValue ?? 0.0
        self.providerName = "exodus"
        self.provider = "exodus"

        completion() // ✅ Important to signal that you're done
    }

    func swapQuote() {
        var fromNetwork: String? {
            return networkString(for: payCoinDetail?.chain)
        }
        var toNetwork: String? {
            return networkString(for: getCoinDetail?.chain)
        }
        let payTokenAddress = (payCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : payCoinDetail?.address ?? ""
        let getTokenAddress = (getCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : getCoinDetail?.address ?? ""
        var decimaamountToTransfer = ""
        var fromRangoNetwork: String? {
           
            return networkRangoString(for: payCoinDetail?.chain)
        }
        var toRangoNetwork: String? {
            return networkRangoString(for: getCoinDetail?.chain)
        }
        self.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
            
            decimaamountToTransfer = decimal ?? ""
            var amountToPay: BigInt = 0
            DispatchQueue.main.async {
                if let doubleValue = Double(decimaamountToTransfer) {
                    // Successfully converted the string to a double
                    amountToPay = UnitConverter.convertToWei(Double(self.txtPay.text ?? "") ?? 0.0, Double(doubleValue))
                } else {
                    // Conversion failed, handle the error or provide a default value
                    print("Failed to convert the string to a double")
                }
                var address = ""
                if self.getCoinDetail?.chain?.coinType == CoinType.bitcoin {
                    address = WalletData.shared.getPublicWalletAddress(coinType: .bitcoin) ?? ""
                } else {
                    address = WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? ""
                }
                self.viewModel.apiExchangeOkxRangoSwapQuote(parameters: SwapQuoteParameters(providerTypeChangeNow: "changeNow",providerTypeOkx:"okx",providerTypeRango:"rango",address:address,fromCurrency:self.lblCoinName.text?.lowercased() ?? "",toCurrency:self.lblGetCoinName.text?.lowercased() ?? "", fromNetwork:fromNetwork ?? "",toNetwork:toNetwork ?? "",fromAmount:self.txtPay.text ?? "",toAmount:"",chainId:self.payCoinDetail?.chain?.chainId ?? "",toTokenAddress:getTokenAddress,fromTokenAddress:payTokenAddress,slippage:"0.1",fromBlockchain:fromRangoNetwork,fromTokenSymbol:self.payCoinDetail?.symbol,toBlockchain:toRangoNetwork,toTokenSymbol:self.getCoinDetail?.symbol,rangotoTokenAddress:getTokenAddress,fromWalletAddress:address,toWalletAddress:address,price:"\(amountToPay)",amountToPay: "\(amountToPay)",mainAmount: self.txtPay.text ?? "")) { status, msg, data in
                    if status == true {
                        self.swapQuoteArr = data ?? []
                        // Unwrap the optional data array and loop through each item
                        if let dataValue = data {
                            let group = DispatchGroup()

                            for provider in dataValue {
                                //group.enter()

                                switch provider.providerName {
                                case "okx":
                                    self.okxProviderBestPrice(provider) {
                                        //group.leave()
                                    }
                                case "changenow":
                                    let url = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.images + (provider.image ?? "")
                                    self.providerImage = url
                                    self.swapperFee = "0"
                                    let bestPriceValue = Double(provider.quoteAmount ?? "")
                                    self.bestPrice = bestPriceValue ?? 0.0
                                    self.providerName = "changeNow"
                                    self.provider = "changeNow"
                                   // group.leave()

                                case "exodus":
                                    if let exodusResponse = provider.response {
                                        self.id = exodusResponse.id ?? ""
                                        self.payInAddress = exodusResponse.payInAddress ?? ""
                                        self.message = exodusResponse.message ?? ""
                                        self.status = exodusResponse.exodusStatus ?? ""
                                    } else {
                                        print("Exodus response is nil")
                                    }

                                    self.exodusProviderBestPrice(provider) {
                                       // group.leave()
                                    }
                                case "rangoexchange":
                                    self.rabgoProviderBestPrice(provider) {
                                       // group.leave()
                                    }
                                default:
                                    break
                                   // group.leave()
                                }
                            }
                            self.getBestPriceFromAllBestPrices()
                            // ✅ This will run after ALL providers have been processed
//                            group.notify(queue: .main) {
//                                self.getBestPriceFromAllBestPrices()
//                            }
                        }
                      else {
                            print("Error")
                        }
                    } else {
                        self.showToast(message: msg, font: AppFont.regular(15).value)
                        self.txtGet.hideLoading()
                    }
                }
                
            }
        })
    }
}
