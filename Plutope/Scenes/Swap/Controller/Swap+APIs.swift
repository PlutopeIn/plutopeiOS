//
//  Swap+APIs.swift
//  Plutope
//
//  Created by Priyanka Poojara on 28/06/23.
//

import UIKit
import BigInt
import Web3

// MARK: Swapping APIS
extension SwapViewController {
    
    func getExchangePairsToken(fromCurrency: String, fromNetwork: String, toNetwork: String) {
        
        viewModel.apiGetExchangePairs(fromCurrency: fromCurrency, fromNetwork: fromNetwork, toNetwork: toNetwork) { tokenPairs, status, _ in
            if status {
               // self.index += 1
                self.pairData.append(contentsOf: tokenPairs ?? [])
                self.pairData = Array(Set(self.pairData))
                
                let toCurrencyList = self.pairData.compactMap { $0.toCurrency }
                
                self.tokensList = self.tokensList?.filter({ token in
                    if toCurrencyList.contains(token.symbol?.lowercased() ?? "") && (token.type == "ERC20" || token.type == "POLYGON" || token.type == "BEP20" || token.type == "BTC") && token != self.payCoinDetail {
                        return true
                    } else {
                        return false
                    }
                    
                })
               
                if self.tokensList?.count != 0 {
                    self.getCoinDetail = self.tokensList?[0]
                    self.setCoinDetail()
                }
                DGProgressView.shared.hideLoader()
            } else {
                DGProgressView.shared.hideLoader()
                self.setOkxToken()
            }
        }
    }
    
    private func apiGetTransactionStatus(transactionID: String?) {
        DispatchQueue.main.async {
            
            self.viewModel.apiGetTransactionStatus(transactionID ?? "") { status, statuserr, resp in
                
                if status {
                    
                    let transactionStatus = resp?["status"] as? String
                    
                    if transactionStatus == "finished" {
                        for views in self.viewProgress {
                            views.backgroundColor = UIColor.c00C6FB
                        }
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = UIColor.c75769D
                        self.lblSuccessFail.textColor = .white
//                        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
//
//                        }
                        DispatchQueue.main.async {
                            self.showToast(message: "Successfully Swap", font: .systemFont(ofSize: 15))
                            self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.dismiss(animated: true, completion: nil)
                                self.refreshData()
                            }
                        }
                        
                    } else if transactionStatus == "failed" {
                        DispatchQueue.main.async {
                            for views in self.viewProgress {
                                views.backgroundColor = .red
                            }
                            self.showToast(message: transactionStatus ?? "", font: .systemFont(ofSize: 15))
                            self.lblInitiate.textColor = UIColor.c75769D
                            self.lblSwapping.textColor = UIColor.c75769D
                            self.lblSuccessFail.textColor = .red
                            self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: "")
                            self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        
                        if transactionStatus == "confirming" || transactionStatus == "exchanging" {
                        } else if transactionStatus == "waiting" {
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.apiGetTransactionStatus(transactionID: transactionID)
                        }
                    }
                } else {
                   
                }
            }
        }
    }
    
    func refreshData() {
        guard let walletDash = self.navigationController?.viewControllers.first(where: { $0 is WalletDashboardViewController }) as? WalletDashboardViewController else {
            // WalletDashboardViewController not found in the navigation stack
            return
        }
        
        updatebalDelegate = walletDash
        updatebalDelegate?.refreshData()
        
        if let tabBarController = self.tabBarController, tabBarController.selectedIndex != 1 && tabBarController.selectedIndex < tabBarController.viewControllers?.count ?? 0 {
            tabBarController.selectedIndex = 1
        }
        
        self.navigationController?.popToViewController(walletDash, animated: false)
    }
    fileprivate func sendBtc(_ toAmount: Double?, _ payInAdd: String?,_ transactionID: String? = nil) {
        self.sendViewModel.sendBTCApi(privateKey: self.encryptedKey, value: "\(toAmount ?? 0.0)", toAddress:"\(payInAdd ?? "")" , env: "testnet", fromAddress: self.payCoinDetail?.chain?.walletAddress ?? "") { statusResult, message, resData in
            if statusResult == 1 {
                self.transactionID = transactionID
                DispatchQueue.main.async {
                    self.setCoinDetail()
                    self.btnSwap.HideLoader()
                    DGProgressView.shared.hideLoader()
                    let presentInfoVc = PushNotificationViewController()
                    presentInfoVc.alertData = .swapping
                    presentInfoVc.modalTransitionStyle = .crossDissolve
                    presentInfoVc.modalPresentationStyle = .overFullScreen
                    presentInfoVc.okAction = {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.present(presentInfoVc, animated: true, completion: nil)
                    self.apiGetTransactionStatus(transactionID: self.transactionID)
                }
            } else {
                DispatchQueue.main.async {
                    self.showToast(message: message , font: .systemFont(ofSize: 15))
                    self.btnSwap.HideLoader()
                    DGProgressView.shared.hideLoader()
                    
                }
            }
        }
    }
    
    func swappingPreview() {
        
        var fromNetwork: String? {
            switch payCoinDetail?.chain {
                
            case .ethereum :
                return "eth"
            case .binanceSmartChain :
                return "bsc"
            case .oKC:
                return "okc"
            case .polygon:
                return "matic"
            case .bitcoin:
                return "btc"
            case .none:
                return ""
            }
        }
        var toNetwork: String? {
            switch getCoinDetail?.chain {
                
            case .ethereum :
                return "eth"
            case .binanceSmartChain :
                return "bsc"
            case .oKC:
                return "okc"
            case .polygon:
                return "matic"
            case .bitcoin:
                return "btc"
            case .none:
                return ""
            }
        }
//         viewModel.apiSwapping(address: WalletData.shared.wallet?.getAddressForCoin(coin: .ethereum) ?? "", fromCurrency: lblCoinName.text?.lowercased() ?? "", toCurrency: lblGetCoinName.text?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork ?? "", fromAmount: txtPay.text ?? "", toAmount: "")
        viewModel.apiSwapping(address: WalletData.shared.myWallet?.address ?? "", fromCurrency: lblCoinName.text?.lowercased() ?? "", toCurrency: lblGetCoinName.text?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork ?? "", fromAmount: txtPay.text ?? "", toAmount: "") { status, swaperr, data in
            
            if status {
                let payInAdd = data?["payinAddress"] as? String
                let transactionID = data?["id"] as? String
                let errorMessage = data?["message"] as? String
                let toAmount = data?["toAmount"] as? Double
                
                let payoutAddress = data?["payoutAddress"] as? String
                print(data!)
                
                if errorMessage == nil {
                    if self.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
                        self.sendBtc(toAmount, payInAdd,transactionID ?? "")
                    } else {
                    self.payCoinDetail?.callFunction.sendTokenOrCoin(payInAdd, tokenAmount: Double(self.txtPay.text ?? "") ?? 0.0) { status, transfererror, data in
                        if status {
                            self.transactionID = transactionID
                            DispatchQueue.main.async {
                                self.setCoinDetail()
                                self.btnSwap.HideLoader()
                                DGProgressView.shared.hideLoader()
                                let presentInfoVc = PushNotificationViewController()
                                presentInfoVc.alertData = .swapping
                                presentInfoVc.modalTransitionStyle = .crossDissolve
                                presentInfoVc.modalPresentationStyle = .overFullScreen
                                presentInfoVc.okAction = {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                self.present(presentInfoVc, animated: true, completion: nil)
                                self.apiGetTransactionStatus(transactionID: self.transactionID)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showToast(message: transfererror ?? "", font: .systemFont(ofSize: 15))
                                self.btnSwap.HideLoader()
                                DGProgressView.shared.hideLoader()
                            }
                        }
                    }
                  }// else
                } else {
                    DispatchQueue.main.async {
                        self.showToast(message: errorMessage ?? "", font: .systemFont(ofSize: 15))
                        self.btnSwap.HideLoader()
                        DGProgressView.shared.hideLoader()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
                    self.btnSwap.HideLoader()
                    DGProgressView.shared.hideLoader()
                }
            }
        }
    }
    
    fileprivate func openPopUp() {
        DispatchQueue.main.async {
            let presentInfoVc = PushNotificationViewController()
            let newFrontController = UINavigationController(rootViewController: presentInfoVc)
            presentInfoVc.alertData = .swapping
            presentInfoVc.modalTransitionStyle = .crossDissolve
            presentInfoVc.modalPresentationStyle = .overFullScreen
            presentInfoVc.okAction = {
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.present(newFrontController, animated: true, completion: nil)
        }
    }
    fileprivate func closePopUpOnSucess() {
       // DispatchQueue.main.async {
            self.btnSwap.HideLoader()
            DGProgressView.shared.hideLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true) {
                    self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: ""), font: .systemFont(ofSize: 15))
                    self.refreshData()
                }
            }
       // }
    }
    fileprivate func closePopUpOnFailler() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.btnSwap.HideLoader()
            DGProgressView.shared.hideLoader()
            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: ""), font: .systemFont(ofSize: 15))
            self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: "")
            self.btnSwap.HideLoader()
            self.dismiss(animated: true, completion: nil)
        }
    }
    /// oKTswappingPreview
    func oKTswappingPreview() {
        let payTokenAddress = (payCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : payCoinDetail?.address ?? ""
        let getTokenAddress = (getCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : getCoinDetail?.address ?? ""
        var decimaamountToTransfer = ""
        self.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
            decimaamountToTransfer = decimal ?? ""
            var amountToPay: BigInt = 0
            DispatchQueue.main.async {
                if let doubleValue = Double(decimaamountToTransfer) {
                    // Successfully converted the string to a double
                    print("Double value: \(doubleValue)")
                    amountToPay = UnitConverter.convertToWei(Double(self.txtPay.text ?? "") ?? 0.0, Double(doubleValue))
                } else {
                    // Conversion failed, handle the error or provide a default value
                    print("Failed to convert the string to a double")
                }
                self.viewModel.apiOKTSwapping(fromTokenAddress: payTokenAddress, toTokenAddress: getTokenAddress, amount: "\(amountToPay)", chainId: self.payCoinDetail?.chain?.chainId ?? "", userWalletAddress: self.payCoinDetail?.chain?.walletAddress ?? "", slippage: "0.1") { status, swaperr, response in
                    if status {
                        do {
                            let jsonResponse = try JSONSerialization.data(withJSONObject: response)
                            let swapData = try JSONDecoder().decode(SwapData.self, from: jsonResponse)
                            
                            let firstItem = swapData.data?.first
                            let tx = firstItem?.tx
                            let payInAdd = tx?.to ?? ""
                            let routerResult = firstItem?.routerResult
                            _ = routerResult?.toTokenAmount ?? ""
                            let errorCode = swapData.code ?? ""
                            let errorMessage = swapData.msg ?? ""
                            let rawData = tx?.data ?? ""
                            let gas = tx?.gas ?? ""
                            let gasPrice = tx?.gasPrice ?? ""
                            
                            if errorCode == "0" {
                                self.openPopUp()
                                self.payCoinDetail?.callFunction.swapTokenOrCoin(payInAdd, gas: gas, gasPrice: gasPrice, rawData: rawData,tokenAmount: self.txtPay.text ?? "") { status,transfererror,_ in
                                     
                                    if status {
                                        DispatchQueue.main.async {
                                            for views in self.viewProgress {
                                                views.backgroundColor = UIColor.c00C6FB
                                            }
                                            self.lblInitiate.textColor = UIColor.c75769D
                                            self.lblSwapping.textColor = UIColor.c75769D
                                            self.lblSuccessFail.textColor = .white
//                                            self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
//
//                                            }
                                            self.closePopUpOnSucess()
//                                            DispatchQueue.main.async {
//                                               // self.showToast(message: "Successfully Swap", font: .systemFont(ofSize: 15))
//                                               // self.btnSwap.HideLoader()
//                                              //  DGProgressView.shared.hideLoader()
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                                    self.dismiss(animated: true, completion: nil)
//                                                    self.updatebalDelegate?.refreshData()
//                                                }
//                                            }
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            for views in self.viewProgress {
                                                views.backgroundColor = .red
                                            }
                                           // self.showToast(message: "Failed", font: .systemFont(ofSize: 15))
                                            self.lblInitiate.textColor = UIColor.c75769D
                                            self.lblSwapping.textColor = UIColor.c75769D
                                            self.lblSuccessFail.textColor = .red
                                            
                                            self.closePopUpOnFailler()
                                          //  self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: "")
                                          //  self.btnSwap.HideLoader()
                                          //  DGProgressView.shared.hideLoader()
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                                self.dismiss(animated: true, completion: nil)
//                                            }
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showToast(message: errorMessage , font: .systemFont(ofSize: 15))
                                    self.btnSwap.HideLoader()
                                    DGProgressView.shared.hideLoader()
                                    //self.closePopUp()
                                }
                            }
                        } catch(let error) {
                            print(error)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
                            self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                        }
                    }
                }
            }
        })
    }
    
    func apiOkxSwapApprove() {
        
        let payTokenAddress = (payCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : payCoinDetail?.address ?? ""
        var decimaamountToTransfer = ""
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
                self.viewModel.apiOKTApproveSwap(tokenContractAddress: payTokenAddress, approveAmount: "\(amountToPay)", chainId: self.payCoinDetail?.chain?.chainId ?? "") { status, swaperr, response in
                    
                    if status {
                        let data = response?["data"] as? [[String: Any]]
                        let firstItem = data?.first
                        let dexContractAddress = firstItem?["dexContractAddress"] as? String
                        let gasPrice = firstItem?["gasPrice"] as? String ?? ""
                        let gasLimit = firstItem?["gasLimit"] as? String ?? ""
                        let errorCode = response?["code"] as? String
                        let errorMessage = response?["msg"] as? String
                        if errorCode == "0" {
                            self.payCoinDetail?.callFunction.approveTransactionForSwap(gasLimit,gasPrice,dexContractAddress, tokenAmount: Double(self.txtPay.text ?? "") ?? 0.90) { status,transfererror,_ in
                                if status {
                                    DispatchQueue.main.async {
                                        for views in [self.viewProgress[0],self.viewProgress[1],self.viewProgress[2]] {
                                            views.backgroundColor = UIColor.c00C6FB
                                        }
                                        self.lblInitiate.textColor = UIColor.c75769D
                                        self.lblSwapping.textColor = .white
                                        self.oKTswappingPreview()
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showToast(message: transfererror ?? "", font: .systemFont(ofSize: 15))
                                        self.btnSwap.HideLoader()
                                        DGProgressView.shared.hideLoader()
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showToast(message: errorMessage ?? "", font: .systemFont(ofSize: 15))
                                self.btnSwap.HideLoader()
                                DGProgressView.shared.hideLoader()
                            }
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
                            self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                        }
                    }
                }
            }
        })
    }
    
    /// oKTswappingPreview
    func oKTswappingQuote() {
        let payTokenAddress = (payCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : payCoinDetail?.address ?? ""
        let getTokenAddress = (getCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : getCoinDetail?.address ?? ""
        var decimaamountToTransfer = ""
        self.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
            print("decimal",decimal ?? 0.0)
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
                self.viewModel.apiOKTSwapping(fromTokenAddress: payTokenAddress, toTokenAddress: getTokenAddress, amount: "\(amountToPay)", chainId: self.payCoinDetail?.chain?.chainId ?? "", userWalletAddress: self.payCoinDetail?.chain?.walletAddress ?? "", slippage: "0.1") { status, swaperr, response in
                    if status {
                        do {
                            let jsonResponse = try JSONSerialization.data(withJSONObject: response)
                            let swapData = try JSONDecoder().decode(SwapData.self, from: jsonResponse)
                            let firstItem = swapData.data?.first
                            let routerResult = firstItem?.routerResult
                            
                            let errorCode = swapData.code ?? ""
                            _ = swapData.msg ?? ""
                            self.swapQouteDetail = swapData.data ?? []
                            print(response ?? [:])
                            
                            if errorCode == "0" {
                                // Get Dynamic Decimals
                                var decimalAmount = ""
                                self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                                    print("decimal",decimal ?? "")
                                    decimalAmount = decimal ?? ""
                                    let number: Int64? = Int64(decimalAmount)
                                    let amountToGet = UnitConverter.convertWeiToEther(routerResult?.toTokenAmount ?? "",Int(number ?? 0)) ?? ""
                                    if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.okx }) {
                                        let bestPrice = Double(amountToGet)
                                        self.allProviders[providerIndex].bestPrice = "\(bestPrice ?? 0.0)"
                                        self.checkAllAPIsCompleted()
                                    }
                                })
                                
                            } else {
                                if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.okx }) {
                                    self.allProviders[providerIndex].bestPrice = "0.0"
                                    self.checkAllAPIsCompleted()
                                }
                            }
                        } catch(let error) {
                            print(error)
                            self.checkAllAPIsCompleted()
                        }
                    } else {
                        self.checkAllAPIsCompleted()
                    }
                }
            }
        })
    }

    func changeNowSwapQuote() {
        
        var fromNetwork: String? {
            switch payCoinDetail?.chain {
                
            case .ethereum :
                return "eth"
            case .binanceSmartChain :
                return "bsc"
            case .oKC:
                return "okc"
            case .polygon:
                return "matic"
            case .bitcoin:
                return "btc"
            case .none:
                return ""
           
            }
        }
        var toNetwork: String? {
            switch getCoinDetail?.chain {
                
            case .ethereum :
                return "eth"
            case .binanceSmartChain :
                return "bsc"
            case .oKC:
                return "okc"
            case .polygon:
                return "matic"
            case .bitcoin:
                return "btc"
            case .none:
                return ""
           
            }
        }
        
//        viewModel.apiSwapping(address: WalletData.shared.wallet?.getAddressForCoin(coin: .ethereum) ?? "", fromCurrency: lblCoinName.text?.lowercased() ?? "", toCurrency: lblGetCoinName.text?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork ?? "", fromAmount: txtPay.text ?? "", toAmount: "")
//        let address = (payCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : payCoinDetail?.address ?? ""
        if getCoinDetail?.chain?.coinType == CoinType.bitcoin {
            viewModel.apiSwapping(address: WalletData.shared.walletBTC?.address ?? "", fromCurrency: lblCoinName.text?.lowercased() ?? "", toCurrency: lblGetCoinName.text?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork ?? "", fromAmount: txtPay.text ?? "", toAmount: "") { status, swaperr, data in
                
                if status {
                    let toAmount = data?["toAmount"] as? Double
                    let errorMessage = data?["message"] as? String
                    if errorMessage == nil {
                        
                        if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.changeNow }) {
                            let bestPrice = Double(toAmount ?? 0.0)
                            self.allProviders[providerIndex].bestPrice = "\(bestPrice )"
                            self.allProviders[providerIndex].swapperFee = ""
                            self.checkAllAPIsCompleted()
    }
                    } else {
                        self.checkAllAPIsCompleted()
                    }
                 
                } else {
                    self.checkAllAPIsCompleted()
                }
            }
        } else {
            viewModel.apiSwapping(address: WalletData.shared.myWallet?.address ?? "", fromCurrency: lblCoinName.text?.lowercased() ?? "", toCurrency: lblGetCoinName.text?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork ?? "", fromAmount: txtPay.text ?? "", toAmount: "") { status, swaperr, data in
                
                if status {
                    let toAmount = data?["toAmount"] as? Double
                    let errorMessage = data?["message"] as? String
                    if errorMessage == nil {
                        
                        if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.changeNow }) {
                            let bestPrice = Double(toAmount ?? 0.0)
                            self.allProviders[providerIndex].bestPrice = "\(bestPrice )"
                            self.allProviders[providerIndex].swapperFee = ""
                            self.checkAllAPIsCompleted()
    }
                    } else {
                        self.checkAllAPIsCompleted()
                    }
                 
                } else {
                    self.checkAllAPIsCompleted()
                }
            }
        }
        
        
        
    }
   // rango Swap Quote
    fileprivate func rangoSwapQuoteForBTC(_ amount: String, _ fromAddress: String, _ toAddress: String) {
        viewModel.apiRangoQuoteSwapping(address: WalletData.shared.walletBTC?.address ?? "", fromToken: self.payCoinDetail!, toToken:self.getCoinDetail!,  fromAmount: amount,fromWalletAddress: fromAddress,toWalletAddress: toAddress) { status, swaperr,reqType,data in
            
            if status {
                do {
                    //                            let jsonResponse = try JSONSerialization.data(withJSONObject: data)
                    //                            let swapData = try JSONDecoder().decode(RangoSwapData.self, from: jsonResponse)
                    let firstItem = data
                    let routerResult = firstItem?.outputAmount
                    
                    let errorCode = reqType
                    _ = swaperr
                    self.rangoSwapQouteDetail = data
                    print(data ?? [:])
                    
                    if errorCode == "OK" {
                        
                        // Get Dynamic Decimals
                        var decimalAmount = ""
                        self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                            print("decimal",decimal ?? 0.0)
                            decimalAmount = decimal ?? ""
                            let number: Int64? = Int64(decimalAmount)
                            let amountToGet = UnitConverter.convertWeiToEther(routerResult ?? "",Int(number ?? 0)) ?? ""
                            //                                    // Calculate the sum of the "amount" values
                            //                                    let sum = firstItem?.fee?.reduce(0) { total, feeItem in
                            //                                        total + (Int(feeItem.amount ?? "") ?? 0)
                            //                                        }
                            
                            if let fees = firstItem?.fee {
                                // Calculate the sum of the "amount" values
                                let sum = fees.reduce(Decimal(0)) { total, feeItem in
                                    var feesAmount: Decimal = 0
                                    
                                    if feeItem.expenseType == "FROM_SOURCE_WALLET" && feeItem.name == "Swapper Fee" {
                                        feesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                                        print("feeItem.amount",feeItem.amount ?? "")
                                        
                                        if let tokenDecimals = feeItem.token?.decimals {
                                            self.decimalsValue =    tokenDecimals
                                        }
                                    } else {
                                        feesAmount = 0
                                    }
                                    
                                    return total + feesAmount
                                }
                                
                                print("Sum of amounts: \(sum)")
                                
                                //                                        let tokenDecimals = firstItem?.fee?.first?.token?.decimals
                                let swapperFees = UnitConverter.convertWeiToEther("\(sum )", Int(self.decimalsValue)) ?? ""
                                print("swapperFee =", swapperFees)
                                self.swapperFee = swapperFees
                                
                                if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.rangoSwap }) {
                                   
                                    let bestPrices = Double(amountToGet) ?? 0.0

                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.numberStyle = .decimal
                                    numberFormatter.maximumFractionDigits = 15 // Adjust this as needed

                                    if let formattedString = numberFormatter.string(from: NSNumber(value: bestPrices)) {
                                        print(formattedString) // Prints: 0.000000000000558978
                                        let bestPrice = Double(formattedString)
                                        self.allProviders[providerIndex].bestPrice = "\(bestPrice ?? 0.0)"
                                        self.allProviders[providerIndex].swapperFee = "\(swapperFees)"
                                        self.checkAllAPIsCompleted()
                                    }
                                }
                            }
                            // Now feesAmount contains the sum of all amounts in the loop
                        })
                        
                    } else {
                        self.checkAllAPIsCompleted()
                    }
                } catch(let error) {
                    print(error)
                    self.checkAllAPIsCompleted()
                }
            } else {
                self.checkAllAPIsCompleted()
            }
        }
    }
    
    func rangoSwapQuote() {
        var decimaamountToTransfer = ""
        self.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
            print("decimal",decimal ?? 0.0)
            decimaamountToTransfer = decimal ?? ""
            var amountToPay: BigInt = 0
            DispatchQueue.main.async { [self] in
                if let doubleValue = Double(decimaamountToTransfer) {
                    // Successfully converted the string to a double
                    print("Double value: \(doubleValue)")
                    amountToPay = UnitConverter.convertToWei(Double(self.txtPay.text ?? "") ?? 0.0, Double(doubleValue))
                } else {
                    // Conversion failed, handle the error or provide a default value
                    print("Failed to convert the string to a double")
                }
                
                let amount = "\(amountToPay)"
                
                let fromAddress = (payCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : payCoinDetail?.address ?? ""
                let toAddress = (getCoinDetail?.address ?? "") == "" ? StringConstants.defaultAddress : getCoinDetail?.address ?? ""
                //                viewModel.apiRangoQuoteSwapping(address: WalletData.shared.wallet?.getAddressForCoin(coin: .ethereum) ?? "", fromToken: self.payCoinDetail!, toToken:self.getCoinDetail!,  fromAmount: amount)
               // if getCoinDetail?.chain?.coinType == CoinType.bitcoin {
                   // rangoSwapQuoteForBTC(amount, fromAddress, toAddress)
               // } else {
                    viewModel.apiRangoQuoteSwapping(address: WalletData.shared.myWallet?.address ?? "", fromToken: self.payCoinDetail!, toToken:self.getCoinDetail!,  fromAmount: amount,fromWalletAddress: fromAddress,toWalletAddress: toAddress) { status, swaperr,reqType,data in
                        
                        if status {
                            do {
                                //                            let jsonResponse = try JSONSerialization.data(withJSONObject: data)
                                //                            let swapData = try JSONDecoder().decode(RangoSwapData.self, from: jsonResponse)
                                let firstItem = data
                                let routerResult = firstItem?.outputAmount
                                
                                let errorCode = reqType
                                _ = swaperr
                                self.rangoSwapQouteDetail = data
                                print(data ?? [:])
                                
                                if errorCode == "OK" {
                                    
                                    // Get Dynamic Decimals
                                    var decimalAmount = ""
                                    self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                                        print("decimal",decimal ?? 0.0)
                                        decimalAmount = decimal ?? ""
                                        let number: Int64? = Int64(decimalAmount)
                                        let amountToGet = UnitConverter.convertWeiToEther(routerResult ?? "",Int(number ?? 0)) ?? ""
                                        //                                    // Calculate the sum of the "amount" values
                                        //                                    let sum = firstItem?.fee?.reduce(0) { total, feeItem in
                                        //                                        total + (Int(feeItem.amount ?? "") ?? 0)
                                        //                                        }
                                        
                                        if let fees = firstItem?.fee {
                                            // Calculate the sum of the "amount" values
                                            let sum = fees.reduce(Decimal(0)) { total, feeItem in
                                                var feesAmount: Decimal = 0
                                                
                                                if feeItem.expenseType == "FROM_SOURCE_WALLET" && feeItem.name == "Swapper Fee" {
                                                    feesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                                                    print("feeItem.amount",feeItem.amount ?? "")
                                                    
                                                    if let tokenDecimals = feeItem.token?.decimals {
                                                        self.decimalsValue =    tokenDecimals
                                                    }
                                                } else {
                                                    feesAmount = 0
                                                }
                                                
                                                return total + feesAmount
                                            }
                                            
                                            print("Sum of amounts: \(sum)")
                                            
                                            //                                        let tokenDecimals = firstItem?.fee?.first?.token?.decimals
                                            let swapperFees = UnitConverter.convertWeiToEther("\(sum )", Int(self.decimalsValue)) ?? ""
                                            print("swapperFee =", swapperFees)
                                            self.swapperFee = swapperFees
                                            
                                            if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.rangoSwap }) {
                                                let bestPrice = Double(amountToGet)
                                                self.allProviders[providerIndex].bestPrice = "\(bestPrice ?? 0.0)"
                                                self.allProviders[providerIndex].swapperFee = "\(swapperFees)"
                                                self.checkAllAPIsCompleted()
                                            }
                                        }
                                        // Now feesAmount contains the sum of all amounts in the loop
                                        
                                    })
                                    
                                } else {
                                    self.checkAllAPIsCompleted()
                                }
                            } catch(let error) {
                                print(error)
                                self.checkAllAPIsCompleted()
                            }
                        } else {
                            self.checkAllAPIsCompleted()
                        }
                    }
            //}
            }
        })
    }
    
    func rangoSwapExchange(completion: @escaping ((Bool,String,String,String,String) -> Void)) {
        
        var decimaamountToTransfer = ""
        self.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
            print("decimal",decimal ?? 0.0)
            decimaamountToTransfer = decimal ?? ""
            var amountToPay: BigInt = 0
            DispatchQueue.main.async { [self] in
                if let doubleValue = Double(decimaamountToTransfer) {
                    // Successfully converted the string to a double
                    print("Double value: \(doubleValue)")
                    amountToPay = UnitConverter.convertToWei(Double(self.txtPay.text ?? "") ?? 0.0, Double(doubleValue))
                } else {
                    // Conversion failed, handle the error or provide a default value
                    print("Failed to convert the string to a double")
                }
                let amount = "\(amountToPay)"
                viewModel.apiRangoSwapping(address: WalletData.shared.myWallet?.address ?? "", fromToken: payCoinDetail!, toToken:getCoinDetail!,  fromAmount: amount,fromWalletAddress:self.payCoinDetail?.chain?.walletAddress ?? "",toWalletAddress:self.getCoinDetail?.chain?.walletAddress ?? "") { status, swaperr,data in
                    if status {
                        do {
                            let jsonResponse = try JSONSerialization.data(withJSONObject: data ?? [:])
                            let swapData = try JSONDecoder().decode(RangoSwapingData.self, from: jsonResponse)
                            let firstItem = swapData
                            let routerResult = firstItem.route?.outputAmount
                            let errorCode = firstItem.resultType
                            let errorMsg = firstItem.error
                            _ = swaperr
                            self.rangoSwapExchangeDetail = swapData.route
                            print(data ?? [:])
                            if errorCode == "OK" {
                                var decimalAmount = ""
                                self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                                    print("decimal",decimal ?? 0.0)
                                    decimalAmount = decimal ?? ""
                                    let number: Int64? = Int64(decimalAmount)
                                   let amountToGet = UnitConverter.convertWeiToEther(routerResult ?? "",Int(number ?? 0)) ?? ""
                                    self.amountToGet = amountToGet
//                                    // Calculate the sum of the "amount" values
//                                    let sum = firstItem?.fee?.reduce(0) { total, feeItem in
//                                        total + (Int(feeItem.amount ?? "") ?? 0)
//                                        }
                                    
                                    if let fees = firstItem.route?.fee {
                                                // Calculate the sum of the "amount" values
                                                let sum = fees.reduce(Decimal(0)) { total, feeItem in
                                                    var feesAmount: Decimal = 0

                                                    if feeItem.expenseType == "FROM_SOURCE_WALLET" && feeItem.name == "Swapper Fee" {
                                                        feesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                                                        print("feeItem.amount",feeItem.amount ?? "")
                                                        
                                                        if let tokenDecimals = feeItem.token?.decimals {
                                                            self.decimalsValue =    tokenDecimals
                                                                }
                                                    } else {
                                                        feesAmount = 0
                                                    }
                                                    return total + feesAmount
                                                }
                                        
                                                print("Sum of amounts: \(sum)")
                                        let sum1 = fees.reduce(Decimal(0)) { networkfeeTotal ,feeItem in
                                          
                                            var networkFesAmount: Decimal = 0
                                            if feeItem.expenseType == "FROM_SOURCE_WALLET" && feeItem.name == "Network Fee" {
                                                networkFesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                                                print("feeItem.amount",feeItem.amount ?? "")
                                                
                                                if let tokenDecimals = feeItem.token?.decimals {
                                                    self.decimalsValue =    tokenDecimals
                                                        }
                                            } else {
                                                networkFesAmount = 0
                                            }

                                            return networkfeeTotal + networkFesAmount
                                        }
                                        
                                        print("Sum1 of amounts: \(sum1)")
                                        
//                                        let tokenDecimals = firstItem?.fee?.first?.token?.decimals
                                        let swapperFees = UnitConverter.convertWeiToEther("\(sum )", Int(self.decimalsValue)) ?? ""
                                        let networkFee =  UnitConverter.convertWeiToEther("\(sum1 )", Int(self.decimalsValue)) ?? ""
                                        print("swapperFee =", swapperFees)
                                        print("networkFee =", networkFee)
                                        self.newSwapperFee = swapperFees
                                        self.networkFee = networkFee
                                        completion(true,swapperFees,amountToGet, errorMsg ?? "",networkFee)
                                    } else {
                                        completion(false,"0",self.amountToGet,errorMsg ?? "",self.networkFee)
                                    }
                                    // Now feesAmount contains the sum of all amounts in the loop

                                })
                               
                            } else {
                                completion(false,"0",self.amountToGet,errorMsg ?? "",self.networkFee)
                            }
                            
                            if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                                _ = allToken.filter { $0.address == "" && $0.type == self.payCoinDetail?.type && $0.symbol == self.payCoinDetail?.chain?.symbol ?? "" }
                                
                             }
                            DGProgressView.shared.hideLoader()
                            
                        } catch(let error) {
                            print(error)
                            DGProgressView.shared.hideLoader()
                           // self.btnSwap.HideLoader()
                        }
                        print(data!)
                        
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
                          //  self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                        }
                    }
                    
                }
            }
        })
    }
   
    // rango Swap
     func rangoSwap() {
         
         var decimaamountToTransfer = ""
         self.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
             print("decimal",decimal ?? 0.0)
             decimaamountToTransfer = decimal ?? ""
             var amountToPay: BigInt = 0
             DispatchQueue.main.async { [self] in
                 if let doubleValue = Double(decimaamountToTransfer) {
                     // Successfully converted the string to a double
                     print("Double value: \(doubleValue)")
                     amountToPay = UnitConverter.convertToWei(Double(self.txtPay.text ?? "") ?? 0.0, Double(doubleValue))
                 } else {
                     // Conversion failed, handle the error or provide a default value
                     print("Failed to convert the string to a double")
                 }
                 let amount = "\(amountToPay)"
                 
//                  viewModel.apiRangoSwapping(address: WalletData.shared.wallet?.getAddressForCoin(coin: .ethereum) ?? "", fromToken: payCoinDetail!, toToken:getCoinDetail!,  fromAmount: amount )
                 viewModel.apiRangoSwapping(address: WalletData.shared.myWallet?.address ?? "", fromToken: payCoinDetail!, toToken:getCoinDetail!,  fromAmount: amount,fromWalletAddress:self.payCoinDetail?.chain?.walletAddress ?? "",toWalletAddress:self.getCoinDetail?.chain?.walletAddress ?? "") { status, swaperr, data in
                     if status {
                         do {
                             let jsonResponse = try JSONSerialization.data(withJSONObject: data ?? [:])
                             let swapData = try JSONDecoder().decode(RangoSwapingData.self, from: jsonResponse)
                             let tx = swapData.tx
                             let txTo = tx?.txTo ?? ""
                             _ = tx?.approveTo
                             let approveData = tx?.approveData ?? ""
                             let txData = tx?.txData ?? ""
                             if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                                 _ = allToken.filter { $0.address == "" && $0.type == self.payCoinDetail?.type && $0.symbol == self.payCoinDetail?.chain?.symbol ?? "" }
                             
                              self.payCoinDetail?.callFunction.getGasPrice(completion: { status,gasFee,gasPrice,gasLimit,data  in
                                         if status {
                                             print(gasFee ?? "")
                                             _ = gasFee
                                             self.gasPrice = tx?.gasPrice ?? ( tx?.maxGasPrice ?? "")
                                             self.gasLimit = tx?.gasLimit ?? "250000"
                                             let errorCode = swapData.resultType ?? ""
                                             let errorMessage = swapData.error ?? ""
                                             if (errorCode == "OK"  && txData != "") {
                                                 self.openPopUp()
                                                 // check if approveData is null
                                                 if approveData != "" {
                                                     self.rangoApproveTranscation( amount: amount, gasLimit: self.gasLimit, self.gasPrice , approveTo: txTo, txTo: txTo, txData: txData,  txValue: tx?.value ?? "")
                                                     
                                                 } else {
                                                     self.rangoSendTranscation(receiverAddress: txTo, txData: txData, gas: self.gasLimit, gasPrice: self.gasPrice , txValue: tx?.value ?? "")
                                                 }
                                                // self.btnSwap.HideLoader()
                                                // DGProgressView.shared.hideLoader()
                                             } else {
                                                 DispatchQueue.main.async {
                                                     self.showToast(message: errorMessage , font: .systemFont(ofSize: 15))
                                                     self.btnSwap.HideLoader()
                                                     DGProgressView.shared.hideLoader()
                                                 }
                                             }
                                         }
                                         
                                     })
                              }
                         } catch(let error) {
                             print(error)
                             self.btnSwap.HideLoader()
                         }
                         print(data!)
                         
                     } else {
                         DispatchQueue.main.async {
                             self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
                             self.btnSwap.HideLoader()
                             DGProgressView.shared.hideLoader()
                         }
                     }
                     
                 }
             }
         })
     }
    
    func checkAllAPIsCompleted() {
        // Determine the supported providers based on your logic
       
        apiCount += 1
        print(apiCount)
        DispatchQueue.main.async {
            if self.apiCount >= self.supportedProviders.count {
                self.getBestPriceFromAllBestPrices()
            } else {
                self.viewFindProvider.isHidden = true
            }
        }
       
    }
    func callAPIsAfterTaskCompletion() {
        
//        Task {
//            await callAPIsAsyncFunction()
//        }
        guard let getCoinDetail = getCoinDetail, let payCoinDetail  = payCoinDetail else {
            return
        }
        for provider in supportedProviders {
            switch provider {
            case .okx:
                if(getCoinDetail.type == payCoinDetail.type && getCoinDetail.address != "" && payCoinDetail.address != "") {
//                    oKTswappingQuote()
                    if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.okx }) {
                        self.allProviders[providerIndex].bestPrice = "0.0"
                        self.checkAllAPIsCompleted()
                    }
                } else {
                    if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.okx }) {
                        self.allProviders[providerIndex].bestPrice = "0.0"
                        self.checkAllAPIsCompleted()
                    }
                }
            case .changeNow:
                changeNowSwapQuote()
            case .rango:
                rangoSwapQuote()
            }
        }
    }
    
    func callAPIsAsyncFunction() async {
        guard let getCoinDetail = getCoinDetail, let payCoinDetail  = payCoinDetail else {
            return
        }
        for provider in supportedProviders {
            switch provider {
            case .okx:
                if getCoinDetail.chain == payCoinDetail.chain {
                    await oKTswappingQuote()
                } else {
                    if let providerIndex = self.allProviders.indices.first(where: { self.allProviders[$0].name == StringConstants.okx }) {
                        self.allProviders[providerIndex].bestPrice = "0.0"
                        self.checkAllAPIsCompleted()
                    }
                }
            case .changeNow:
                await changeNowSwapQuote()
            case .rango:
                await rangoSwapQuote()
            }
        }
    }

    func rangoApproveTranscation( amount:String, gasLimit: String?,_ gasPrice: String?, approveTo: String?,txTo: String?,txData: String  , txValue: String ) {
        DispatchQueue.main.async {
            self.payCoinDetail?.callFunction.approveTransactionForSwap(gasLimit,gasPrice,approveTo, tokenAmount: Double(amount) ?? 0.90) { status,transfererror,_ in
                if status {
                    DispatchQueue.main.async {
                        for views in [self.viewProgress[0],self.viewProgress[1],self.viewProgress[2]] {
                            views.backgroundColor = UIColor.c00C6FB
                        }
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = .white
                        self.rangoSendTranscation(receiverAddress: txTo, txData: txData,gas: gasLimit ?? "",gasPrice: gasPrice ?? "", txValue: txValue)
                    }
                } else {
                   // self.btnSwap.HideLoader()
                   // DGProgressView.shared.hideLoader()
                    self.closePopUpOnFailler()
                }
            }
        }
    }
    func rangoSendTranscation( receiverAddress: String?,txData: String,gas: String,gasPrice: String, txValue: String ) {
        DispatchQueue.main.async {
            let txGasLimit: BigInt =   UnitConverter.hexStringToBigInteger(hex: gas) ??  BigInt(2500000)  // ?? BigUInt(2500000)
            let gasPrice: BigUInt = BigUInt(gasPrice) ?? BigUInt(30000)
            let tValue: BigInt =  UnitConverter.hexStringToBigInteger(hex: txValue)  ?? BigInt(2500000)
           
            if self.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
                self.sendBtc(0.0011, receiverAddress)
            }
            
            self.payCoinDetail?.callFunction.signAndSendTranscation(receiverAddress,gasLimit: BigUInt( txGasLimit) , gasPrice: gasPrice , txValue: BigUInt(tValue) , rawData: txData ) { status,transfererror,_ in
                if status {
                    DispatchQueue.main.async {
                        for views in self.viewProgress {
                            views.backgroundColor = UIColor.c00C6FB
                        }
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = UIColor.c75769D
                        self.lblSuccessFail.textColor = UIColor.white
//                        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
//                        }
                       // DispatchQueue.main.async {
//                            self.showToast(message: "Successfully Swap", font: .systemFont(ofSize: 15))
                          //  self.btnSwap.HideLoader()
                           // DGProgressView.shared.hideLoader()
                            self.closePopUpOnSucess()
                       // }
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        for views in self.viewProgress {
                            views.backgroundColor = UIColor.red
                        }
                        self.showToast(message: "Failed", font: .systemFont(ofSize: 15))
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = UIColor.c75769D
                        self.lblSuccessFail.textColor = UIColor.red
                       // self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: "")
                       // self.btnSwap.HideLoader()
                     //   DGProgressView.shared.hideLoader()
                        self.closePopUpOnFailler()
                    }
                }
            }
        }
    }
}

