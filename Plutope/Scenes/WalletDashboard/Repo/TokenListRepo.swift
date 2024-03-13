//
//  TokenListRepo.swift
//  PlutoPe
//
//  Created by Mitali Desai on 08/05/23.
//
import Foundation
import DGNetworkingServices

/// TokenListRepo
class TokenListRepo {
    
    /// apiGetTokenAssets
    func apiGetTokenAssets(_ symbolList: [Token], completion: @escaping (([String: AssetsList]?,Bool,String) -> Void)) {
        
        var symbols = symbolList.compactMap {$0.symbol }
        symbols = Array(Set(symbols ))
        
        symbols.removeAll(where: { coins in
            if coins == "BOBAETH" {
                return true
            } else {
                return false
            }
        })
        
        print(symbols.joined(separator: ",") )
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=\(symbols.joined(separator: ","))"), HttpMethod: .get, parameters: nil, headers: APIKey.coinMarketAPIHeader) { result in
            
            switch result {
                
            case .success((_, let response)):
                
                do {
                    let assetsData = try JSONDecoder().decode(AssetsData.self, from: response)
                    let assetsList = assetsData.data
                    
                    completion(assetsList,true,"")
                    print(assetsData)
                    
                } catch(let error) {
                    completion(nil,false,error.localizedDescription)
                    print(error)
                }
                
            case .failure(let error):
                completion(nil,false,error.rawValue)
                print(error)
                self.apiGetTokenAssets(symbolList, completion: completion)
            }
        }
    }
    
    /// apiGetCoinPrice
    func apiGetCoinPrice(_ currency: String,_ symbolList: [String],completion: @escaping (([String: AssetsList]?,Bool,String) -> Void)) {
        
        // Iterate through each string in the array
        var symbolList = symbolList
        for index in 0..<symbolList.count {
            let modifiedString = symbolList[index].replacingOccurrences(of: "+", with: "")
            symbolList[index] = modifiedString
        }
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?convert=\(currency)&symbol=\(symbolList.joined(separator: ","))"), HttpMethod: .get, parameters: nil, headers: APIKey.coinMarketAPIHeader) { result in
            switch result {
                
            case .success((_, let response)):
                
                do {
                    let assetsData = try JSONDecoder().decode(AssetsData.self, from: response)
                    let assetsList = assetsData.data
                    completion(assetsList,true,"")
                    print(assetsData)
                    
                } catch(let error) {
                    completion(nil,false,error.localizedDescription)
                    print(error)
                }
                
            case .failure(let error):
                completion(nil,false,error.rawValue)
                print(error)
                // self.apiGetCoinPrice(currency,symbolList, completion: completion)
            }
        }
    }
    
    func apiGetTokenImagesFromApi(completion: @escaping (([BackendTokenList]?,Bool,String) -> Void)) {
  //  https://paloilapp.com/Laravel/public/list-coin
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://plutope.app/api/get-all-images"), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONDecoder().decode([BackendTokenList].self, from: data!)
                    completion(data,true,"")
                } catch(let error) {
                    print(error)
                    completion(nil,false,error.localizedDescription)
                }
            } else {
                completion(nil,false,error?.rawValue ?? "")
            }
        }
    }
    
    func apiGetBitcoinBalance(walletAddress:String,completion: @escaping ((Double) -> Void)) {
  
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://plutope.app/api/btc-balance?address=\(walletAddress)"), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONDecoder().decode(BitcoinWalletData.self, from: data!)
                    completion(data.balance ?? 0.0)
                    
                } catch(let error) {
                    print(error)
                    completion(0.0)
                }
            } else {
                completion(0.0)
            }
        }
    }
    
    func apiGetActiveTokens(walletAddress:String,completion: @escaping (([ActiveTokens]?,Bool) -> Void)) {
  
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://plutope.app/api/get-wallet-tokens/\(walletAddress)"), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONDecoder().decode([ActiveTokens].self, from: data!)
                    completion(data,true)
                    
                } catch(let error) {
                    print(error)
                    completion(nil,false)
                }
            } else {
                completion(nil,false)
            }
        }
    }
}
