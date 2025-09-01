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
    
    private func apiGetTransactionStatus(transactionID: String?,providerName:String? = "") {
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
                            DispatchQueue.main.async {
                                self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: ""), font: AppFont.regular(15).value)
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
    
    func getExodusTransactionStatus(id:String) {
        self.viewModel.apiGetExodusTransactionStatus(id) { status, statuserr, resp in
            if status {
                if let dictionary = resp,
                   let data = dictionary["data"] as? [String: Any],
                   let status = data["status"] as? String {
                    print("Status: \(status)")
                    let transactionStatus = status
                        print(transactionStatus)
                    if transactionStatus == "complete" {
                        
                        for views in self.viewProgress {
                            views.backgroundColor = UIColor.c00C6FB
                        }
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = UIColor.c75769D
                        self.lblSuccessFail.textColor = .white
                        //                        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
                        //                        }
                        DispatchQueue.main.async {
                            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: ""), font: AppFont.regular(15).value)
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
                        if transactionStatus == "inProgress" || transactionStatus == "refunded" {
                        } else if transactionStatus == "expired" {
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.getExodusTransactionStatus(id:id)
                        }
                    }
                } else {
                    print("Status not found")
                }
            
            } else {
                
            }
        }
    }
    func apiGetExodusTransactionStatus(transactionID: String?,providerName:String? = "") {
        self.viewModel.apiUpdateExodusTransactionStatus(transactionID ?? "", id: self.id) { status, statuserr, resp in
            self.getExodusTransactionStatus(id: self.id)
        }
    }
    func refreshData() {
        guard let walletDash = self.navigationController?.viewControllers.first(where: { $0 is WalletDashboardViewController }) as? WalletDashboardViewController else {
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
    
    fileprivate func swapApiResponseSet(_ status: Bool, _ data: [String : Any]?, _ swaperr: String) {
        if status {
            let payInAdd = data?["payinAddress"] as? String
            let transactionID = data?["id"] as? String
            let errorMessage = data?["message"] as? String
            let toAmount = data?["toAmount"] as? Double
            let payoutAddress = data?["payoutAddress"] as? String
            if errorMessage == nil {
                if self.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
                    self.sendBtc(toAmount, payInAdd,transactionID ?? "")
                } else {
                    self.payCoinDetail?.callFunction.sendTokenOrCoin(payInAdd, tokenAmount: Double(self.txtPay.text ?? "") ?? 0.0) { status, transfererror, data in
                        if status {
                            print("data: \(data?.hex() ?? "")")
                            self.transHex = data?.hex() ?? ""
                            self.transactionID = transactionID
                            self.walletActivityLog(providerType: ProvidersType.changeNow.rawValue) {
                            }
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
                           // }
                            
                        } else {
                            DispatchQueue.main.async {
                                self.showToast(message: transfererror ?? "", font: .systemFont(ofSize: 15))
                                self.btnSwap.HideLoader()
                                DGProgressView.shared.hideLoader()
                            } } }
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
    func fromNetworkStr() -> String? {
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
        case .opMainnet:
            return "op"
        
        case .avalanche:
            return "AVAX".lowercased()
        case .arbitrum:
            return "ARBITRUM".lowercased()
        case.base:
            return "base"
//        case .tron:
//            return "TRON".lowercased()
//        case .solana:
//            return "Solana"
        case .none:
            return ""
        }
    }
    func swappingPreview() {

        var fromNetwork: String? {
            return fromNetworkStr()
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
            case .opMainnet:
                return "op"
           
            case .avalanche:
                return "AVAX".lowercased()
            case .arbitrum:
                return "ARBITRUM".lowercased()
            case.base:
                return "base"
//            case .tron:
//                return "TRON".lowercased()
//            case .solana:
//                return "Solana"
            case .none:
                return ""
            }
        }
        viewModel.apiSwapping(address: WalletData.shared.myWallet?.address ?? "", fromCurrency: lblCoinName.text?.lowercased() ?? "", toCurrency: lblGetCoinName.text?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork ?? "", fromAmount: txtPay.text ?? "", toAmount: "") { status, swaperr, data in
            
            self.swapApiResponseSet(status, data, swaperr)
        }
    }
    
    func exodusSwap() {
        let payInAdd = self.payInAddress
        let transactionID = self.id
        let errorMessage = self.message
        let formattedPrice = WalletData.shared.formatDecimalString("\(self.bestQuote)", decimalPlaces: 10)
        let toAmount = Double(formattedPrice)
//        let payoutAddress = data?["payoutAddress"] as? String
        if errorMessage == "" {
            if self.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
                self.sendBtc(toAmount, payInAdd,transactionID)
            } else {
                self.payCoinDetail?.callFunction.sendTokenOrCoin(payInAdd, tokenAmount: Double(self.txtPay.text ?? "") ?? 0.0) { status, transfererror, data in
                    if status {
                        self.transHex = data?.hex() ?? ""
                        self.walletActivityLog(providerType: ProvidersType.exodus.rawValue) { }
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
                                self.apiGetExodusTransactionStatus(transactionID: self.transHex,providerName: ProvidersType.exodus.rawValue)
                            }
//                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            print("fail2: \(transfererror)")
                            self.showToast(message: transfererror ?? "", font: .systemFont(ofSize: 15))
                            self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                        } } }
            }// else
        } else {
            DispatchQueue.main.async {
                print("failFinal: \(errorMessage)")
                self.showToast(message: errorMessage, font: .systemFont(ofSize: 15))
                self.btnSwap.HideLoader()
                DGProgressView.shared.hideLoader()
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
      self.btnSwap.HideLoader()
            DGProgressView.shared.hideLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true) {
                    self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: ""), font: .systemFont(ofSize: 15))
                    self.refreshData()
                }
            }
    }
    fileprivate func closePopUpOnFailler(_ error : String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.btnSwap.HideLoader()
            DGProgressView.shared.hideLoader()
            print(error)
            error == "" ? self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.fail, comment: ""), font: .systemFont(ofSize: 15))  : self.showToast(message:error ?? "" , font: .systemFont(ofSize: 15))
            
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
                            print("swapData: \(swapData)")
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
                                print("Noerror: \(errorCode)")
                                self.openPopUp()
                                self.payCoinDetail?.callFunction.swapTokenOrCoin(payInAdd, gas: gas, gasPrice: gasPrice, rawData: rawData,tokenAmount: self.txtPay.text ?? "") { status,transfererror,data in
                                     
                                    if status {
                                        print("transHex: \(data?.hex() ?? "")")
                                        self.transHex = data?.hex() ?? ""
                                        self.walletActivityLog(providerType: ProvidersType.okx.rawValue) { }
                                        DispatchQueue.main.async {
                                            self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: ""), font: AppFont.regular(15).value)
                                            for views in self.viewProgress {
                                                views.backgroundColor = UIColor.c00C6FB
                                            }
                                            self.lblInitiate.textColor = UIColor.c75769D
                                            self.lblSwapping.textColor = UIColor.c75769D
                                            self.lblSuccessFail.textColor = .white
                                            self.closePopUpOnSucess()
                                        }
//                                    }
                                    } else {
                                        DispatchQueue.main.async {
                                            print("Fail: \(transfererror)")
                                            for views in self.viewProgress {
                                                views.backgroundColor = .red
                                            }
                                            self.lblInitiate.textColor = UIColor.c75769D
                                            self.lblSwapping.textColor = UIColor.c75769D
                                            self.lblSuccessFail.textColor = .red
                                            self.closePopUpOnFailler()
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    print("Fail2: \(errorMessage)")
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
                            print("Fail: \(swaperr)")
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
        print("payTokenAddress",payTokenAddress)
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
                        print("dexContractAddress",dexContractAddress)
                        let gasPrice = firstItem?["gasPrice"] as? String ?? ""
                        let gasLimit = firstItem?["gasLimit"] as? String ?? ""
                        let errorCode = response?["code"] as? String
                        let errorMessage = response?["msg"] as? String
                        if errorCode == "0" {
                            self.payCoinDetail?.callFunction.approveTransactionForSwap(gasLimit,gasPrice,dexContractAddress, tokenAmount: Double(self.txtPay.text ?? "") ?? 0.90) { status,transfererror,_ in
                                if status {
                                    DispatchQueue.main.async {
                                        print("SuccessAprove",status)
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
                            self.requestId = firstItem.requestID ?? ""
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
                                        let swapperFees = UnitConverter.convertWeiToEther("\(sum )", Int(self.decimalsValue)) ?? ""
                                        let networkFee =  UnitConverter.convertWeiToEther("\(sum1 )", Int(self.decimalsValue)) ?? ""
                                        self.newSwapperFee = swapperFees
                                        self.networkFee = networkFee
                                        completion(true,swapperFees,amountToGet, errorMsg ?? "",networkFee)
                                    } else {
                                        completion(false,"0",self.amountToGet,errorMsg ?? "",self.networkFee)
                                    }
                                })
                               
                            } else {
                                completion(false,"0",self.amountToGet,errorMsg ?? "",self.networkFee)
                            }
                            if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                                _ = allToken.filter { $0.address == "" && $0.type == self.payCoinDetail?.type && $0.symbol == self.payCoinDetail?.chain?.symbol ?? "" }
                           }
                            DGProgressView.shared.hideLoader()
                        } catch(let error) {
                            print("errorMsg =" ,error)
                            self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
                            DGProgressView.shared.hideLoader()
                           // self.btnSwap.HideLoader()
                        }
                        print(data!)
                        
                    } else {
                        DispatchQueue.main.async {
                            print("errorMsg1 = ",swaperr)
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
//                                 let allChain = allToken.filter { $0.address == "" && $0.type == self.payCoinDetail?.type && $0.symbol == self.payCoinDetail?.chain?.symbol ?? "" }
//                                 print("allChain",allChain)
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
    func rangoApproveTranscation( amount:String, gasLimit: String?,_ gasPrice: String?, approveTo: String?,txTo: String?,txData: String  , txValue: String ) {
        DispatchQueue.main.async {
            self.payCoinDetail?.callFunction.approveTransactionForSwap(gasLimit,gasPrice,approveTo, tokenAmount: Double(amount) ?? 0.90) { status,transfererror,_ in
                if status {
                    print("RangoAprove",status)
                    print("RangoAproveEWrr",transfererror)
                    DispatchQueue.main.async {
                        
                        for views in [self.viewProgress[0],self.viewProgress[1],self.viewProgress[2]] {
                            views.backgroundColor = UIColor.c00C6FB
                        }
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = .white
                        self.rangoSendTranscation(receiverAddress: txTo, txData: txData,gas: gasLimit ?? "",gasPrice: gasPrice ?? "", txValue: txValue)
                    }
                } else {
                    self.closePopUpOnFailler(transfererror)
                }
            }
        }
    }
    func rangoSendTranscation( receiverAddress: String?,txData: String,gas: String,gasPrice: String, txValue: String ) {
        DispatchQueue.main.async {
            let txGasLimit: BigInt =   UnitConverter.hexStringToBigInteger(hex: gas) ??  BigInt(2500000)  // ?? BigUInt(2500000)
            let gasPrice: BigUInt = BigUInt(gasPrice) ?? BigUInt(30000)
            let tValue: BigInt =  UnitConverter.hexStringToBigInteger(hex: txValue)  ?? BigInt(2500000)
            var sendAmout = 0.0
            if self.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
                sendAmout = Double(tValue)
                self.sendBtc(sendAmout, receiverAddress)
            }
            
            self.payCoinDetail?.callFunction.signAndSendTranscation(receiverAddress,gasLimit: BigUInt( txGasLimit) , gasPrice: gasPrice , txValue: BigUInt(tValue) , rawData: txData ) { status,transfererror,ethereumData in
                print("RangoResponseStatus = ",status)
                print("RangoResponsetransfererror = ",transfererror)
                if status {
                    
                    DispatchQueue.main.async {
                        self.showToast(message: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: ""), font: AppFont.regular(15).value)
                        for views in self.viewProgress {
                            views.backgroundColor = UIColor.c00C6FB
                        }
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = UIColor.c75769D
                        self.lblSuccessFail.textColor = UIColor.white
                        
                        self.transHex = ethereumData?.hex() ?? ""
                       // print("rangotransHex = ",self.transHex)
                        self.walletActivityLog(requestId:"",providerType: ProvidersType.rango.rawValue) {}
                        self.closePopUpOnSucess()
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        for views in self.viewProgress {
                            views.backgroundColor = UIColor.red
                        }
                        self.showToast(message: "\(transfererror ?? "Failed")", font: .systemFont(ofSize: 15))
                        self.lblInitiate.textColor = UIColor.c75769D
                        self.lblSwapping.textColor = UIColor.c75769D
                        self.lblSuccessFail.textColor = UIColor.red
                        self.closePopUpOnFailler()
                    }
                }
            }
        }
    }
}

extension SwapViewController {
    func walletActivityLog(requestId:String? = nil,providerType:String,completion: @escaping () -> Void) {
        if self.payCoinDetail?.chain?.coinType == .bitcoin {
            self.walletAddress = WalletData.shared.getPublicWalletAddress(coinType: .bitcoin) ?? ""
        } else {
            self.walletAddress = WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? ""
        }
             // Define the URL
        guard let url = URL(string: "https://plutope.app/api/wallet-activity-log") else {
            print("Invalid URL")
            return
        }
        // Define the request body
        let json: [String: Any] = [
            "requestId" : "\(requestId ?? "")",
            "walletAddress": "\(self.walletAddress)",
            "transactionType": TransactionType.swap.rawValue,
            "transactionHash": "\(self.transHex)",
            "providerType": "\(providerType)",
            "tokenDetailArrayList": [
                [
                    "from": [
                        "chainId": "\(self.payCoinDetail?.chain?.chainId ?? "")",
                        "symbol": "\(self.payCoinDetail?.chain?.symbol ?? "")",
                        "address":"\(self.payCoinDetail?.chain?.walletAddress ?? "")"
                    ],
                    "to": [
                        "chainId": "\(self.getCoinDetail?.chain?.chainId ?? "")",
                        "symbol": "\(self.getCoinDetail?.chain?.symbol ?? "")",
                        "address":"\(self.getCoinDetail?.chain?.walletAddress ?? "")"
                    ]
                ]
            ]
        ]
        
        print(json)
        // Convert the JSON to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Failed to serialize JSON data")
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        // Create the URLSession
        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response code: \(httpResponse.statusCode)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(jsonResponse)")
            } catch {
                print("Failed to parse JSON response: \(error)")
            }
            completion()
        }
        // Start the task
        task.resume()
    }
}
