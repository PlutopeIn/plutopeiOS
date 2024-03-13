//
//  SwapingRepo.swift
//  Plutope
//
//  Created by Mitali Desai on 22/05/23.
//
import Foundation
import DGNetworkingServices
import CryptoSwift

class SwappingRepo {
    
    func apiSwapping(address: String,fromCurrency: String,toCurrency: String,fromNetwork: String,toNetwork: String,fromAmount: String,toAmount: String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        var defaultFromToken = ""
        if address == "" {
            defaultFromToken = StringConstants.defaultAddress
        } else {
            defaultFromToken = address
        }
        let param = ["fromCurrency": fromCurrency,
                     "toCurrency": toCurrency,
                     "fromNetwork": fromNetwork,
                     "toNetwork": toNetwork,
                     "fromAmount": fromAmount,
                     "toAmount": toAmount,
                     "address": address]
        print("ChangeNowParam",param)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://api.changenow.io/v2/exchange"), HttpMethod: .post, parameters: param, headers: APIKey.changeNowAPIHeader) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    /// apiRangoQuoteSwapping
    func apiRangoQuoteSwapping(walletAddress: String,fromToken: Token,toToken: Token,fromAmount: String,fromWalletAddress:String,toWalletAddress:String,completion: @escaping ((Bool,String,String,Route?) -> Void)) {
        
                var fromNetwork: String? {
                    switch fromToken.chain {
        
                    case .ethereum :
                        return "ETH"
                    case .binanceSmartChain :
                        return "BNB"
                    case .oKC:
                        return "OKT"
                    case .polygon:
                        return "POLYGON"
                    case .bitcoin:
                        return "BTC"
                    case .none:
                        return ""
                    
                    }
                }
                var toNetwork: String? {
                    switch toToken.chain {
        
                    case .ethereum :
                        return "ETH"
                    case .binanceSmartChain :
                        return "BNB"
                    case .oKC:
                        return "OKT"
                    case .polygon:
                        return "POLYGON"
                    case .bitcoin:
                        return "BTC"
                    case .none:
                        return ""
                   
                    }
                    
                }
        var defaultFromToken = ""
        var defaultToToken = ""
        if fromToken.address == "" {
            defaultFromToken = StringConstants.defaultAddress
        } else {
            defaultFromToken = fromToken.address ?? ""
        }
        if toToken.address == "" {
            defaultToToken = StringConstants.defaultAddress
        } else {
            defaultToToken = toToken.address ?? ""
        }
        let param = ["fromBlockchain":fromNetwork,
                     "fromTokenSymbol":fromToken.symbol,
                     "fromTokenAddress":defaultFromToken,
                     "toBlockchain": toNetwork,
                     "toTokenSymbol": toToken.symbol,
                     "toTokenAddress":defaultToToken ,
                     "walletAddress": walletAddress,
                     "price": fromAmount,
                     "fromWalletAddress":fromWalletAddress,
                     "toWalletAddress":toWalletAddress
                     
        ]
        print("Rangoparams=",param)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL:"https://plutope.app/api/rango-swap-quote"), HttpMethod: .post, parameters: param as [String : Any], headers: nil) { status, error, data in
            if status {
                do {
                    let jsonData = try JSONDecoder().decode(RangoSwapData.self, from: data ?? Data())
                    
                   // let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,jsonData.error ?? "",jsonData.resultType ?? "",jsonData.route)
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,"",nil)
                }
            } else {
                completion(false,error?.rawValue ?? "","",nil)
            }
        }
    }
    /// apiRangoSwapping
    func apiRangoSwapping(walletAddress: String,fromToken: Token,toToken: Token,fromAmount: String,fromWalletAddress:String,toWalletAddress:String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
                var fromNetwork: String? {
                    switch fromToken.chain {
        
                    case .ethereum :
                        return "ETH"
                    case .binanceSmartChain :
                        return "BSC"
                    case .oKC:
                        return "OKT"
                    case .polygon:
                        return "POLYGON"
                   
                    case .bitcoin:
                        return "BTC"
                    case .none:
                        return ""
                    }
                }
                var toNetwork: String? {
                    switch toToken.chain {
        
                    case .ethereum :
                        return "ETH"
                    case .binanceSmartChain :
                        return "BSC"
                    case .oKC:
                        return "OKT"
                    case .polygon:
                        return "POLYGON"
                   
                    case .bitcoin:
                        return "BTC"
                    case .none:
                        return ""
                    }
                }
        
        let param = ["fromBlockchain":fromNetwork,
                     "fromTokenSymbol":fromToken.symbol,
                     "fromTokenAddress":fromToken.address,
                     "toBlockchain": toNetwork,
                     "toTokenSymbol": toToken.symbol,
                     "toTokenAddress":toToken.address ,
                     "walletAddress": walletAddress,
                     "price": fromAmount,
                     "fromWalletAddress":fromWalletAddress,
                     "toWalletAddress":toWalletAddress
        ]
        print(param)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL:"https://plutope.app/api/rango-swap"), HttpMethod: .post, parameters: param as [String : Any], headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    func apiGetTransactionStatus(_ transactionID: String?,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        let apiUrl = "https://api.changenow.io/v2/exchange/by-id?id=\(transactionID ?? "")"
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: APIKey.changeNowAPIHeader) { result in
            switch result {
                
            case .success((_, let data)):
                do {
                    let data = try JSONSerialization.jsonObject(with: data)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            case .failure(let error) :
                print(error)
                completion(false,error.localizedDescription,nil)
                
            }
        }
    }
    
    func apiGetCurrencies(completion: @escaping (([TransactionCurrencies]?,Bool,String) -> Void)) {
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://api.changenow.io/v2/exchange/currencies"), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let assetsData = try JSONDecoder().decode([TransactionCurrencies].self, from: data ?? Data())
                    let assetsList = assetsData
                    
                    completion(assetsList,true,"")
                    print(assetsData)
                } catch(let error) {
                    completion(nil,false,error.localizedDescription)
                    print(error)
                }
            } else {
                completion(nil,false,error?.rawValue ?? "")
              //  print(error)
                self.apiGetCurrencies(completion: completion)
            }
        }
        
    }
    
    func apiOKTSwapping(fromTokenAddress: String, toTokenAddress: String, amount: String, chainId: String, userWalletAddress: String, slippage: String, completion: @escaping ((Bool, String, [String: Any]?) -> Void)) {
        performOKTAPIRequest(path: "/api/v5/dex/aggregator/swap",
                             query: "fromTokenAddress=\(fromTokenAddress)&toTokenAddress=\(toTokenAddress)&amount=\(amount)&chainId=\(chainId)&userWalletAddress=\(userWalletAddress)&slippage=\(slippage)",
                             httpMethod: "GET",
                             apiKey: APIKey.okxApiKey,
                             secretKey: APIKey.okxSecretKey,
                             passphrase: APIKey.okxPassphrase,
                             source: "plutope",
                             completion: completion)
    }
    
    func apiOKTApproveSwap(tokenContractAddress: String, approveAmount: String, chainId: String, completion: @escaping ((Bool, String, [String: Any]?) -> Void)) {
        performOKTAPIRequest(path: "/api/v5/dex/aggregator/approve-transaction",
                             query: "tokenContractAddress=\(tokenContractAddress)&approveAmount=\(approveAmount)&chainId=\(chainId)",
                             httpMethod: "GET",
                             apiKey: APIKey.okxApiKey,
                             secretKey: APIKey.okxSecretKey,
                             passphrase: APIKey.okxPassphrase,
                             source: "plutope",
                             completion: completion)
    }
    
    private func performOKTAPIRequest(path: String, query: String, httpMethod: String, apiKey: String, secretKey: String, passphrase: String, source: String, completion: @escaping ((Bool, String, [String: Any]?) -> Void)) {
        let timestamp = Date().toISOString()
        let apiUrl = "https://www.okx.com\(path)?\(query)"
        
        var headers = [String: String]()
        headers["OK-ACCESS-TIMESTAMP"] = timestamp
        
        let requestData = timestamp + httpMethod + path + "?" + query
        let signature = generateHMACSHA256(data: requestData, key: APIKey.okxSecretKey)
//        guard let signature = try? HMAC(key: APIKey.okxSecretKey.bytes, variant: .sha2(.sha512))
//                .authenticate(requestData.bytes) else {
//            print("Failed to generate signature")
//            return
//        }
        
        headers["OK-ACCESS-SIGN"] = signature
        headers["OK-ACCESS-PASSPHRASE"] = passphrase
        headers["source"] = source
        headers["OK-ACCESS-KEY"] = apiKey
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: headers) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true, "", data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false, error.localizedDescription, nil)
                }
            } else {
                completion(false, error?.rawValue ?? "", nil)
            }
        }
    }
    
    func apiGetExchangePairs(fromCurrency: String,fromNetwork: String,toNetwork: String,completion: @escaping (([ExchangePairsData]?,Bool,String) -> Void)) {
        var fromCurrencyUpdate = fromCurrency
        if(fromCurrencyUpdate == "bsc-usd") {
            fromCurrencyUpdate = "usdt"
        }
        let apiUrl = "https://api.changenow.io/v2/exchange/available-pairs?fromCurrency=\(fromCurrencyUpdate)&fromNetwork=\(fromNetwork)&toNetwork=\(toNetwork)"
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: APIKey.changeNowAPIHeader) { status, error, data in
            if status {
                do {
                    let pairData = try JSONDecoder().decode([ExchangePairsData].self, from: data ?? Data())
                    let pairsList = pairData
                    
                    completion(pairsList,true,"")
                    print(pairData)
                } catch(let error) {
                    completion(nil,false,error.localizedDescription)
                    print(error)
                }
            } else {
                completion(nil,false,error?.rawValue ?? "")
                print(error as Any)
                //                self.apiGetExchangePairs(fromCurrency: fromCurrency, fromNetwork: fromNetwork, toNetwork: toNetwork, completion: completion)
            }
        }
    }
    
    // generateHMACSHA256
    private func generateHMACSHA256(data: String, key: String) -> String {
        let keyData = Data(key.utf8)
        let messageData = Data(data.utf8)
        
        do {
            let hmac = try HMAC(key: keyData.bytes, variant: .sha2(.sha256)).authenticate(messageData.bytes)
            let hmacData = Data(hmac)
            return hmacData.base64EncodedString()
        } catch {
            print("HMAC-SHA256 generation failed: \(error)")
            return ""
        }
    }
}

extension Date {
    func toISOString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: self)
    }
}
