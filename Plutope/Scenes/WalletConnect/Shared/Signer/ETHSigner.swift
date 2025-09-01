import Foundation
import CoreData
import Commons
import Web3
import WalletConnectSign



struct TransactionWallet: Codable {
    let from: String
    let gas: String
    let to: String
    let value: String
    let gasPrice: String
    let data: String
    let nonce: String
}
let semaphore = DispatchSemaphore(value: 0)
struct ETHSigner {
    private let importAccount: ImportAccount

    init(importAccount: ImportAccount) {
        self.importAccount = importAccount
    }
    var address: String {
        return privateKey.address.hex(eip55: true)
    }

    private var privateKey: EthereumPrivateKey {
        return try! EthereumPrivateKey(hexPrivateKey: importAccount.privateKey)
    }
    var coinDetail: Token?
    var tokensList: [Token]? = []

    func personalSign(_ params: AnyCodable) -> AnyCodable {
        let params = try? params.get([String].self)
        let messageToSign = params?[0] ?? ""
        let dataToHash = dataToHash(messageToSign)
        let (vrs, rsv, svr) = try! privateKey.sign(message: .init(hex: dataToHash.toHexString()))
        let result = "0x" + rsv.toHexString() + svr.toHexString() + String(vrs + 27, radix: 16)
        return AnyCodable(result)
    }
    func signTypedData(_ params: AnyCodable) -> AnyCodable {
        let result = "0x4355c47d63924e8a72e509b65029052eb6c299d53a04e167c5775fd466751c9d07299936d304c153f6443dfa05f40ff007d72911b6f72307f996231605b915621c"
        return AnyCodable(result)
    }
    
    mutating func getRPCURL(_ chainId: String) -> String {
        switch chainId {
        case "56":
            return DataStore.networkEnv == .mainnet ? "https://bsc-mainnet.nodereal.io/v1/64a9df0874fb4a93b9d0a3849de012d3": "https://bsc-testnet.publicnode.com"
        case "1":
            return DataStore.networkEnv == .mainnet ? "https://ethereum.publicnode.com": "https://goerli.blockpi.network/v1/rpc/public"
        case "137":
            return DataStore.networkEnv == .mainnet ? "https://polygon-rpc.com/": "https://polygon-mumbai.infura.io/v3/4458cf4d1689497b9a38b1d6bbf05e78"
        case "66":
            return DataStore.networkEnv == .mainnet ? "https://exchainrpc.okex.org": "https://exchaintestrpc.okex.org"
        case "10":
            return DataStore.networkEnv == .mainnet ? "https://mainnet.optimism.io" : "https://sepolia.optimism.io"
        case "97":
            return "https://bsc-testnet.publicnode.com"
        case "42161":
            return DataStore.networkEnv == .mainnet ? "https://arb1.arbitrum.io/rpc" : "https://endpoints.omniatech.io/v1/arbitrum/sepolia/public"
        case "43114":
            return DataStore.networkEnv == .mainnet ? "https://avalanche-c-chain-rpc.publicnode.com" : "https://avalanche-fuji-c-chain-rpc.publicnode.com"
        case "8453":
            return "https://base-rpc.publicnode.com"
        default:
            return ""
            
        }
    }
    mutating func getChainID(_ chainId: String) {
        switch chainId {
        case "56":
            //   tokenName = Chain.binanceSmartChain.name
            self.tokensList = tokensList?.filter { $0.chain?.symbol == "BNB"  }
        case "1":
            //  tokenName = Chain.ethereum.name
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.ethereum  }
        case "137":
            // tokenName = Chain.polygon.name
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.polygon  }
        case "66":
            //  tokenName =  Chain.oKC.name
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.okxchain  }
        case "10":
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.optimism  }
        case "97":
            //  tokenName =  Chain.oKC.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.binance && $0.address == "" && $0.symbol == "BNB" }
        case "42161":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.arbitrum}
        case "43114":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.avalancheCChain }
        case "8453":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.base }
        default:
            break
        }
    }
    
    mutating func getTokenChainId(_ chainId: String) {
        switch chainId {
        case "56":
            //   tokenName = Chain.binanceSmartChain.name
            self.tokensList = tokensList?.filter {  $0.chain?.symbol == "BNB"  && $0.address == "" && $0.symbol == "BNB" }
        case "1":
            // tokenName = Chain.ethereum.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.ethereum && $0.address == "" && $0.symbol == "ETH" }
        case "137":
            // tokenName = Chain.polygon.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.polygon && $0.address == "" && $0.symbol == "POL" }
        case "66":
            // tokenName =  Chain.oKC.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.okxchain && $0.address == "" && $0.symbol == "OKT" }
        case "10":
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.optimism  }
        case "97":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.binance && $0.address == "" && $0.symbol == "BNB" }
        case "42161":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.arbitrum && $0.address == "" && $0.symbol == "ARB" }
        case "43114":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.avalancheCChain && $0.address == "" && $0.symbol == "AVAX" }
        case "8453":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.base && $0.address == "" && $0.symbol == "BASE" }
        default:
            break
        }
    }
    
    mutating func sendTransaction(_ request: Request) ->AnyCodable {
        let params = request.params
        var tokenName : String?
        var chainId = request.chainId.reference
        var to = ""
        var from = ""
        var gas = ""
        var value : Int = 0
        var data = ""
        if let jsonArray = params.value as? [[String: Any]] {
            for var item in jsonArray {
                for (key, value) in item {
                    if let hexString = value as? String, key != "to" {
                        if let intValue = Int(hexString.replacingOccurrences(of: "0x", with: ""), radix: 16) {
                            item[key] = intValue
                        }
                    }
                }
                print(item)
                to = item["to"] as? String ?? ""
                gas = item["gas"] as? String ?? ""
                from = item["from"] as? String ?? ""
                value = item["value"] as? Int ?? 0
                data = item["data"] as? String ?? ""
            }
        }
        
        var rpcUrl = ""
        var trasHash : EthereumData? = nil
//        let semaphore = DispatchSemaphore(value: 0)
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        if(value == 0) {
            getChainID(chainId)
            var coinDetailObj = self.tokensList?.first
            print("coinDetailObj",coinDetailObj)
                if coinDetailObj != nil {
                    var gasVallue = (Double(gas) ?? 600000.0) * 1.10
                    
                    coinDetailObj?.callFunction.signAndSendTranscation(to, gasLimit:  BigUInt(gasVallue), gasPrice: BigUInt(0), txValue: BigUInt(0), rawData: data ,  completion: { status,transfererror,dataResult  in
                    if status {
                            DGProgressView.shared.hideLoader()
                            print("success")
                            print(dataResult!.hex())
                            trasHash = dataResult
                        semaphore.signal()
               
                    } else {
                            DGProgressView.shared.hideLoader()
                            print("Failler")
                            print(dataResult)
                            trasHash = dataResult
                            semaphore.signal()
                    }
                })
                } else {
                    print("coinDetailObj null")
                }
        } else {
            getTokenChainId(chainId)
            
//            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.polygon && $0.address == "" && $0.symbol == "MATIC" }

            var coinDetailObj = self.tokensList?.first
            print("coinDetailObj2222",coinDetailObj)
                let txtVallue : Double = Double(UnitConverter.convertWeiToEther(value.description , 18) ?? "0" ) ?? 0.0
                  // var coi
            
                if coinDetailObj != nil {
                    coinDetailObj?.callFunction.sendTokenOrCoin(to, tokenAmount: txtVallue , completion: { status,transfererror,dataResult  in
                        if status {
                                DGProgressView.shared.hideLoader()
                                print("success")
                                print(dataResult!.hex())
                                trasHash = dataResult
                                semaphore.signal()
                        } else {
                                DGProgressView.shared.hideLoader()
                                print("Fail")
                                trasHash = dataResult
                                semaphore.signal()
                        }
                    })
                } else {
                 print("NoData")
                }
        }
        semaphore.wait()
        print("trasHash!.hex() ")
        
        return AnyCodable(trasHash?.hex())
    }
    mutating func sendTransactionWalletConnect(_ request: Request) ->AnyCodable {
        let params = request.params
        var tokenName : String?
        var chainId = request.chainId.reference
        var to = ""
        var from = ""
        var gas : Int = 0
        var value : Int = 0
        var data = ""
        if let jsonArray = params.value as? [[String: Any]] {
            for var item in jsonArray {
                for (key, value) in item {
                    if let hexString = value as? String, key != "to" {
                        if let intValue = Int(hexString.replacingOccurrences(of: "0x", with: ""), radix: 16) {
                            item[key] = intValue
                        }
                    }
                }
                print(item)
                to = item["to"] as? String ?? ""
                gas = item["gas"] as? Int ?? 0
                from = item["from"] as? String ?? ""
                value = item["value"] as? Int ?? 0
                data = item["data"] as? String ?? ""
            }
        }
        
        var trasHash : EthereumData? = nil
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        getTokenChainId(chainId)

            var coinDetailObj = self.tokensList?.first
            print("coinDetailObj2222",coinDetailObj)
                let txtVallue : Double = Double(UnitConverter.convertWeiToEther(value.description , 18) ?? "0" ) ?? 0.0
                if coinDetailObj != nil {
                    coinDetailObj?.callFunction.sendTokenOrCoinFromWalletConect(to, tokenAmount: txtVallue ,gasLimit:BigInt(gas), rawData: data,isGettingTransactionHash: true, completion: { status,transfererror,gaslimit,gasprice,nonce,dataResult  in
                        if status {
                                DGProgressView.shared.hideLoader()
                                print("success")
                                print(dataResult!.hex())
                                trasHash = dataResult
                                semaphore.signal()
                        } else {
                                DGProgressView.shared.hideLoader()
                                print("Fail")
                                trasHash = dataResult
                                semaphore.signal()
                        }
                    })
                } else {
                    DGProgressView.shared.hideLoader()
                 print("NoData")
                }
        
        semaphore.wait()
        print("trasHash!.hex() ")
        
        return AnyCodable(trasHash?.hex())
    }
    // [UInt8]
    private func dataToHash(_ message: String) -> [UInt8] {
        let prefix = "\u{19}Ethereum Signed Message:\n"
        let messageData = Data(hex: message)
        let prefixData = (prefix + String(messageData.count)).data(using: .utf8)!
        let prefixedMessageData = prefixData + messageData
        let dataToHash: [UInt8] = .init(hex: prefixedMessageData.toHexString())
        return dataToHash
    }
}
