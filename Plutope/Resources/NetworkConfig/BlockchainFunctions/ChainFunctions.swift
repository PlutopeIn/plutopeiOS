//
//  ChainFunctions.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import Web3
import CoreData
// swiftlint:disable type_body_length
class ChainFunctions: BlockchainFunctions {
    init(_ data: Token) {
        self.tokenDetails = data
    }
    
    var tokenDetails: Token!
    /// getGasPrice
    func getGasPrice(completion: @escaping ((Bool, String?,String?,String?, EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        
        web3.eth.gasPrice { gasPriceResponse in
            completion(true, "\(gasPriceResponse.result)","","" ,nil)
        }
        
    }
    /// approveTransactionForSwap
    func approveTransactionForSwap(_ gasLimit: String?,_ gasPrice: String?, _ routerAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        completion(false, "Transaction hash not available", nil)
        
    }
    /// swapTokenOrCoin
    func swapTokenOrCoin(_ receiverAddress: String?, gas: String, gasPrice: String, rawData: String,tokenAmount: String, completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            
            web3.eth.gasPrice { gasPriceResponse in
                
                let gasPriceTx = gasPriceResponse.result?.quantity ?? BigUInt(100)
                
                web3.eth.estimateGas(call: EthereumCall(from: myWalletAddress, to: toWalletAddress, gasPrice: gasPriceResponse.result, data: EthereumData(Bytes(hex: rawData))), response: { gasLimitRes in
                    // convert BigUInt(Double(gas)
                    let gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(21000)
                    // Apply a buffer to the gas limit (e.g., increase it by 10%)
                    let bufferPercentage: Double = 10.1
                    let gasLimit = BigUInt(Double(gasLimitEstimate) * bufferPercentage)
                    let amount = UnitConverter.etherToWei(Double(tokenAmount) ?? 0)
                    let amountToWei = EthereumQuantity(quantity: BigUInt(amount))
                    // Calculate the total transaction fee
                    let fee = gasPriceTx * gasLimit
                    // add static decimal 18
                    let gasAmount = UnitConverter.convertWeiToEther("\(fee)", Int(18)) ?? ""
                    let chainBal = self.tokenDetails.balance ?? ""
//                    if (Double(chainBal) ?? 0) < (Double(gasAmount) ?? 0) {
//                        completion(false,ToastMessages.lowFeeBalance("\(chain.name) (\(chain.symbol))"),nil)
//                    } else 
                    
//                    let gasPriceBigU: BigUInt = BigUInt(gasPrice)
//                    
//                    let gasLimitBigU: BigUInt = BigUInt(gas)
                    
                        do {
                            let transaction = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: gasPriceTx), gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, to: toWalletAddress, value: amountToWei,data: EthereumData(Bytes(hex: rawData)))
                            let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                            try web3.eth.sendRawTransaction(transaction: signedTx) { (transactionHash) in
                                if let txHash = transactionHash.result {
                                    // Usage
                                    fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                        switch result {
                                        case .success(let receiptResponse):
                                            if receiptResponse.result != nil {
                                                if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                    completion(true, "Swapping successful", txHash)
                                                } else {
                                                    completion(false, "Swapping failed", txHash)
                                                }
                                            } else {
                                                completion(false, "Transaction receipt not available", txHash)
                                            }
                                        case .failure(let error):
                                            completion(false, error.localizedDescription, txHash)
                                        }
                                    }
                                    
                                } else if let error = transactionHash.error {
                                    completion(false, error.localizedDescription, nil)
                                } else {
                                    completion(false, "Transaction hash not available", nil)
                                }
                            }
                            
                        } catch(let error) {
                            print(error)
                            completion(false,error.localizedDescription,nil)
                        }
                    
                    
                })
            }
        }
    }
    /// sendTokenOrCoin
    func sendTokenOrCoin(_ receiverAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else {
            completion(false,"Invalid receiver address", nil)
            return
        }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            
            web3.eth.gasPrice {  gasPriceRes in
                
                let amount = UnitConverter.etherToWei(Double(tokenAmount))
                let amountToWei = EthereumQuantity(quantity: BigUInt(amount))
                
                web3.eth.estimateGas(call: EthereumCall(to: toWalletAddress,gasPrice: gasPriceRes.result,value: amountToWei)) { gasLimitRes in
                    let gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(21000)
                    // Apply a buffer to the gas limit (e.g., increase it by 10%)
                    // let bufferPercentage: Double = 1.1
                    let gasLimit = gasLimitEstimate // * bufferPercentage)
                    let gasPrice = gasPriceRes.result?.quantity ?? BigUInt(100)
                    
                    // Calculate the total transaction fee
                    let fee = gasPrice * gasLimit
                    let gasAmount = UnitConverter.convertWeiToEther("\(fee)",Int(self.tokenDetails.decimals)) ?? ""
                    if (Double(self.tokenDetails.balance ?? "") ?? 0) < (Double(gasAmount) ?? 0) {
                        completion(false,ToastMessages.lowFeeBalance("\(chain.name) (\(chain.symbol))"),nil)
                    } else {
                        do {
                            // let tx = EthereumSignedTransaction(nonce: EthereumQuantity(Bytes(hex: signerInput.nonce.hexString)), gasPrice: EthereumQuantity(Bytes(hex: signerInput.gasPrice.hexString)), gasLimit: EthereumQuantity(Bytes(hex: signerInput.gasLimit.hexString)),to: toWalletAddress , value:  EthereumQuantity(Bytes(hex: signerInput.transaction.transfer.amount.hexString)), data: ethData, v: v, r: r, s: s, chainId: EthereumQuantity(Bytes(hex: "05")))
                            //                print(tx)
                            let trans = EthereumTransaction(nonce: resp.result, gasPrice: gasPriceRes.result, gasLimit: gasLimitRes.result, from: myWalletAddress, to: toWalletAddress, value: amountToWei)
                            
                            let signedTrans = try trans.sign(with: try EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                            print("signTrans",signedTrans)
                            try web3.eth.sendRawTransaction(transaction: signedTrans) { (transactionHash) in
                                if let txHash = transactionHash.result {
                                    fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                        switch result {
                                        case .success(let receiptResponse):
                                            if receiptResponse.result != nil {
                                                if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                    completion(true, "Send successful", txHash)
                                                } else {
                                                    completion(false, "Send failed please try again after some time.", txHash)
                                                }
                                            } else {
                                                completion(false, "Transaction receipt not available", txHash)
                                            }
                                        case .failure(let error):
                                            print("SenderrMsg = ",error.localizedDescription)
                                            completion(false, transactionHash.error?.readableDescription, txHash)
                                        }
                                    }
                                    
                                } else if let error = transactionHash.error {
                                    print("SenderrMsg1 = ",transactionHash.error?.readableDescription)
                                    completion(false, transactionHash.error?.readableDescription, nil)
                                } else {
                                    
                                    completion(false, "Transaction hash not available", nil)
                                }  }
                            
//                            try web3.eth.sendRawTransaction(transaction: signedTrans) { (transactionHash) in
//                                if transactionHash.status.isFailure {
//                                    completion(false, transactionHash.error.debugDescription, nil)
//                                    print((transactionHash.status.error) ?? "")
//                                } else {
//                                    completion(true, transactionHash.error.debugDescription, transactionHash.result)
//                                }
//                                print(transactionHash)
//                            }
                        } catch(let error) {
                            print("SenderrMsg2",error.localizedDescription)
                            completion(false, error.localizedDescription, nil)
                        }
                    }
                }
            }
        }
    }
    /// sendTokenOrCoinWithLavrageFee
    func sendTokenOrCoinWithLavrageFee(_ receiverAddress: String?, tokenAmount: Double,nonce:String,gasAmount:String,gasLimit:String,completion: @escaping ((Bool,String?,EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else {
            completion(false,"Invalid receiver address", nil)
            return
        }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            
            web3.eth.gasPrice {  gasPriceRes in
                let amount = UnitConverter.etherToWei(Double(tokenAmount))
                let amountToWei = EthereumQuantity(quantity: BigUInt(amount))
                web3.eth.estimateGas(call: EthereumCall(to: toWalletAddress,gasPrice: gasPriceRes.result,value: amountToWei)) { gasLimitRes in
                    _ = gasPriceRes.result?.quantity ?? BigUInt(100)
                    let gasNonce = resp.result?.quantity ?? BigUInt(100)
                    let txGasLimit: BigInt =  UnitConverter.hexStringToBigInteger(hex: gasLimit) ??  BigInt(2500000)
                    let gasPrice: BigUInt = BigUInt(gasAmount) ?? BigUInt(100)
                    let nonce: BigUInt = BigUInt(nonce) ?? gasNonce
                    let gasLimitEstimate = BigUInt(txGasLimit)
                    // Apply a buffer to the gas limit (e.g., increase it by 10%)
                    // let bufferPercentage: Double = 1.1
                    let gasLimit = gasLimitEstimate // * bufferPercentage)
                    // Calculate the total transaction fee
                    let fee = gasPrice * gasLimit
                    let gasAmount = UnitConverter.convertWeiToEther("\(fee)",Int(self.tokenDetails.decimals)) ?? ""
                    if (Double(self.tokenDetails.balance ?? "") ?? 0) < (Double(gasAmount) ?? 0) {
                        completion(false,ToastMessages.lowFeeBalance("\(chain.name) (\(chain.symbol))"),nil)
                    } else {
                        do {
                            let trans = EthereumTransaction(nonce: EthereumQuantity(quantity: nonce), gasPrice: EthereumQuantity(quantity: gasPrice), gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, to: toWalletAddress, value: amountToWei)
                            
                            let signedTrans = try trans.sign(with: try EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                            
                            print(signedTrans)
                            try web3.eth.sendRawTransaction(transaction: signedTrans) { (transactionHash) in
                                if let txHash = transactionHash.result {
                                    fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                        switch result {
                                        case .success(let receiptResponse):
                                            if receiptResponse.result != nil {
                                                if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                    completion(true, "Send successful", txHash)
                                                } else {
                                                    completion(false, "Send failed please try again after some time.", txHash)
                                                }
                                            } else {
                                                completion(false, "Transaction receipt not available", txHash)
                                            }
                                        case .failure(let error):
                                            completion(false, error.localizedDescription, txHash)
                                        }
                                    }
                                    
                                } else if let error = transactionHash.error {
                                    completion(false, error.localizedDescription, nil)
                                } else {
                                    completion(false, "Transaction hash not available", nil)
                                }  }
//                            try web3.eth.sendRawTransaction(transaction: signedTrans) { (transactionHash) in
//                                if transactionHash.status.isFailure {
//
//                                    completion(false, transactionHash.error.debugDescription , nil)
//                                    print((transactionHash.status.error) ?? "")
//                                } else {
//                                    completion(true, transactionHash.error.debugDescription, transactionHash.result)
//                                }
//                                print(transactionHash)
//                            }
                        } catch(let error) {
                            print(error.localizedDescription)
                            completion(false, error.localizedDescription, nil)
                        }
                    }
                }
            }
        }
    }
    /// getBalance
    func getBalance(completion: @escaping ((String?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        
        guard let walletAddress = chain.walletAddress else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        print("chainDetail",tokenDetails)
        print("chain",chain)
        print("chainRPC",chain.rpcURL)
        print(walletAddress)
        print(chain.symbol)
       
        do {
            web3.eth.getBalance(address: try EthereumAddress(hex: walletAddress, eip55: true), block: .latest) { resp in
                if resp.status.isSuccess {
                    
                    let etherValue = (Decimal(string: resp.result?.quantity.description ?? "") ?? 0) / pow(10, 18)
                    
                    completion("\(etherValue)")
                    
                } else {
                    completion("0")
                }
            }
            
        } catch(let err) {
            UserTokenData.update(symbol: self.tokenDetails.symbol ?? "", balance: "0")
            print("Failed to Fetch Balance", err)
            completion("0")
        }
    }
    /// getDecimal
    func getDecimal(completion: @escaping ((String?) -> Void)) {
        completion("18")
    }
    /// getGasFee
    func getGasFee(_ receiverAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?,String?,String?,String?,EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else {
            completion(false,"Invalid receiver address","","","", nil)
            return
        }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            
            web3.eth.gasPrice {  gasPriceRes in
                
                let amount = UnitConverter.etherToWei(Double(tokenAmount))
                let amountToWei = EthereumQuantity(quantity: BigUInt(amount))
                
                web3.eth.estimateGas(call: EthereumCall(to: toWalletAddress,gasPrice: gasPriceRes.result,value: amountToWei)) { gasLimitRes in
                    var gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(21000)
                    gasLimitEstimate = gasLimitRes.result?.quantity ??  chain.defaultGasLimit
                    if(gasLimitEstimate < chain.defaultGasLimit) {
                        gasLimitEstimate = chain.defaultGasLimit
                    }
                    // let gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(21000)
                    let nonce = resp.result?.quantity ?? BigUInt(100)
                    let gasLimit = gasLimitEstimate // * bufferPercentage)
                    let gasPrice = gasPriceRes.result?.quantity ?? BigUInt(100)
                    
                    // Calculate the total transaction fee
                    let fee = gasPrice * gasLimit
                    _ = UnitConverter.convertWeiToEther("\(fee)",Int(self.tokenDetails.decimals)) ?? ""
                    completion(true, "\(fee)","\(gasPrice)","\(gasLimit)","\(nonce)" ,nil)
                }
            }
        }
    }
      /// for Rango Swap
    func signAndSendTranscation(_ receiverAddress: String?, gasLimit: BigUInt, gasPrice: BigUInt, txValue: BigUInt, rawData: String,
                                completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        print("chain",chain)
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            
            web3.eth.gasPrice { gasPriceResponse in
                
                _ = gasPriceResponse.result?.quantity ?? BigUInt(100)
                
                do {
                    
                    let transaction = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: gasPrice), gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, to: toWalletAddress, value: EthereumQuantity(quantity: txValue), data: EthereumData(Bytes(hex: rawData)))
                    
                    let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                    
                    try web3.eth.sendRawTransaction(transaction: signedTx) { (transactionHash) in
                        if let txHash = transactionHash.result {
                            // Usage
                            fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                switch result {
                                case .success(let receiptResponse):
                                    if receiptResponse.result != nil {
                                        if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                            completion(true, "Swapping successful", txHash)
                                        } else {
                                            completion(false, "Swapping failed", txHash)
                                        }
                                    } else {
                                        completion(false, "Transaction receipt not available", txHash)
                                    }
                                case .failure(let error):
                                    completion(false, error.localizedDescription, txHash)
                                }
                            }
                            
                        } else if let error = transactionHash.error {
                            completion(false, error.localizedDescription, nil)
                        } else {
                            completion(false, "Transaction hash not available", nil)
                        }
                    }
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            }
        }
    }
    // off ramp
    func getTransactionHash(_ receiverAddress: String?, gasLimit: BigUInt, gasPrice: BigUInt, txValue: BigUInt, rawData: String,isGettingTransactionHash:Bool? ,completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            do {
            web3.eth.gasPrice { gasPriceResponse in
                _ = gasPriceResponse.result?.quantity ?? BigUInt(100)
                do {
                    let transaction = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: gasPrice), gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, to: toWalletAddress, value: EthereumQuantity(quantity:txValue), data: EthereumData(Bytes(hex: rawData)))
                    let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                    
                    if isGettingTransactionHash ?? false {
                    try web3.eth.sendRawTransaction(transaction: signedTx) { (transactionHash) in
                        if let txHash = transactionHash.result {
                            fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                switch result {
                                case .success(let receiptResponse):
                                    if receiptResponse.result != nil {
                                        if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                            completion(true, "Transaction successful", txHash)
                                        } else {
                                            completion(false, "Transaction failed", txHash)
                                        }
                                    } else {
                                        completion(false, "Transaction receipt not available", txHash)
                                    }
                                case .failure(let error):
                                    completion(false, error.localizedDescription, txHash)
                                }
                            }
                            
                        } else if let error = transactionHash.error {
                            completion(false, error.localizedDescription, nil)
                        } else {
                            completion(false, "Transaction hash not available", nil)
                        }
                    }
                    } else {
                        completion(true,"signedTransaction",signedTx.data)
                    }
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            }
            } catch(let error) {
                print(error)
                completion(false,error.localizedDescription,nil)
            }
        }
    }
    func sendTokenOrCoinFromWalletConect(_ receiverAddress: String?, tokenAmount: Double,gasLimit: BigInt,rawData: String,isGettingTransactionHash:Bool?, completion: @escaping ((Bool, String?,BigInt?,BigInt?,BigInt?, EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else {
            completion(false,"Invalid receiver address",0,0,0, nil)
            return
        }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            
            web3.eth.gasPrice {  gasPriceRes in
                
                let amount = UnitConverter.etherToWei(Double(tokenAmount))
                let amountToWei = EthereumQuantity(quantity: BigUInt(amount))
                web3.eth.estimateGas(call: EthereumCall(to: toWalletAddress,gasPrice: gasPriceRes.result,value: amountToWei)) { gasLimitRes in
                    
//                    let txGasLimit: BigInt =  UnitConverter.hexStringToBigInteger(hex: gasLimit) ??  BigInt(50000)
                    let txGasLimit =  gasLimit ??  BigInt(50000)
                    let gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(50000)
                    let bufferPercentage: Double = 1.1
                    var gasLimitDfault = BigUInt(Double(gasLimitEstimate) * bufferPercentage)
                    let gasPrice = gasPriceRes.result?.quantity ?? BigUInt(100)
                    var finalGasLimit = BigInt()
                    if txGasLimit != 0 {
                        finalGasLimit  = BigInt(txGasLimit)
                    } else {
                        finalGasLimit = BigInt(gasLimitDfault)
                    }
                    var nonce = resp.result?.quantity ?? BigUInt()
                    // Calculate the total transaction fee
                    let fee = gasPrice * BigUInt(finalGasLimit)
                    let gasAmount = UnitConverter.convertWeiToEther("\(finalGasLimit)",Int(self.tokenDetails.decimals)) ?? ""
                        do {
                            let trans = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: gasPrice), gasLimit: EthereumQuantity(quantity: BigUInt(finalGasLimit)), from: myWalletAddress, to: toWalletAddress, value: amountToWei,data: EthereumData(Bytes(hex: rawData)))
                            
                            let signedTrans = try trans.sign(with: try EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                            print(signedTrans)
                            if isGettingTransactionHash ?? false {
                            try web3.eth.sendRawTransaction(transaction: signedTrans) { (transactionHash) in
                                if let txHash = transactionHash.result {
                                    fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                        switch result {
                                        case .success(let receiptResponse):
                                            if receiptResponse.result != nil {
                                                if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                    completion(true, "Send successful",0,0,0, txHash)
                                                } else {
                                                    completion(false, "Send failed please try again after some time.",0,0,0, txHash)
                                                }
                                            } else {
                                                completion(false, "Transaction receipt not available",0,0,0, txHash)
                                            }
                                        case .failure(let error):
                                            completion(false, error.localizedDescription,0,0,0, txHash)
                                        }
                                    }
                                    
                                } else if let error = transactionHash.error {
                                    completion(false, error.localizedDescription,0,0,0, nil)
                                } else {
                                    completion(false, "Transaction hash not available",0,0,0, nil)
                                }  }
                            } else {
                                
                                completion(true,"signedTransaction",finalGasLimit,BigInt(gasPrice),BigInt(nonce),signedTrans.data)
                            }

                        } catch(let error) {
                            print(error.localizedDescription)
                            completion(false, error.localizedDescription,0,0,0, nil)
                        }
                }
            }
        }
    }
}
// swiftlint:enable type_body_length
