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
        var fromCurrencyv = ""
        var toCurrencyv = ""
        if fromCurrencyv == "pop" {
            fromCurrencyv = "matic"
        } else {
            fromCurrencyv = fromCurrency
        }
        if toCurrencyv == "pol" {
            toCurrencyv = "matic"
        } else {
            toCurrencyv = toCurrency
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
                    case .opMainnet:
                        return "OPTIMISM"
                    case .avalanche:
                        return "AVAX"
                    case .arbitrum:
                        return "ARBITRUM"
                    case.base:
                        return "BASE"
//                    case .tron:
//                        return "TRON"
//                    case .solana:
//                        return "Solana"
                    case .none:
                        return ""
                    
                    }
               
                }
        func toTokenChain() -> String? {
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
            case .opMainnet:
                return "OPTIMISM"
            case .avalanche:
                return "AVAX"
            case .arbitrum:
                return "ARBITRUM"
            case.base:
                return "BASE"
//            case .tron:
//                return "TRON"
//            case .solana:
//                return "Solana"
            case .none:
                return ""
            }
        }
        let payTokenAddress = (fromToken.address ?? "") == "" ? StringConstants.defaultAddress : fromToken.address ?? ""
        let getTokenAddress = (toToken.address ?? "") == "" ? StringConstants.defaultAddress : toToken.address ?? ""
        
        print("payTokenAddress",payTokenAddress)
        print("getTokenAddress",getTokenAddress)
        var toNetwork: String? {
            return toTokenChain()
                }
        var fromTokenSymbol = ""
        var toTokenSymbol = ""
        if fromToken.symbol == "POL" {
            fromTokenSymbol = "MATIC"
        } else {
            fromTokenSymbol = fromToken.symbol ?? ""
        }
        if toToken.symbol == "POL" {
            toTokenSymbol = "MATIC"
        } else {
            toTokenSymbol = toToken.symbol ?? ""
        }
        let param = ["fromBlockchain":fromNetwork,
                     "fromTokenSymbol":fromTokenSymbol,
                     "fromTokenAddress":payTokenAddress,
                     "toBlockchain": toNetwork,
                     "toTokenSymbol": toTokenSymbol,
                     "toTokenAddress":getTokenAddress ,
                     "walletAddress": walletAddress,
                     "price": fromAmount,
                     "fromWalletAddress":fromWalletAddress,
                     "toWalletAddress":toWalletAddress
        ]
        print(param)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL:"https://plutope.app/api/rango-swap-exchange"), HttpMethod: .post, parameters: param as [String : Any], headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print("error",error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                print("error1",error?.rawValue ?? "")
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
    
    func apiGetExodusTransactionStatus(_ transactionID: String?,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        let baseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let clientVersion = ServiceNameConstant.BaseUrl.clientVersion
        let subUrl = ServiceNameConstant.exodusSwapSingleOrders
        let apiUrl = "\(baseUrl)\(clientVersion)\(subUrl)/\(transactionID ?? "")"
//    https://plutope.app/api/exodus-swap-single-orders/knp0NOvbQg08rzX
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
    func apiUpdateExodusTransactionStatus(_ transactionID: String?,id:String?,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        let baseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let clientVersion = ServiceNameConstant.BaseUrl.clientVersion
        let subUrl = ServiceNameConstant.exodusSwapUpdateOrders
        let apiUrl = "\(baseUrl)\(clientVersion)\(subUrl)"
        
        let param = ["id":id,
                     "transactionId":transactionID]
        print(param)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: param as [String : Any], headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data ?? Data())
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
        let baseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let clientVersion = ServiceNameConstant.BaseUrl.clientVersion
        let subUrl = ServiceNameConstant.okxSwapTranscation
        let apiUrl = "\(baseUrl)\(clientVersion)\(subUrl)?fromTokenAddress=\(fromTokenAddress)&toTokenAddress=\(toTokenAddress)&amount=\(amount)&chainId=\(chainId)&userWalletAddress=\(userWalletAddress)&slippage=\(slippage)"
        print("okxTransactionURL ==",apiUrl)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
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
    func apiOKTApproveSwap(tokenContractAddress: String, approveAmount: String, chainId: String, completion: @escaping ((Bool, String, [String: Any]?) -> Void)) {
       
        let baseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let clientVersion = ServiceNameConstant.BaseUrl.clientVersion
        let subUrl = ServiceNameConstant.okxApproveTranscation
        let apiUrl = "\(baseUrl)\(clientVersion)\(subUrl)?amount=\(approveAmount)&chainId=\(chainId)&tokenContractAddress=\(tokenContractAddress)&approveAmount=\(approveAmount)"
        print("okxaproveURL ==",apiUrl)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
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
    
//    func apiGetExchangePairs(fromCurrency: String,fromNetwork: String,toNetwork: String,completion: @escaping (([ExchangePairsData]?,Bool,String) -> Void)) {
//        var fromCurrencyUpdate = fromCurrency
//        if(fromCurrencyUpdate == "bsc-usd") {
//            fromCurrencyUpdate = "usdt"
//        }
//        let apiUrl = "https://api.changenow.io/v2/exchange/available-pairs?fromCurrency=\(fromCurrencyUpdate)&fromNetwork=\(fromNetwork)&toNetwork=\(toNetwork)"
//        
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: APIKey.changeNowAPIHeader) { status, error, data in
//            if status {
//                do {
//                    let pairData = try JSONDecoder().decode([ExchangePairsData].self, from: data ?? Data())
//                    let pairsList = pairData
//                    
//                    completion(pairsList,true,"")
//                    print(pairData)
//                } catch(let error) {
//                    completion(nil,false,error.localizedDescription)
//                    print(error)
//                }
//            } else {
//                completion(nil,false,error?.rawValue ?? "")
//                print(error as Any)
//                //                self.apiGetExchangePairs(fromCurrency: fromCurrency, fromNetwork: fromNetwork, toNetwork: toNetwork, completion: completion)
//            }
//        }
//    }
    
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
    
    func exchangeOkxRangoSwapQuote(parameters: SwapQuoteParameters,completion: @escaping ((Bool,String,[SwapMeargedDataList]?) -> Void)) {
        
        let param: [String: Any] = [
           "changeNow": [
                "fromCurrency": parameters.fromCurrency ?? "",
                "toCurrency": parameters.toCurrency ?? "",
                "fromNetwork": parameters.fromNetwork ?? "",
                "toNetwork": parameters.toNetwork ?? "",
                "fromAmount": parameters.fromAmount ?? "",
                "toAmount": parameters.toAmount ?? "",
                "address": parameters.address ?? ""
            ],
            "okx": [
                "amount": parameters.amountToPay,
                "chainId": parameters.chainId,
                "toTokenAddress": parameters.toTokenAddress,
                "fromTokenAddress": parameters.fromTokenAddress,
                "slippage": parameters.slippage,
                "userWalletAddress": parameters.address
                
            ],
             "rango": [
                "fromBlockchain": parameters.fromBlockchain,
                "fromTokenSymbol": parameters.fromTokenSymbol,
                "toBlockchain": parameters.toBlockchain,
                "toTokenSymbol": parameters.toTokenSymbol,
                "rangotoTokenAddress": parameters.rangotoTokenAddress,
                "fromWalletAddress": parameters.fromWalletAddress,
                "toWalletAddress" : parameters.toWalletAddress,
                "price": parameters.price,
                "fromTokenAddress" : parameters.fromTokenAddress,
                "toTokenAddress": parameters.toTokenAddress
                
             ],
           "amount": parameters.mainAmount ?? "",
           "amountInGwei": parameters.amountToPay ?? "",
           "toBlockchain": parameters.toBlockchain ?? "",
           "toTokenAddress": parameters.toTokenAddress ?? "",
           "toTokenSymbol": parameters.toTokenSymbol ?? "",
           "toWalletAddress": parameters.address ?? "",
           "fromBlockchain": parameters.fromBlockchain ?? "",
           "fromTokenAddress": parameters.fromTokenAddress ?? "",
           "fromTokenSymbol": parameters.fromTokenSymbol ?? "",
           "fromWalletAddress": parameters.fromWalletAddress ?? ""
          
        ]
        print("mixProviderParams :==",param)
      // Now you can use this dictionary in your API request
        let appUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.swapQuote
        print(appUrl)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL:appUrl), HttpMethod: .post, parameters: param as [String : Any], headers: nil) { status, error, data in
            
            if status {
                do {
                    let resultData = try JSONDecoder().decode(SwapMeargedData.self, from: data ?? Data())
                    completion(true,"",resultData.data)
                    
                } catch(let error) {
                    completion(false,error.localizedDescription,nil)
                    print(error)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
                print(error as Any)
            }

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
