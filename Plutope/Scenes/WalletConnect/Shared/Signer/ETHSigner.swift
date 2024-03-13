import Foundation
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

    mutating func sendTransaction(_ request: Request) ->AnyCodable {
        
        let params = request.params
        print(params)
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
        var trasHash : EthereumData? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        
        if(value == 0) {
            switch chainId {
            case "56":
             //   tokenName = Chain.binanceSmartChain.name
                self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.binance  }
            case "1":
              //  tokenName = Chain.ethereum.name
                self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.ethereum  }
            case "137":
               // tokenName = Chain.polygon.name
                self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.polygon  }
            case "66":
              //  tokenName =  Chain.oKC.name
                self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.okxchain  }
            default:
                break
            }
            
            var coinDetailObj = self.tokensList?.first
            print("coinDetailObj",coinDetailObj)
            var trasHash : EthereumData? = nil
            
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.main.async {
                print("coinDetailObj",coinDetailObj)
                if coinDetailObj != nil {
                coinDetailObj?.callFunction.signAndSendTranscation(to, gasLimit:  BigUInt(gas) ?? BigUInt(21000), gasPrice: "", txValue: 0, rawData: data ,  completion: { status,transfererror,dataResult  in
                    if status {
                        
                        DispatchQueue.main.async {
                            print("success")
                            print(dataResult!.hex())
                            trasHash = dataResult
                            semaphore.signal()
                        }
                    }
                })
                } else {
                    print("coinDetailObj null")
                }
                
            }
        } else {
            
            switch chainId {
            case "56":
             //   tokenName = Chain.binanceSmartChain.name
                self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.binance && $0.address == "" && $0.symbol == "BNB" }
            case "1":
               // tokenName = Chain.ethereum.name
                self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.ethereum && $0.address == "" && $0.symbol == "ETH" }
               
            case "137":
               // tokenName = Chain.polygon.name
                self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.polygon && $0.address == "" && $0.symbol == "MATIC" }
            case "66":
               // tokenName =  Chain.oKC.name
                self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.okxchain && $0.address == "" && $0.symbol == "OKT" }
            default:
                break
            }
            
//            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.polygon && $0.address == "" && $0.symbol == "MATIC" }
            var coinDetailObj = self.tokensList?.first
            print("coinDetailObj",coinDetailObj)
            DispatchQueue.main.async {
               
                let txtVallue : Double = Double(UnitConverter.convertWeiToEther(value.description , 18) ?? "0" ) ?? 0.0
                  //var coi
                if coinDetailObj != nil {
                    coinDetailObj?.callFunction.sendTokenOrCoin(to, tokenAmount: txtVallue , completion: { status,transfererror,dataResult  in
                        if status {
                            
                            DispatchQueue.main.async {
                                print("success")
                                print(dataResult!.hex())
                                trasHash = dataResult
                                semaphore.signal()
                            }
                        }
                    })
                } else {
                 print("NoData")
                }

                
            }
        }
        semaphore.wait()
        return AnyCodable(trasHash!.hex() )
       
    }
    
    private func dataToHash(_ message: String) -> Bytes {
        let prefix = "\u{19}Ethereum Signed Message:\n"
        let messageData = Data(hex: message)
        let prefixData = (prefix + String(messageData.count)).data(using: .utf8)!
        let prefixedMessageData = prefixData + messageData
        let dataToHash: Bytes = .init(hex: prefixedMessageData.toHexString())
        return dataToHash
    }
}
