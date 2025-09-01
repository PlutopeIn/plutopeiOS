//
//  TokenFunctions.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import Web3
import CoreData
enum EthereumError: Error {
    case invalidAddress
    case callFailed
    case conversionFailed
}
// swiftlint:disable type_body_length
class TokenFunctions: BlockchainFunctions {
    
    init(_ data: Token) {
        self.tokenDetails = data
    }
    var tokenDetails: Token!
    func getTransactionHash(_ receiverAddress: String?, gasLimit: BigUInt, gasPrice: BigUInt, txValue: BigUInt, rawData: String,isGettingTransactionHash:Bool? ,completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            web3.eth.gasPrice { gasPriceResponse in
                var txgasPrice = gasPrice
                if(gasPrice == 0) {
                    txgasPrice = gasPriceResponse.result?.quantity ?? BigUInt(1000000)
                }
                do {
                    let transaction = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: txgasPrice), gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, to: toWalletAddress, value: EthereumQuantity(quantity: txValue), data: EthereumData(Bytes(hex: rawData)))
                    let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                    if isGettingTransactionHash ?? false {
                        try web3.eth.sendRawTransaction(transaction: signedTx) { (transactionHash) in
                            if let txHash = transactionHash.result {
                                // Usage
                                fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                    switch result {
                                    case .success(let receiptResponse):
                                        if receiptResponse.result != nil {
                                            if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                completion(true, "Transaction successful", txHash)
                                            } else {
                                                completion(false, "Transaction failed please try again after some time.", txHash)
                                            }
                                        } else {
                                            completion(false, "Transaction receipt not available", txHash)
                                        }
                                    case .failure(let error):
                                        completion(false, error.localizedDescription, txHash)
                                    }
                                } } else if let error = transactionHash.error {
                                    completion(false, error.localizedDescription, nil)
                                } else {
                                    completion(false, "Transaction hash not available", nil)
                                } }  } else {
                                    completion(true,"signedTransaction",signedTx.data)
                                }
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                } } }
    }
    /// for Rango Swap
    func signAndSendTranscation(_ receiverAddress: String?, gasLimit: BigUInt, gasPrice: BigUInt, txValue: BigUInt, rawData: String,  completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        print("chain",chain)
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            web3.eth.gasPrice { gasPriceResponse in
                var txgasPrice = gasPrice
                if(gasPrice == 0) {
                    txgasPrice = gasPriceResponse.result?.quantity ?? BigUInt(1000000)
                }
                var tempGasLimit = gasLimit
                if(gasLimit == 0) {
                    tempGasLimit = BigUInt(100000)
                }
                var nounce = resp.result
                var expectedNounce : BigUInt
                print(txgasPrice)
                print(tempGasLimit)
                do {
                    let transaction = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: txgasPrice), gasLimit: EthereumQuantity(quantity: tempGasLimit), from: myWalletAddress, to: toWalletAddress, value: EthereumQuantity(quantity: txValue), data: EthereumData(Bytes(hex: rawData)))
                    let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                    try web3.eth.sendRawTransaction(transaction: signedTx) { (transactionHash) in
                        if let txHash = transactionHash.result {
                            fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                print("result",result)
                                switch result {
                                case .success(let receiptResponse):
                                    if receiptResponse.result != nil {
                                        if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                            completion(true, "Transaction successful", txHash)
                                        } else {
                                            print("Swapping failed please try again after some time.")
                                            completion(false, "Swapping failed please try again after some time.", txHash)
                                        } } else {
                                            print("Transaction receipt not available")
                                            completion(false, "Transaction receipt not available", txHash)
                                        }
                                case .failure(let error):
                                    completion(false, error.localizedDescription, txHash)
                                }  }
                        } else if let error = transactionHash.error {
                            print("er1",error.localizedDescription)
                            completion(false, error.localizedDescription, nil)
                        } else {
                            print("er2","Transaction hash not available")
                            completion(false, "Transaction hash not available", nil)
                        } } } catch(let error) {
                            print(error)
                            print("er3",error.localizedDescription)
                            completion(false,error.localizedDescription,nil)
                        }
            }
        }
    }
    /// getGasPrice
    func getGasPrice(completion: @escaping ((Bool, String?,String?,String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let contractAddress = try? EthereumAddress(hex: tokenDetails.address ?? "", eip55: false) else { return   } // Replace with the address of the token contract
        let abiJson =  ABIs.ERCtokenABI.data(using: .utf8)!
        let contract = try? web3.eth.Contract(json: abiJson, abiKey: nil, address: contractAddress)
        contract?["decimals"]?().call(block: .latest, completion: { data, err in
            let decimal = data?[""] as? UInt8 ?? 0
            web3.eth.gasPrice { gasPriceResponse in
                completion(true, "\(gasPriceResponse.result)","","" ,nil)
            }  })
    }
    /// getGasFee
    func getGasFee(_ receiverAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?,String?,String?,String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let contractAddress = try? EthereumAddress(hex: tokenDetails.address ?? "", eip55: false) else { return   } // Replace with the address of the token contract
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        let abiJson =  ABIs.ERCtokenABI.data(using: .utf8)!
        let contract = try? web3.eth.Contract(json: abiJson, abiKey: nil, address: contractAddress)
        contract?["decimals"]?().call(block: .latest, completion: { data, err in
            let decimal = data?[""] as? UInt8 ?? 0
            web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
                web3.eth.gasPrice { gasPriceResponse in
                    let amount = UnitConverter.convertToWei(tokenAmount, Double(decimal))
                    // Estimate gas limit with a buffer (e.g., 10%)
                    web3.eth.estimateGas(call: EthereumCall(from: myWalletAddress, to: toWalletAddress, gasPrice: gasPriceResponse.result, value: EthereumQuantity(quantity: BigUInt(amount))), response: { gasLimitRes in
                        
                        var gasLimitEstimate = gasLimitRes.result?.quantity ??  chain.defaultGasLimit
                        if(gasLimitEstimate < chain.defaultGasLimit) {
                            gasLimitEstimate = chain.defaultGasLimit
                        }
                        let bufferPercentage: Double = 1.1
                        let gasLimit = BigUInt(Double(gasLimitEstimate) * bufferPercentage)
                        let gasPrice = gasPriceResponse.result?.quantity ?? BigUInt(100)
                        let fee = gasPrice * gasLimit // Calculate the total transaction fee
                        let gasAmount = UnitConverter.convertWeiToEther("\(fee)", Int(decimal)) ?? ""
                        let nonce = resp.result?.quantity ?? BigUInt(100)
                        completion(true, "\(fee)","\(gasPrice)","\(gasLimitEstimate)" ,"\(nonce)",nil)
                    })  } } })
    }
    /// approveTransactionForSwap
    func approveTransactionForSwap(_ gasLimit: String?,_ gasPrice: String?, _ routerAddress: String?, tokenAmount: Double, completion: @escaping ((Bool, String?, EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let contractAddress = try? EthereumAddress(hex: tokenDetails.address ?? "", eip55: false) else { return   } // Replace with the address of the token contract
        guard let routerAddress = try? EthereumAddress(hex: routerAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        let abiJson =  ABIs.ERCtokenABI.data(using: .utf8)!
        let contract = try? web3.eth.Contract(json: abiJson, abiKey: nil, address: contractAddress)
        contract?["decimals"]?().call(block: .latest, completion: { data, err in
            let decimal = data?[""] as? UInt8 ?? 0
            web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
                web3.eth.gasPrice { gasPriceResponse in
                    let amount = UnitConverter.convertToWei(tokenAmount, Double(decimal))
                    web3.eth.estimateGas(call: EthereumCall(from: myWalletAddress, to: routerAddress, gasPrice: gasPriceResponse.result, value: EthereumQuantity(quantity: BigUInt(amount))), response: { gasLimitRes in
                        let gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(150000)
                        let bufferPercentage: Double = 10.1
                        let gasLimit = BigUInt(Double(gasLimitEstimate) * bufferPercentage)
                        let gasPrice = gasPriceResponse.result?.quantity ?? BigUInt(100)
                        let fee = gasPrice * gasLimit
                        let gasAmount = UnitConverter.convertWeiToEther("\(fee)", Int("18") ?? 0) ?? ""
                        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                            let allCoin = allToken.filter { $0.address == "" && $0.type == self.tokenDetails.type && $0.symbol == chain.symbol }
                            let chainBal = allCoin.first?.balance ?? ""
                            if (Double(chainBal) ?? 0) < (Double(gasAmount) ?? 0) {
                                completion(false,ToastMessages.lowFeeBalance("\(chain.name) (\(chain.symbol))"),nil)
                            } else {
                                let amount =  UnitConverter.convertToWei(tokenAmount, Double(decimal))
                                do {
                                    let transaction = contract?["approve"]?(routerAddress,amount).createTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: gasPrice), maxFeePerGas: nil, maxPriorityFeePerGas: nil, gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, value: 0, accessList: [:], transactionType: .legacy)
                                    let signedTx = try transaction?.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                                    try web3.eth.sendRawTransaction(transaction: signedTx!) { (transactionHash) in
                                        if let txHash = transactionHash.result {
                                            fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                                switch result {
                                                case .success(let receiptResponse):
                                                    if receiptResponse.result != nil {
                                                        if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                            completion(true, "Approve successful", txHash)
                                                        } else {
                                                            completion(false, "Approve failed", txHash)
                                                        }} else {
                                                            completion(false, "Transaction receipt not available", txHash)
                                                        }
                                                case .failure(let error):
                                                    completion(false, error.localizedDescription, txHash)
                                                }  }
                                        } else if let error = transactionHash.error {
                                            completion(false, error.localizedDescription, nil)
                                        } else {
                                            completion(false, "Transaction hash not available", nil)
                                        }
                                    }} catch(let error) {
                                        print(error)
                                        completion(false,error.localizedDescription,nil)
                                    }  }  }  })
                }
            }
        })
    }
    /// getBalance
    func getBalance(completion: @escaping ((String?) -> Void)) {
        guard let chain = tokenDetails.chain else {
            completion(nil)
            return
        }
        guard let walletAddress = chain.walletAddress else {
            completion(nil)
            return
        }
        
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let abiJson = ABIs.ERCtokenABI.data(using: .utf8) else {
            completion(nil)
            return
        }
        
        do {
            let tokenaddress = tokenDetails.address ?? ""
            print(tokenDetails.address ?? "")
            let contract = try web3.eth.Contract(json: abiJson, abiKey: nil, address: EthereumAddress(hexString: tokenaddress))
            contract["balanceOf"]?(EthereumAddress(hexString: walletAddress)!).call(completion: { resp, error in
                if let error = error {
                    print("Error calling balanceOf: \(error)")
                    completion(nil)
                    return
                }
                
                contract["decimals"]?().call(block: .latest, completion: { data, error in
                    if let error = error {
                        print("Error calling decimals: \(error)")
                        completion(nil)
                        return
                    }
                    
                    let decimal = data?[""] as? UInt8 ?? 18
                    if let bal = resp?[""] as? BigUInt {
                        let etherValue = (Decimal(string: bal.description) ?? 0) / pow(10, Int(decimal))
                        completion("\(etherValue)")
                    } else {
                        completion("0")
                    }
                })
            })
        } catch {
            print("Error creating contract: \(error)")
            completion("0")
        }
    }
    
    /// getDecimal
    func getDecimal(completion: @escaping ((String?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        guard let walletAddress = chain.walletAddress else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        let abiJson =  ABIs.ERCtokenABI.data(using: .utf8)!
        let contract = try? web3.eth.Contract(json: abiJson, abiKey: nil, address: EthereumAddress(hexString: tokenDetails.address!))
        contract?["decimals"]?().call(block: .latest, completion: { data, _ in
            let decimal = data?[""] as? UInt8 ?? 18
            completion("\(decimal)")
        })
    }
    /// sendTokenOrCoin
    func sendTokenOrCoin(_ receiverAddress: String?, tokenAmount: Double, completion: @escaping ((Bool,String?,EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        print("chain",chain)
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let contractAddress = try? EthereumAddress(hex: tokenDetails.address ?? "", eip55: false) else { return   } // Replace with the address of the token contract
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        let abiJson =  ABIs.ERCtokenABI.data(using: .utf8)!
        let contract = try? web3.eth.Contract(json: abiJson, abiKey: nil, address: contractAddress)
        contract?["decimals"]?().call(block: .latest, completion: { data, err in
            let decimal = data?[""] as? UInt8 ?? 0
            web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
                web3.eth.gasPrice { gasPriceResponse in
                    let amount = UnitConverter.convertToWei(tokenAmount, Double(decimal))
                    web3.eth.estimateGas(call: EthereumCall(from: myWalletAddress, to: toWalletAddress, gasPrice: gasPriceResponse.result, value: EthereumQuantity(quantity: BigUInt(amount))), response: { gasLimitRes in
                        let gasLimitEstimate = gasLimitRes.result?.quantity ?? BigUInt(150000)
                       print("gasLimitEstimate",gasLimitEstimate)
                        let bufferPercentage: Double = 10.1
                        let gasLimit = BigUInt(Double(gasLimitEstimate) * bufferPercentage)
                        print("gasLimit",gasLimit)
                        let gasPrice = gasPriceResponse.result?.quantity ?? BigUInt(100)
                        let fee = gasPrice * gasLimit // Calculate the total transaction fee
                        print("fee",fee)
                        let gasAmount = UnitConverter.convertWeiToEther("\(fee)", Int(18)) ?? ""
                        print("gasAmount",gasAmount)
                        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                            
                            var allCoin: [Token] = []
                            print("coindetail",self.tokenDetails)
                            if  self.tokenDetails?.chain?.name == "Arbitrum" &&  self.tokenDetails?.chain?.symbol == "ARB" {
                                        // Special case for Arbitrum + ARB
                                        allCoin = allToken.filter {
                                            $0.type == self.tokenDetails?.type &&
                                            $0.symbol == self.tokenDetails?.chain?.symbol
                                        }
                                    }  else if self.tokenDetails?.chain?.name == "Base" &&  self.tokenDetails?.chain?.symbol == "BASE" {
                                        // Special case for Arbitrum + ARB
                                        allCoin = allToken.filter {
                                            $0.type == self.tokenDetails?.type &&
                                            $0.symbol == self.tokenDetails?.chain?.symbol
                                        }
                                    }else {
                                        // Default case
                                        allCoin = allToken.filter {
                                            $0.type == self.tokenDetails?.type &&
                                            $0.symbol == self.tokenDetails?.chain?.symbol
                                        }
                                    }
//                            let allCoin = allToken.filter{ $0.address == "" && $0.type == self.tokenDetails.type && $0.symbol == chain.symbol }
                            print("allCoin",allCoin)
                            print("chain.symbol",chain.symbol)
                            let chainBal = allCoin.first?.balance ?? ""
                            print("chainBal",allCoin.first?.balance ?? "")
                            print("gasAmount",gasAmount)
                            
                            if (Double(chainBal) ?? 0) < (Double(gasAmount) ?? 0) {
                                print("false")
                                completion(false,ToastMessages.lowFeeBalance("\(chain.name) (\(chain.symbol))"),nil)
                            } else {   do {
                                let transaction = contract?["transfer"]?(toWalletAddress, amount).createTransaction(
                                    nonce: resp.result,
                                    gasPrice: EthereumQuantity(quantity: gasPrice),
                                    maxFeePerGas: nil,
                                    maxPriorityFeePerGas: nil,
                                    gasLimit: EthereumQuantity(quantity: gasLimit),
                                    from: myWalletAddress,
                                    value: 0,
                                    accessList: [:],
                                    transactionType: .legacy
                                )
                                print("transaction",transaction)
                                let signedTx = try transaction?.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""), chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                                print("signedTx",signedTx)
                                try web3.eth.sendRawTransaction(transaction: signedTx!) { (transactionHash) in
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
                                            }  }
                                    } else if let error = transactionHash.error {
                                        print("err1",error.localizedDescription)
                                        completion(false, error.localizedDescription, nil)
                                    } else {
                                        print("err2")
                                        completion(false, "Transaction hash not available", nil)
                                    }  }
                            } catch(let error) {
                                print(error)
                                print("err3",error.localizedDescription)
                                completion(false, error.localizedDescription, nil)
                            }
                            } }  })
                }
            }
        })
    }
    /// swapTokenOrCoin
    func swapTokenOrCoin(_ receiverAddress: String?, gas: String,gasPrice: String,rawData: String, tokenAmount: String,completion: @escaping ((Bool,String?,EthereumData?) -> Void)) {
        
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
            web3.eth.gasPrice { gasPriceResponse in
                let gasPrice = gasPriceResponse.result?.quantity ?? BigUInt(100)
                web3.eth.estimateGas(call: EthereumCall(from: myWalletAddress, to: toWalletAddress, gasPrice: gasPriceResponse.result, data: EthereumData(Bytes(hex: rawData))), response: { gasLimitRes in
                    let gasLimitEstimate = gasLimitRes.result?.quantity ?? chain.defaultGasLimit
                    let bufferPercentage: Double = 10.1
                    let gasLimit = BigUInt(Double(gasLimitEstimate) * bufferPercentage)
                    do {
                        let transaction = EthereumTransaction(nonce: resp.result, gasPrice: EthereumQuantity(quantity: gasPrice), gasLimit: EthereumQuantity(quantity: gasLimit), from: myWalletAddress, to: toWalletAddress, value: 0,data: EthereumData(Bytes(hex: rawData)))
                        let signedTx = try transaction.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""),chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                        try web3.eth.sendRawTransaction(transaction: signedTx) { (transactionHash) in
                            if let txHash = transactionHash.result {
                                fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                    switch result {
                                    case .success(let receiptResponse):
                                        if receiptResponse.result != nil {
                                            if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                completion(true, "Swapping successful", txHash)
                                            } else {
                                                completion(false, "Swapping failed please try again after some time.", txHash)
                                            }
                                        } else {
                                            completion(false, "Transaction receipt not available", txHash)
                                        }
                                    case .failure(let error):
                                        completion(false, error.localizedDescription, txHash)
                                    }  }  } else if let error = transactionHash.error {
                                        completion(false, error.localizedDescription, nil)
                                    } else {
                                        completion(false, "Transaction hash not available", nil)
                                    }  }
                    } catch(let error) {
                        print(error)
                        completion(false,error.localizedDescription,nil)
                    }
                }) } }
    }
    /// sendTokenOrCoinWithLavrageFee
    func sendTokenOrCoinWithLavrageFee(_ receiverAddress: String?, tokenAmount: Double,nonce:String,gasAmount:String,gasLimit:String,completion: @escaping ((Bool,String?,EthereumData?) -> Void)) {
        guard let chain = tokenDetails.chain else { return  }
        let web3 = Web3(rpcURL: chain.rpcURL)
        guard let contractAddress = try? EthereumAddress(hex: tokenDetails.address ?? "", eip55: false) else { return   } // Replace with the address of the token contract
        guard let toWalletAddress = try? EthereumAddress(hex: receiverAddress ?? "" , eip55: false) else { return  }
        guard let myWalletAddress = try? EthereumAddress(hex: chain.walletAddress ?? "", eip55: false) else { return  }
        let abiJson =  ABIs.ERCtokenABI.data(using: .utf8)!
        let contract = try? web3.eth.Contract(json: abiJson, abiKey: nil, address: contractAddress)
        contract?["decimals"]?().call(block: .latest, completion: { data, err in
            let decimal = data?[""] as? UInt8 ?? 0
            web3.eth.getTransactionCount(address: myWalletAddress, block: .latest) { resp in
                web3.eth.gasPrice { gasPriceResponse in
                    let amount = UnitConverter.convertToWei(tokenAmount, Double(decimal))
                    web3.eth.estimateGas(call: EthereumCall(from: myWalletAddress, to: toWalletAddress, gasPrice: gasPriceResponse.result, value: EthereumQuantity(quantity: BigUInt(amount))), response: { gasLimitRes in
                        let txGasLimit: BigInt = UnitConverter.hexStringToBigInteger(hex: gasLimit) ??  BigInt(150000)
                        let gasPrice: BigUInt = BigUInt(gasAmount) ?? BigUInt(30000)
                        let bufferPercentage: Double = 10.1
                        let gasLimit = BigUInt(Double(txGasLimit) * bufferPercentage)
                        let gasNonce = resp.result?.quantity ?? BigUInt(100)
                        let nonce = BigUInt(nonce) ?? gasNonce
                        let fee = gasPrice * gasLimit // Calculate the total transaction fee
                        let gasAmount = UnitConverter.convertWeiToEther("\(fee)", Int(18)) ?? ""
                        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                            let allCoin = allToken.filter{ $0.address == "" && $0.type == self.tokenDetails.type && $0.symbol == chain.symbol }
                            let chainBal = allCoin.first?.balance ?? ""
                            if (Double(chainBal) ?? 0) < (Double(gasAmount) ?? 0) {
                                completion(false,ToastMessages.lowFeeBalance("\(chain.name) (\(chain.symbol))"),nil)
                            } else {  do {
                                let transaction = contract?["transfer"]?(toWalletAddress, amount).createTransaction(
                                    nonce:EthereumQuantity(quantity: nonce) ,
                                    gasPrice: EthereumQuantity(quantity: gasPrice),
                                    maxFeePerGas: nil,
                                    maxPriorityFeePerGas: nil,
                                    gasLimit: EthereumQuantity(quantity:gasLimit),
                                    from: myWalletAddress,
                                    value: 0,
                                    accessList: [:],
                                    transactionType: .legacy
                                )
                                let signedTx = try transaction?.sign(with: EthereumPrivateKey(hexPrivateKey: chain.privateKey ?? ""), chainId: EthereumQuantity(quantity: BigUInt(Int(chain.chainId) ?? 0)))
                                try web3.eth.sendRawTransaction(transaction: signedTx!) { (transactionHash) in
                                    if let txHash = transactionHash.result {
                                        fetchTransactionReceiptWithRetry(transactionHash: txHash, web3: web3) { result in
                                            switch result {
                                            case .success(let receiptResponse):
                                                if receiptResponse.result != nil {
                                                    if receiptResponse.status.result??.status?.quantity == BigUInt(1) {
                                                        completion(true, "Send successful", txHash)
                                                    } else {
                                                        completion(false, "Send failed please try again after some time.", txHash)
                                                    } } else {
                                                        completion(false, "Transaction receipt not available", txHash)
                                                    }
                                            case .failure(let error):
                                                completion(false, error.localizedDescription, txHash)
                                            } }
                                    } else if let error = transactionHash.error {
                                        completion(false, error.localizedDescription, nil)
                                    } else {
                                        completion(false, "Transaction hash not available", nil)
                                    }  }
                            } catch(let error) {
                                print(error)
                                completion(false, error.localizedDescription, nil)
                            }  }  } }) }  }
        })
    }
    func sendTokenOrCoinFromWalletConect(_ receiverAddress: String?, tokenAmount: Double,gasLimit: BigInt,rawData: String,isGettingTransactionHash:Bool?, completion: @escaping ((Bool, String?,BigInt?,BigInt?,BigInt?, EthereumData?) -> Void)) {
       
    }
}
func fetchTransactionReceiptWithRetry(transactionHash: EthereumData, web3: Web3, completion: @escaping (Result<Web3Response<EthereumTransactionReceiptObject?>, Error>) -> Void) {
    
    web3.eth.getTransactionReceipt(transactionHash: transactionHash) { receiptResponse in
        if receiptResponse.error != nil {
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                fetchTransactionReceiptWithRetry(transactionHash: transactionHash, web3: web3, completion: completion)
            } } else {
            completion(.success(receiptResponse))
        } }

}
// swiftlint:enable type_body_length
